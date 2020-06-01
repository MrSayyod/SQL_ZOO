-- Q1
-- How many stops are in the database
SELECT COUNT(id) FROM stops

-- Q2
-- Find the id value for the stop 'Craiglockhart'
SELECT id FROM stops
WHERE name = 'Craiglockhart'

-- Q3
-- Give the id and the name for the stops on the '4' 'LRT' service.
SELECT id, name FROM stops
JOIN route ON id = stop
WHERE num = '4' AND company = 'LRT' 

-- Q4
-- The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(stop) = 2

-- Q5
-- Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53 AND b.stop = 149

-- Q6
-- The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart' AND stopb.name = 'London Road';

-- Q7
-- Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON a.company=b.company AND a.num=b.num
WHERE a.stop=115 AND b.stop = 137 OR b.stop=115 AND b.stop = 137;

-- Q8
-- Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON a.company = b.company AND a.num = b.num
JOIN stops first ON first.id = a.stop
JOIN stops second ON second.id = b.stop
WHERE first.name = 'Craiglockhart' AND second.name = 'Tollcross' OR second.name = 'Craiglockhart' AND first.name = 'Tollcross';

-- Q9
-- Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT sb.name, a.company, a.num FROM route a
  JOIN route b ON a.company = b.company AND a.num = b.num
  JOIN stops ON a.stop = stops.id
  JOIN stops sb ON b.stop = sb.id
  WHERE stops.name = 'Craiglockhart';

-- Q10
-- Find the routes involving two buses that can go from Craiglockhart to Lochend.
-- Show the bus no. and company for the first bus, the name of the stop for the transfer,
-- and the bus no. and company for the second bus.
-- Hint
-- Self-join twice to find buses that visit Craiglockhart and Lochend, then join those on matching stops.
SELECT bus1.num, bus1.company, stop1_dest.name,  bus2.num,  bus2.company 
  FROM route bus1 JOIN route bus1_dest ON
     (bus1.company=bus1_dest.company AND bus1.num=bus1_dest.num)
  JOIN route bus2 ON (bus2.stop=bus1_dest.stop)
  JOIN route bus2_dest ON
    (bus2.company=bus2_dest.company AND bus2.num=bus2_dest.num)
  JOIN stops stop1 ON (bus1.stop=stop1.id)
  JOIN stops stop1_dest ON (bus1_dest.stop=stop1_dest.id)
  JOIN stops stop2 ON (bus2.stop=stop2.id)
  JOIN stops stop2_dest ON (bus2_dest.stop=stop2_dest.id)
WHERE stop1.name = 'Craiglockhart' AND stop2_dest.name = 'Lochend'
GROUP BY bus1.num, stop1_dest.name, bus2.num