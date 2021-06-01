










-- SUM and COUNT
-- Show the total population of the world.
SELECT SUM(population)
FROM world

-- List all the continents - just once each.
SELECT DISTINCT continent
FROM world

-- Give the total GDP of Africa
SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa'

-- How many countries have an area of at least 1000000
SELECT COUNT(area)
FROM world
WHERE area >= 1000000

-- What is the total population of ('Estonia', 'Latvia', 'Lithuania')
SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

-- For each continent show the continent and number of countries.
SELECT continent, COUNT(name)
FROM world
GROUP BY continent

-- For each continent show the continent and number of countries with populations of at least 10 million.
SELECT continent, COUNT(name)
FROM world
WHERE population > 10000000
GROUP BY continent

-- List the continents that have a total population of at least 100 million.
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) > 100000000

-- Show the matchid and player name for all goals scored by Germany. To identify German players, check for: teamid = 'GER'
SELECT matchid, player FROM goal 
  WHERE teamid = 'GER'

-- Show id, stadium, team1, team2 for just game 1012
SELECT id,stadium,team1,team2
  FROM game
  WHERE id = 1012

-- Show the player, teamid, stadium and mdate for every German goal.
SELECT player,teamid,stadium,mdate
  FROM game JOIN goal ON (id=matchid) AND teamid = 'GER'

-- Show the team1, team2 and player for every goal scored by a player called Mario player LIKE 'Mario%'
SELECT team1, team2, player
FROM game
JOIN goal
ON id = matchid AND player LIKE 'Mario%'

-- Show player, teamid, coach, gtime for all goals scored in the first 10 minutes gtime<=10
SELECT player, teamid, coach, gtime
FROM goal
JOIN eteam
ON teamid = id
AND gtime <= 10

-- List the dates of the matches and the name of the team in which 'Fernando Santos' was the team1 coach.
SELECT mdate, teamname
FROM game
JOIN eteam
ON team1 = eteam.id
AND coach = 'Fernando Santos'

-- List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'
SELECT player
FROM goal
JOIN game
ON matchid = id
AND stadium = 'National Stadium, Warsaw'

-- Show the name of all players who scored a goal against Germany.
SELECT DISTINCT player
FROM goal
JOIN game
ON matchid = id
WHERE (team1 = 'GER' OR team2 = 'GER') AND teamid != 'GER'

-- Show teamname and the total number of goals scored.
SELECT teamname, COUNT(gtime)
FROM eteam
JOIN goal
ON id = teamid
GROUP BY teamname

-- Show the stadium and the number of goals scored in each stadium.
SELECT stadium, COUNT(gtime)
FROM game
JOIN goal
ON id = matchid
GROUP BY stadium

-- For every match involving 'POL', show the matchid, date and the number of goals scored.
SELECT matchid, mdate, COUNT(gtime)
  FROM goal
JOIN game
ON goal.matchid = game.id
WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY matchid, mdate

-- For every match where 'GER' scored, show matchid, match date and the number of goals scored by 'GER'
SELECT matchid, mdate, COUNT(gtime)
FROM goal
JOIN game
ON matchid = id
WHERE teamid = 'GER'
GROUP BY matchid, mdate

/* List every match with the goals scored by each team as shown.
This will use "CASE WHEN" which has not been explained in any previous exercises.
mdate	team1	score1	team2	score2
1 July 2012	ESP	4	ITA	0
10 June 2012	ESP	1	ITA	1
10 June 2012	IRL	1	CRO	3
...
 */
SELECT mdate, team1, 
  SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
      team2,
  SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
   FROM game LEFT JOIN goal ON matchid = id
GROUP BY mdate, team1, team2
ORDER BY mdate, matchid, team1, team2


-- More JOIN
-- List the films where the yr is 1962 [Show id, title]
SELECT id, title
 FROM movie
 WHERE yr=1962

-- Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title = 'Citizen Kane'

-- List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr

-- What id number does the actor 'Glenn Close' have?
SELECT id
FROM actor
WHERE name = 'Glenn Close'

-- What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca'

-- Obtain the cast list for 'Casablanca'. Use movieid=11768, (or whatever value you got from the previous question)
SELECT name
FROM actor
JOIN casting
ON id = actorid
WHERE movieid = 11768

-- Obtain the cast list for the film 'Alien'
SELECT name
FROM actor
JOIN casting
ON id = actorid
WHERE movieid = (SELECT id FROM movie WHERE title = 'Alien')

-- List the films in which 'Harrison Ford' has appeared
SELECT title
FROM movie
JOIN casting
ON id = movieid
WHERE actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford')
----- ANOTHER ANSWER -----
SELECT title
FROM movie
JOIN casting
ON id = movieid
JOIN actor
ON actorid = actor.id
WHERE actor.name = 'Harrison Ford'

/* List the films where 'Harrison Ford' has appeared - but not in the starring role.
[Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role] */
SELECT title
FROM movie
JOIN casting
ON id = movieid
JOIN actor
ON actorid = actor.id
WHERE actor.name = 'Harrison Ford' AND ord != 1

-- List the films together with the leading star for all 1962 films.
SELECT title, name
FROM movie
JOIN casting
ON id = movieid
JOIN actor
ON actorid = actor.id
WHERE movie.yr = 1962 AND ord = 1

-- Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
SELECT yr, COUNT(title)
FROM movie
JOIN casting
ON movieid = id
JOIN actor
ON actorid = actor.id
WHERE actor.name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2

-- List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT title, name
  FROM movie
