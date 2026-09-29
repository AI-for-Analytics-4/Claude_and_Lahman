-- Claude_and_Lahman main question. Run in a Query Tool on the lahman database.
-- Result: 6 rows. Davey Johnson (1997 AL BAL, 2012 NL WAS), Jim Leyland (1988/1990/1992 NL PIT, 2006 AL DET).

-- Managers who won the TSN Manager of the Year in BOTH the AL and the NL,
-- with the team each was managing in each winning season.
WITH tsn_winners AS (
    -- One row per winning manager-season-league.
    SELECT playerid, yearid, lgid
    FROM awardsmanagers
    WHERE awardid = 'TSN Manager of the Year'
      AND lgid IN ('AL', 'NL')            -- pre-1986 winners are stored as 'ML' (both leagues), so they drop out here
),
both_leagues AS (
    -- Managers who appear with more than one distinct league.
    SELECT playerid
    FROM tsn_winners
    GROUP BY playerid
    HAVING COUNT(DISTINCT lgid) = 2
)
SELECT p.namefirst, p.namelast,
       w.yearid, w.lgid, m.teamid, t.name AS team
FROM tsn_winners AS w
INNER JOIN both_leagues AS bl ON bl.playerid = w.playerid
INNER JOIN people       AS p  ON p.playerid  = w.playerid
-- managers is keyed (yearid, teamid, inseason): a manager fired/hired mid-year can have 2+ rows,
-- so match on player + year + league to find his team(s) that season.
INNER JOIN managers     AS m  ON m.playerid = w.playerid AND m.yearid = w.yearid AND m.lgid = w.lgid
INNER JOIN teams        AS t  ON t.yearid = m.yearid AND t.teamid = m.teamid AND t.lgid = m.lgid
ORDER BY p.namelast, w.yearid;
