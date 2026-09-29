-- ============================================================================
-- Bonus questions 9-11 (Claude_and_Lahman exercise), PostgreSQL
-- Run against the class "lahman" database (seasons 1871-2016).
-- The Excel workbook lahman_TSN_managers.xlsx reproduces every number below with formulas.
-- ============================================================================


-- ----------------------------------------------------------------------------
-- Q9. Which team(s) had the most World Series wins in each decade?
--     teams.wswin = 'Y' flags the World Series winner. Grouped by FRANCHISE so moves/renames stay together.
--     RANK() keeps ties: every franchise on the maximum for the decade is returned.
-- ----------------------------------------------------------------------------
WITH wins AS (
    SELECT (yearid / 10) * 10 AS decade,           -- integer division: 1957 -> 195 -> 1950
           franchid,
           COUNT(*)           AS ws_wins
    FROM teams
    WHERE wswin = 'Y'
    GROUP BY decade, franchid
),
ranked AS (
    SELECT *, RANK() OVER (PARTITION BY decade ORDER BY ws_wins DESC) AS rk
    FROM wins
)
SELECT r.decade, r.franchid, f.franchname, r.ws_wins
FROM ranked AS r
INNER JOIN teamsfranchises AS f USING (franchid)
WHERE r.rk = 1
ORDER BY r.decade, r.franchid;
-- Result (16 rows, because of two ties):
--   1880 SFG 2 | 1900 CHC 2 | 1910 BOS 4 | 1920 NYY 3 | 1930 NYY 5 | 1940 NYY 4 | 1950 NYY 6
--   1960 LAD 2, NYY 2, STL 2 (three-way tie) | 1970 OAK 3 | 1980 LAD 2 | 1990 NYY 3
--   2000 BOS 2, NYY 2 (tie) | 2010 SFG 3
-- Caveats: 1880s are the pre-modern 1884-89 series; no series in the 1890s; the 1900s start in 1903;
--          1994 was cancelled; the data stops in 2016 (7 series in the 2010s).


-- ----------------------------------------------------------------------------
-- Q10. Median total career salary for players with 1, 2, 3 and 4 years of college baseball.
--      College years = DISTINCT seasons in collegeplaying (two schools in one year count once).
--      Total career salary = SUM of all salaries rows (1985-2016 only, nominal dollars).
-- ----------------------------------------------------------------------------
WITH college AS (
    SELECT playerid, COUNT(DISTINCT yearid) AS college_years
    FROM collegeplaying
    GROUP BY playerid
),
pay AS (
    SELECT playerid, SUM(salary) AS career_salary
    FROM salaries
    GROUP BY playerid
)
SELECT c.college_years,
       COUNT(*)                                                       AS players,
       PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY p.career_salary)   AS median_career_salary,
       ROUND(AVG(p.career_salary))                                    AS mean_career_salary
FROM college AS c
INNER JOIN pay AS p USING (playerid)
WHERE c.college_years BETWEEN 1 AND 4
GROUP BY c.college_years
ORDER BY c.college_years;
-- Result:
--   1 yr  315 players  median $1,534,600   mean  $8,489,448
--   2 yrs 477 players  median $1,363,000   mean  $9,620,461
--   3 yrs 1388 players median $1,767,750   mean $10,797,267
--   4 yrs 492 players  median $1,008,750   mean  $5,814,290
-- No steady trend (Pearson r between college years and total salary is about -0.03).
-- Caveats: salaries only cover 1985-2016 and only 2,677 of 6,575 college players have any salary row;
--          careers that started before 1985 or were still going in 2016 are partial; dollars are not inflation-adjusted.


-- ----------------------------------------------------------------------------
-- Q11. Is home attendance more correlated with team home runs or team wins?
--      teams.attendance = total home attendance for the season (missing for ~280 older team-seasons).
-- ----------------------------------------------------------------------------

-- (a) Pooled: every team-season in one sample (mixes eras)
SELECT COUNT(*)                                   AS team_seasons,
       ROUND(CORR(attendance, hr)::numeric, 3)    AS r_home_runs,
       ROUND(CORR(attendance, w)::numeric, 3)     AS r_wins
FROM teams
WHERE attendance > 0;
-- Result: 2556 team-seasons, r(HR) = 0.728, r(Wins) = 0.399   <- looks like home runs

-- (b) Within-season: compare each team with that season's league-wide average, then correlate.
--     This removes the era trend (attendance and home runs both rose for decades).
WITH dev AS (
    SELECT yearid,
           attendance - AVG(attendance) OVER (PARTITION BY yearid) AS att_dev,
           hr         - AVG(hr)         OVER (PARTITION BY yearid) AS hr_dev,
           w          - AVG(w)          OVER (PARTITION BY yearid) AS w_dev
    FROM teams
    WHERE attendance > 0
)
SELECT COUNT(*)                                   AS team_seasons,
       ROUND(CORR(att_dev, hr_dev)::numeric, 3)   AS r_home_runs,
       ROUND(CORR(att_dev, w_dev)::numeric, 3)    AS r_wins
FROM dev;
-- Result: 2556 team-seasons, r(HR) = 0.281, r(Wins) = 0.475   <- wins is the stronger link

-- (c) Modern era only (pooled, 2000-2016): wins also leads
SELECT COUNT(*)                                   AS team_seasons,
       ROUND(CORR(attendance, hr)::numeric, 3)    AS r_home_runs,
       ROUND(CORR(attendance, w)::numeric, 3)     AS r_wins
FROM teams
WHERE attendance > 0 AND yearid >= 2000;
-- Result: 510 team-seasons, r(HR) = 0.195, r(Wins) = 0.484
