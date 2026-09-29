# Claude_and_Lahman submission: Juan Zavala

## Question
Which managers won the TSN Manager of the Year award in **both** the American League and the National League, and which team were they managing each time they won?

## Answer
Two managers, with 6 winning seasons between them:

| Manager | Year | League | Team |
| --- | --- | --- | --- |
| Davey Johnson | 1997 | AL | Baltimore Orioles |
| Davey Johnson | 2012 | NL | Washington Nationals |
| Jim Leyland | 1988 | NL | Pittsburgh Pirates |
| Jim Leyland | 1990 | NL | Pittsburgh Pirates |
| Jim Leyland | 1992 | NL | Pittsburgh Pirates |
| Jim Leyland | 2006 | AL | Detroit Tigers |

## Files
| File | What it is |
| --- | --- |
| `tsn_both_leagues.sql` | PostgreSQL query for the main question |
| `bonus_questions.sql` | PostgreSQL queries for bonus questions 9–11, with results in comments |
| `people.csv`, `managers.csv`, `awardsmanagers.csv` | `SELECT * FROM <table>` exports used for the Excel version |
| `lahman_TSN_managers.xlsx` | Excel answer built only from the CSVs with formulas. Includes an Overview sheet, charts and caveats, plus the bonus questions |

## How to reproduce
1. Restore `lahman.backup` into a PostgreSQL database named `lahman`.
2. Run `tsn_both_leagues.sql`, which should return 6 rows, and `bonus_questions.sql`.
3. Open `lahman_TSN_managers.xlsx`. The answer is on `TSN_both_leagues`, and the method is on `Overview`.

## Caveats
- `awardsmanagers` holds both the BBWAA and the TSN awards, so the query filters on `awardid = 'TSN Manager of the Year'`.
- Before 1986, TSN gave one award for all of MLB, stored as `lgid = 'ML'`. Those winners can't count as AL or NL, so they are excluded. Counting them would change the answer.
- `managers` has one row per team stint, so a manager who changed teams mid-season can appear twice in a year. None of these winners did.
- The data covers seasons through 2016.

## Bonus answers (details in `bonus_questions.sql`)
- **Q9. Most World Series wins by decade:** 16 rows, including ties in the 1960s and 2000s. The Yankees lead the most decades.
- **Q10. Median career salary by years of college:** 1 yr $1.53M, 2 yrs $1.36M, 3 yrs $1.77M, 4 yrs $1.01M. There's no steady trend, and salaries only cover 1985–2016.
- **Q11. Attendance vs home runs or wins:** Pooled over all years, home runs look stronger (r = 0.73 vs 0.40). Comparing each team with its own season removes the era trend, and wins becomes the stronger link (0.48 vs 0.28).
