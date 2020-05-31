-- Q1
-- List each country name where the population is larger than that of 'Russia'.
SELECT name FROM world
  WHERE population >
     (SELECT population FROM world
      WHERE name='Russia')

-- Q2
-- Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.
SELECT name FROM world
  WHERE continent = "Europe"
AND gdp/population >
     (SELECT gdp/population FROM world
      WHERE name='United Kingdom')

-- Q3
-- List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.
SELECT name, continent FROM world
  WHERE continent = (SELECT continent FROM world
      WHERE name = 'Argentina')
OR continent = (SELECT continent FROM world
      WHERE name ='Australia')
ORDER BY name

-- Q4
-- Which country has a population that is more than Canada but less than Poland? Show the name and the population.
SELECT name, population FROM world
  WHERE population > (SELECT population FROM world
      WHERE name = 'Canada')
AND population < (SELECT population FROM world
      WHERE name ='Poland')

-- Q5
-- Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany.
-- Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.
SELECT name,
  CONCAT(ROUND(population*100/(SELECT population
                                FROM world
                                WHERE name = 'Germany'),0), '%') AS percentage
FROM world
WHERE continent = 'Europe'

-- Q6
-- Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)
SELECT name
  FROM world
 WHERE gdp >= ALL(SELECT gdp
                           FROM world
                          WHERE gdp>0
                          AND continent = 'Europe')
AND continent NOT LIKE 'Europe'
-- To gain an absurdly detailed view of one insignificant feature of the language, read on.
-- We can use the word ALL to allow >= or > or < or <=to act over a list. For example, you can find the largest country in the world, by population with this query:

-- SELECT name
--   FROM world
--  WHERE population >= ALL(SELECT population
--                            FROM world
--                           WHERE population>0)

-- You need the condition population>0 in the sub-query as some countries have null for population.

-- Q7
-- Find the largest country (by area) in each continent, show the continent, the name and the area:
SELECT continent, name, area FROM world x
  WHERE area >= ALL
    (SELECT area FROM world y
        WHERE y.continent=x.continent
          AND area>0)

-- The above example is known as a correlated or synchronized sub-query.
-- Using correlated subqueries
-- A correlated subquery works like a nested loop: the subquery only has access to rows related to a single record at a time in the outer query. The technique relies on table aliases to identify two different uses of the same table, one in the outer query and the other in the subquery.
-- One way to interpret the line in the WHERE clause that references the two table is “… where the correlated values are the same”.
-- In the example provided, you would say “select the country details from world where the population is greater than or equal to the population of all countries where the continent is the same”.

-- Q8
-- List each continent and the name of the country that comes first alphabetically.
SELECT continent, name FROM world x
  WHERE name <= ALL (SELECT name FROM world y
    WHERE x.continent = y.continent)

-- Q9
-- Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.
SELECT name, continent, population FROM world
 WHERE continent NOT IN
     (SELECT continent
      FROM world
      WHERE population > 25000000)

-- Q10
-- Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents.
SELECT name, continent
FROM world x
WHERE population > ALL(SELECT population * 3
                       FROM world y
                       WHERE x.continent = y.continent
 AND x.name != y.name);
 