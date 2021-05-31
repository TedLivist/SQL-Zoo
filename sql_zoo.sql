-- SELECT basics
-- Show the population of Germany
SELECT population FROM world
  WHERE name = 'Germany'

-- Show the name and the population for 'Sweden', 'Norway' and 'Denmark'.
SELECT name, population FROM world
  WHERE name IN ('Sweden', 'Norway', 'Denmark') ORDER BY population DESC;

-- Show the country and the area for countries with an area between 200,000 and 250,000.
SELECT name, area FROM world
  WHERE area BETWEEN 200000 AND 250000


-- SELECT from WORLD
-- Show the name, continent and population of all countries
SELECT name, continent, population FROM world

-- Show the name for the countries that have a population of at least 200 million. 200 million is 200000000, there are eight zeros.
SELECT name
  FROM world
 WHERE population > 200000000

-- Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name, gdp/population AS per_capita_GDP
FROM world
WHERE population >= 200000000

/* Show the name and population in millions for the countries of the continent 'South America'. 
Divide the population by 1000000 to get population in millions.*/
SELECT name, population/1000000
FROM world
WHERE continent = 'South America'

-- Show the name and population for France, Germany, Italy
SELECT name, population
FROM world
WHERE name IN ('France', 'Germany', 'Italy')

-- Show the countries which have a name that includes the word 'United'
SELECT name
FROM world
WHERE name LIKE '%United%'

-- Show the countries that are big by area or big by population. Show name, population and area.
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000

/* Exclusive OR (XOR). Show the countries that are big by area (more than 3 million)
or big by population (more than 250 million) but not both. Show name, population and area. */
SELECT name, population, area
FROM world
WHERE (area > 3000000 AND population < 250000000)
OR (area < 3000000 AND population > 250000000)

/* Show the name and population in millions and the GDP in billions for the countries of the continent 'South America'.
Use the ROUND function to show the values to two decimal places. */
SELECT name, ROUND(population/1000000, 2) AS pop_in_millions, ROUND(gdp/1000000000, 2) AS gdp_in_billions
FROM world
WHERE continent = 'South America'

/* Show the name and per-capita GDP for those countries with a GDP of at least one trillion (1000000000000; that is 12 zeros).
Round this value to the nearest 1000. */
-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name, ROUND(gdp/population, -3)
FROM world
WHERE gdp >= 1000000000000

-- Show the name and capital where the name and the capital have the same number of characters.
SELECT name, capital
  FROM world
 WHERE LEN(name) = LEN(capital)

/* Show the name and the capital where the first letters of each match.
Don't include countries where the name and the capital are the same word.*/
-- You can use the function LEFT to isolate the first character.
-- You can use <> as the NOT EQUALS operator.
SELECT name, capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1)
 AND name <> capital

-- Find the country that has all the vowels and no spaces in its name.
SELECT name
   FROM world
WHERE name NOT LIKE '% %'
 AND name LIKE '%a%' AND name LIKE '%b%' AND name LIKE '%i%' AND name LIKE '%o%' AND name LIKE '%u%'


-- SELECT from NOBEL
-- Change the query shown so that it displays Nobel prizes for 1950.
SELECT yr, subject, winner
  FROM nobel
 WHERE yr = 1950

-- Show who won the 1962 prize for Literature.
SELECT winner
  FROM nobel
 WHERE yr = 1962
   AND subject = 'Literature'

-- Show the year and subject that won 'Albert Einstein' his prize.
SELECT yr, subject
FROM nobel
WHERE winner = 'Albert Einstein'

-- Give the name of the 'Peace' winners since the year 2000, including 2000.
SELECT winner
FROM nobel
WHERE yr >= 2000 AND subject = 'Peace'

-- Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
SELECT yr, subject, winner
FROM nobel
WHERE subject = 'Literature'
 AND yr BETWEEN 1980 AND 1989

/* Show all details of the presidential winners:
- Theodore Roosevelt
- Woodrow Wilson
- Jimmy Carter
- Barack Obama */
SELECT * FROM nobel
 WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama')

-- Show the winners with first name John
SELECT winner
FROM nobel
WHERE winner LIKE 'John%'
--- Another answer ---
SELECT winner
FROM nobel
WHERE LEFT(winner, 4) = 'John'

-- Show the year, subject, and name of Physics winners for 1980 together with the Chemistry winners for 1984.
SELECT *
FROM nobel
WHERE subject = 'Physics' AND yr = 1980 OR subject = 'Chemistry' AND yr = 1984

-- Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine
SELECT *
FROM nobel
WHERE yr = 1980 AND subject NOT IN ('Chemistry', 'Medicine')

/* Show year, subject, and name of people who won a 'Medicine' prize in an early year (before 1910, not including 1910)
together with winners of a 'Literature' prize in a later year (after 2004, including 2004) */
SELECT *
FROM nobel
WHERE subject = 'Medicine' AND yr < 1910
 OR subject = 'Literature' AND yr >= 2004

-- Find all details of the prize won by PETER GRÜNBERG
-- N.B. 'umlaut' character: Alt + 0 + 2 + 2 + 0 = Ü; Alt + 0 + 2 + 5 + 2 = ü
SELECT *
FROM nobel
WHERE winner = 'Peter Grünberg'

-- Find all details of the prize won by EUGENE O'NEILL
-- N.B. how to escape apostrophe
SELECT *
FROM nobel
WHERE winner = 'Eugene O''Neill'

-- List the winners, year and subject where the winner starts with Sir. Show the the most recent first, then by name order.
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%' ORDER BY yr DESC, winner

-- Show the 1984 winners and subject ordered by subject and winner name; but list Chemistry and Physics last.
SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY
CASE WHEN subject IN ('Physics', 'Chemistry') THEN 1 ELSE 0 END, subject, winner

-- SELECT within SELECT
-- List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name
FROM world
WHERE gdp/population > (SELECT gdp/population FROM world WHERE name = 'United Kingdom') AND continent = 'Europe'

-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent
FROM world
WHERE continent = (SELECT continent FROM world WHERE name = 'Argentina') OR continent = (SELECT continent FROM world WHERE name = 'Australia')
ORDER BY name

-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Canada') AND population < (SELECT population FROM world WHERE name = 'Poland')

-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name, CONCAT(ROUND((population/(SELECT population FROM world WHERE name = 'Germany') * 100), 0), '%') AS percentage
FROM world
WHERE continent = 'Europe'

/*
We can use the word ALL to allow >= or > or < or <=to act over a list. For example, you can find the largest country in the world, by population with this query:

SELECT name
  FROM world
 WHERE population >= ALL(SELECT population
                           FROM world
                          WHERE population>0)

You need the condition population>0 in the sub-query as some countries have null for population.
*/

-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name
FROM world
WHERE gdp > ALL(SELECT gdp FROM world WHERE continent = 'Europe' AND gdp > 0)

-- Find the largest country (by area) in each continent, show the continent, the name and the area
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

-- List each continent and the name of the country that comes first alphabetically.
SELECT x.continent, x.name
FROM world x
WHERE x.name <= ALL (SELECT y.name FROM world y WHERE x.continent=y.continent)
ORDER BY continent

/* Find the continents where all countries have a population <= 25000000.
Then find the names of the countries associated with these continents. Show name, continent and population. */
SELECT name, continent, population 
FROM world w
WHERE NOT EXISTS (                  -- there are no countries
   SELECT *
   FROM world nx
   WHERE nx.continent = w.continent -- on the same continent
   AND nx.population > 25000000     -- with more than 25M population 
   );


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

