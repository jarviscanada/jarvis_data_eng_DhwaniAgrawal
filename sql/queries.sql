-- Modifying Data (CRUD)
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) 
VALUES (9, 'Spa', 20, 30, 100000, 800);

INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) 
SELECT (SELECT MAX(facid) FROM cd.facilities) + 1, 'Spa', 20, 30, 100000, 800;

UPDATE cd.facilities SET initialoutlay = 10000 WHERE facid = 1;

UPDATE cd.facilities f1 SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0), guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0) WHERE f1.facid = 1;

DELETE FROM cd.bookings;

DELETE FROM cd.members WHERE memid = 37;

-- Basics

SELECT facid, name, membercost, monthlymaintenance 
FROM cd.facilities 
WHERE membercost > 0 AND membercost < monthlymaintenance/50;

SELECT * FROM cd.facilities WHERE name LIKE '%Tennis%';

SELECT * FROM cd.facilities WHERE facid IN (1, 5);

SELECT memid, surname, firstname, joindate 
FROM cd.members 
WHERE joindate >= '2012-09-01';

SELECT surname 
FROM cd.members U
NION SELECT name FROM cd.facilities;

-- Joins
SELECT memid, surname, firstname, joindate 
FROM cd.members 
WHERE joindate >= '2012-09-01';

SELECT bks.starttime, facs.name 
FROM cd.facilities facs 
JOIN cd.bookings bks ON facs.facid = bks.facid 
WHERE facs.name IN ('Tennis Court 1','Tennis Court 2') AND bks.starttime >= '2012-09-21' AND bks.starttime < '2012-09-22' 
ORDER BY bks.starttime;

SELECT m.firstname AS member_firstname, m.surname AS member_surname, r.firstname AS recommender_firstname, r.surname AS recommender_surname 
FROM cd.members m 
LEFT JOIN cd.members r ON r.memid = m.recommendedby 
ORDER BY member_surname, member_firstname;

SELECT DISTINCT recs.firstname AS firstname, recs.surname AS surname 
FROM cd.members mems 
INNER JOIN cd.members recs ON recs.memid = mems.recommendedby 
ORDER BY surname, firstname;

SELECT DISTINCT m1.firstname || ' ' || m1.surname AS member, (SELECT r1.firstname || ' ' || r1.surname FROM cd.members r1 WHERE r1.memid = m1.recommendedby) AS recommender 
FROM cd.members m1 
ORDER BY member;

-- Aggregation
SELECT recommendedby, COUNT(*) AS count 
FROM cd.members 
WHERE recommendedby IS NOT NULL 
GROUP BY recommendedby ORDER BY recommendedby;

SELECT facid, SUM(slots) AS total_slots 
FROM cd.bookings 
GROUP BY facid 
ORDER BY facid;

SELECT facid, SUM(slots) AS total_slots 
FROM cd.bookings 
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01' 
GROUP BY facid ORDER BY SUM(slots);

SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS total_slots 
FROM cd.bookings 
WHERE EXTRACT(YEAR FROM starttime) = 2012 
GROUP BY facid, month 
ORDER BY facid, month;

SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS total_slots 
FROM cd.bookings 
WHERE EXTRACT(YEAR FROM starttime) = 2012 
GROUP BY facid, month 
ORDER BY facid, month;

SELECT mems.surname, mems.firstname, mems.memid, MIN(bks.starttime) AS starttime 
FROM cd.members mems JOIN cd.bookings bks ON mems.memid = bks.memid 
WHERE bks.starttime >= '2012-09-01' 
GROUP BY mems.memid, mems.firstname, mems.surname 
ORDER BY mems.memid;

SELECT COUNT(*) OVER () AS count, firstname, surname 
FROM cd.members 
ORDER BY joindate;

SELECT row_number() OVER (ORDER BY joindate), firstname, surname 
FROM cd.members 
ORDER BY joindate;

SELECT facid, SUM(slots) AS total 
FROM cd.bookings 
GROUP BY facid HAVING SUM(slots) = (SELECT MAX(total_slots) 
FROM (SELECT SUM(slots) AS total_slots FROM cd.bookings GROUP BY facid) sub);

-- String Functions
SELECT surname || ', ' || firstname AS name 
FROM cd.members;

SELECT memid, telephone 
FROM cd.members 
WHERE telephone LIKE '%(%' ORDER BY memid;

SELECT LEFT(surname, 1) AS letter, COUNT(*) AS count 
FROM cd.members 
GROUP BY letter 
ORDER BY letter;

