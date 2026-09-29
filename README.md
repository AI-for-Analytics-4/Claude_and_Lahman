# Claude_lahman

In this exercise we will see how was can use Claude desktop as a source to help create SQL queries.

1. Start by passing the Claude desktop app a copy of the Lahman ERD.  Ask for an interpretation of the ERD if it does not give one.

2. Write a prompt to ask Claude which tables would be necessary to learn the first and last name of every manager who ever won the TSN Manager of the Year award for both the NL and AL including the teams they were representing for that year.

3. Claude should tell you will need the awardsmanager, manager, and people tables at least.   Write a simple query for these 3 tables one at a time and download the realated csv.  Rename the csv to match the table they represent.   Set these csv aside for now.

4. Write a prompt to instruct Claude to write a PostGreSQL query to answer the above question.  Cut and paste that query into the query tool in PGAdmin. Look at the results.  You should have 6 lines of output.  If you have more or less, the query was not working properly.  Examine, the output and query, see where there was a misunderstanding. Try to expand on your prompt or write a new one  to get a better answer. Keep doing this until you get a proper output or you manually fix the query.

5. Start a new chat (upper left) on Claude desktop.  This time we will pass it 3 text descriptions of the tables.

6. In PGAdmin right-click the Lahman database and select the PSQL tool.  In the interface type the command '\d people', this should output a text description of the people table.  Just copy this output and paste it into the Claude desktop.  Do the same for the managers and awardsmangers tables.

7. Once again ask Claude to write a SQL query to answer question 2.  Was there an difference in the two queries.

8. Now open the people table in Excel.   You can add files to the existing workbook through Claude for Excel.  Add the manager csv as a new sheet then do the same for awardsmanager.  Prompt Claude to create a new sheet that has a list of the managers the meet the criteria mentioned above.  Again, there should be 6 lines of output in the workbook.  If it did not work as expected have Claude update the output to match the actual answer.

-------------Bonus Questions----------------------
If you are able to finish the above exercise with time to spare use the same process as above to try to answer some additional questions.

9. Which team(s) had the most World Series wins by decade.

10. What is the median total career salary for players that played 1, 2, 3, and 4 years of college baseball?  Is there a trend?

11. Which is more correlated with higher home game attendance: Batters HR or Team Wins.