JOIN casting
ON id = movieid
JOIN actor
ON actorid = actor.id
WHERE ord = 1 AND movieid IN (SELECT movieid FROM casting JOIN actor ON actorid = actor.id WHERE name = 'Julie Andrews')

-- Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.
SELECT name
FROM casting
JOIN actor
ON actorid = actor.id
WHERE ord = 1
GROUP BY actor.name
HAVING COUNT(ord) >= 15

-- List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT title, COUNT(actorid)
FROM movie
JOIN casting
ON id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC, title

-- List all the people who have worked with 'Art Garfunkel'.
SELECT name FROM actor JOIN casting ON actor.id = actorid
WHERE movieid IN
  (SELECT id FROM movie WHERE title IN
    (SELECT title FROM movie JOIN casting ON movie.id = movieid WHERE actorid IN
      (SELECT id FROM actor WHERE name = 'Art Garfunkel')))
  AND name != 'Art Garfunkel'

-- NULL, INNER JOIN, LEFT JOIN, RIGHT JOIN
-- List the teachers who have NULL for their department.
SELECT name
FROM teacher
WHERE dept IS NULL

-- Note the INNER JOIN misses the teachers with no department and the departments with no teacher.
SELECT teacher.name, dept.name
 FROM teacher INNER JOIN dept
           ON (teacher.dept=dept.id)

-- Use a different JOIN so that all teachers are listed.
SELECT teacher.name, dept.name
 FROM teacher LEFT JOIN dept
           ON (teacher.dept=dept.id)

-- Use a different JOIN so that all departments are listed.
SELECT teacher.name, dept.name
 FROM teacher RIGHT JOIN dept
           ON (teacher.dept=dept.id)

/* Use COALESCE to print the mobile number. Use the number '07986 444 2266' if there is no number given.
Show teacher name and mobile number or '07986 444 2266' */
SELECT name, COALESCE(mobile, '07986 444 2266')
FROM teacher

/* Use the COALESCE function and a LEFT JOIN to print the teacher name and department name.
Use the string 'None' where there is no department. */
SELECT teacher.name, COALESCE(dept.name, 'None')
FROM teacher
LEFT JOIN dept
ON teacher.dept = dept.id

-- Use COUNT to show the number of teachers and the number of mobile phones.
SELECT COUNT(name), COUNT(mobile)
FROM teacher

/* Use COUNT and GROUP BY dept.name to show each department and the number of staff.
Use a RIGHT JOIN to ensure that the Engineering department is listed. */
SELECT dept.name, COUNT(teacher.name)
FROM teacher
RIGHT JOIN dept
ON teacher.dept = dept.id
GROUP BY dept.name

-- Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2 and 'Art' otherwise
SELECT name, CASE
           WHEN dept = 1 OR dept = 2 THEN 'Sci'
           ELSE 'Art'
       END
FROM teacher

/* Use CASE to show the name of each teacher followed by 'Sci' if the teacher is in dept 1 or 2,
show 'Art' if the teacher's dept is 3 and 'None' otherwise.*/
SELECT name, CASE
           WHEN dept = 1 OR dept = 2 THEN 'Sci'
           WHEN dept = 3 THEN 'Art'
           ELSE 'None'
       END
FROM teacher

-- SELF JOIN
-- How many stops are in the database.
SELECT COUNT(id)
FROM stops

-- Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart'

-- Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name
FROM stops
JOIN route
ON id = stop
WHERE num = '4' AND company = 'LRT'

/* The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53).
Run the query and notice the two services that link these stops have a count of 2.
Add a HAVING clause to restrict the output to these two routes. */
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*) = 2

/* Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes.
Change the query so that it shows the services from Craiglockhart to London Road.*/
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company = b.company AND a.num = b.num)
WHERE a.stop = 53 AND b.stop = 149

/*The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number.
Change the query so that the services between 'Craiglockhart' and 'London Road' are shown.
If you are tired of these places try 'Fairmilehead' against 'Tollcross'*/
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road'

-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b
ON (a.company = b.company AND a.num = b.num)
WHERE a.stop = 115 and b.stop = 137

-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT a.company, a.num FROM
	route AS a JOIN route AS b ON (a.company = b.company AND a.num = b.num)
			   JOIN stops AS astop ON (a.stop = astop.id)
			   JOIN stops AS bstop ON (b.stop = bstop.id)
	WHERE astop.name = 'Craiglockhart' AND bstop.name = 'Tollcross'

/* Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus,
including 'Craiglockhart' itself, offered by the LRT company.
Include the company and bus no. of the relevant services.*/
SELECT DISTINCT bstop.name, a.company, a.num FROM
	route AS a JOIN route AS b ON (a.company = b.company AND a.num = b.num)
			   JOIN stops AS astop ON (a.stop = astop.id)
			   JOIN stops AS bstop ON (b.stop = bstop.id)
	WHERE astop.name = 'Craiglockhart'

/* Find the routes involving two buses that can go from Craiglockhart to Lochend.
Show the bus no. and company for the first bus, the name of the stop for the transfer,
and the bus no. and company for the second bus.

Hint
Self-join twice to find buses that visit Craiglockhart and Lochend, then join those on matching stops.*/
SELECT r1.num, r1.company, s1.name, r4.num, r4.company FROM route r1
JOIN route r2 ON r1.num = r2.num AND r1.company = r2.company
JOIN stops s1 ON r2.stop = s1.id
JOIN route r3 ON s1.id = r3.stop
JOIN route r4 ON r3.num = r4.num AND r3.company = r4.company
WHERE r1.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')
AND r4.stop = (SELECT id FROM stops WHERE name = 'Lochend')
ORDER BY r1.num, s1.name, r4.num