# SQL Project: Country Club


This project uses the Country Club Database, a sample relational database designed to represent the day-to-day operations of a private club.
The database models real-world entities and relationships, including:
Members : personal details of club members and their referral relationships
Facilities : information about club facilities such as courts and spa services
Bookings : records of facility reservations made by members and guests

The queries in this project address common business and analytical scenarios by filtering and retrieving records using conditional logic, joining multiple tables to combine related data, and analyzing bookings and usage patterns through aggregation functions. The solutions also demonstrate effective handling of dates, strings, and calculated fields, along with the use of subqueries and window functions for more advanced analysis. Overall, the project emphasizes writing clear, efficient, and interview-ready SQL, with a strong focus on correctness, readability, and proper use of relational database concepts.

---

### Table

```sql
-- ============================================
-- Table: members
-- ============================================


CREATE TABLE cd.members
( 
    memid INTEGER NOT NULL PRIMARY KEY,
    recommendedby INTEGER,
    recommendedby INTEGER REFERENCES cd.members(memid) ON DELETE SET NULL,
    CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
    REFERENCES cd.members(memid) ON DELETE SET NULL,
    surname VARCHAR(200) NOT NULL,
    firstname VARCHAR(200) NOT NULL,
    address VARCHAR(200) NOT NULL,
    zipcode INTEGER NOT NULL,
    telephone VARCHAR(20) NOT NULL,
    joindate TIMESTAMP NOT NULL
);
    
-- ============================================
-- Table: facilities
-- ============================================


CREATE TABLE cd.facilities
(
    facid INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    membercost NUMERIC NOT NULL,
    guestcost NUMERIC NOT NULL,
    initialoutlay NUMERIC NOT NULL,
    monthlymaintenance NUMERIC NOT NULL
);

-- ============================================
-- Table: bookings
-- ============================================

CREATE TABLE cd.bookings
(
    bookid INTEGER NOT NULL,
    facid INTEGER NOT NULL,
    memid INTEGER NOT NULL,
    starttime TIMESTAMP NOT NULL,
    slots INTEGER NOT NULL,
    CONSTRAINT bookings_pk PRIMARY KEY (bookid),
    CONSTRAINT fk_bookings_facid FOREIGN KEY (facid)
        REFERENCES cd.facilities(facid) ON DELETE CASCADE,
    CONSTRAINT fk_bookings_memid FOREIGN KEY (memid)
        REFERENCES cd.members(memid) ON DELETE CASCADE
);
```
## SQL Queries
---
### Modifying Data (CRUD)
### 1: Insert a new facility
``` sql
INSERT INTO cd.facilities
(facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800);
```
### 2: Insert using SELECT
``` sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance) 
SELECT (SELECT MAX(facid) FROM cd.facilities) + 1, 'Spa', 20, 30, 100000, 800;
```
### 3: Update a record
``` sql
UPDATE cd.facilities SET initialoutlay = 10000 WHERE facid = 1;
```
### 4: Update using calculated values
``` sql
UPDATE cd.facilities f1 
SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE facid = 0), guestcost = (SELECT guestcost * 1.1 FROM cd.facilities WHERE facid = 0) 
WHERE f1.facid = 1;
```
### 5: Delete all records
``` sql
DELETE FROM cd.bookings;
```
### 6: Delete with condition
``` sql
DELETE FROM cd.members WHERE memid = 37;
```
---
### Basic Filtering
### 1: Facilities with specific cost conditions
``` sql
SELECT facid, name, membercost, monthlymaintenance 
FROM cd.facilities 
WHERE membercost > 0 AND membercost < monthlymaintenance/50;
```
### 2: Find tennis facilities
``` sql
SELECT * FROM cd.facilities WHERE name LIKE '%Tennis%';
```
### 3: Filter using IN
``` sql
SELECT * FROM cd.facilities WHERE facid IN (1, 5);
```
### 4: Date filtering
``` sql
SELECT memid, surname, firstname, joindate 
FROM cd.members 
WHERE joindate >= '2012-09-01';
```
### 5: UNION example
``` sql
SELECT surname 
FROM cd.members UNION SELECT name FROM cd.facilities;
```
---
### Joins
### 1: Simple Join
``` sql
SELECT memid, surname, firstname, joindate 
FROM cd.members 
WHERE joindate >= '2012-09-01';
```
### 2: Join bookings with facilities
``` sql
SELECT bks.starttime, facs.name 
FROM cd.facilities facs JOIN cd.bookings bks 
    ON facs.facid = bks.facid 
WHERE facs.name IN ('Tennis Court 1', 'Tennis Court 2') AND bks.starttime >= '2012-09-21' AND bks.starttime < '2012-09-22' 
ORDER BY bks.starttime;
```
### 3: Self join (recommended by)
```sql
SELECT m.firstname AS member_firstname, m.surname AS member_surname, r.firstname AS recommender_firstname, r.surname AS recommender_surname 
FROM cd.members m LEFT JOIN cd.members r 
    ON r.memid = m.recommendedby 
ORDER BY member_surname, member_firstname;
```
### 4: Self join distinct recommender
```sql
SELECT DISTINCT recs.firstname AS firstname, recs.surname AS surname FROM cd.members mems INNER JOIN cd.members recs 
    ON recs.memid = mems.recommendedby 
ORDER BY surname, firstname;
```
### 5: Subquery + join
```sql
SELECT DISTINCT m1.firstname || ' ' || m1.surname AS member, (SELECT r1.firstname || ' ' || r1.surname 
FROM cd.members r1 
WHERE r1.memid = m1.recommendedby) AS recommender 
FROM cd.members m1 
ORDER BY member;
```
---

### Aggregation
### 1: Group by recommender
``` sql
SELECT recommendedby, COUNT(*) AS count 
FROM cd.members 
WHERE recommendedby IS NOT NULL 
GROUP BY recommendedby ORDER BY recommendedby;
```
### 2: Facility usage
``` sql
SELECT facid, SUM(slots) AS total_slots 
FROM cd.bookings 
GROUP BY facid ORDER BY facid;
```
### 3: Facility usage by month
```sql
SELECT facid, SUM(slots) AS total_slots 
FROM cd.bookings 
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01' 
GROUP BY facid ORDER BY SUM(slots);
```
### 4: Facility usage by month & multi-column
```sql
SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS total_slots 
FROM cd.bookings 
WHERE EXTRACT(YEAR FROM starttime) = 2012 
GROUP BY facid, month ORDER BY facid, month;
```
### 5: Count distinct
```sql
SELECT facid, EXTRACT(MONTH FROM starttime) AS month, SUM(slots) AS total_slots 
FROM cd.bookings 
WHERE EXTRACT(YEAR FROM starttime) = 2012 
GROUP BY facid, month ORDER BY facid, month;
```
### 6: Group by multiple cols + join
```sql
SELECT mems.surname, mems.firstname, mems.memid, MIN(bks.starttime) AS starttime 
FROM cd.members mems JOIN cd.bookings bks ON mems.memid = bks.memid 
WHERE bks.starttime >= '2012-09-01' 
GROUP BY mems.memid, mems.firstname, mems.surname ORDER BY mems.memid;
```
### 7: Window function ? count members
```sql
SELECT COUNT(*) OVER () AS count, firstname, surname 
FROM cd.members 
ORDER BY joindate;
```
### 7: Window function ? row number
```sql
SELECT row_number() OVER (ORDER BY joindate), firstname, surname 
FROM cd.members ORDER BY joindate;
```
### 8: Window + subquery + group by
```sql
SELECT facid, SUM(slots) AS total 
FROM cd.bookings 
GROUP BY facid 
HAVING SUM(slots) = (SELECT MAX(total_slots) 
FROM (SELECT SUM(slots) 
AS total_slots 
FROM cd.bookings 
GROUP BY facid) sub);
```
---
### String Functions
### 1: Concatenate names
``` sql
SELECT surname || ', ' || firstname AS name 
FROM cd.members;
```
### 2: WHERE + string function
``` sql
SELECT memid, telephone 
FROM cd.members 
WHERE telephone LIKE '%(%' 
ORDER BY memid;
```
### 3: Substring grouping
``` sql
SELECT LEFT(surname, 1) AS letter, COUNT(*) AS count 
FROM cd.members 
GROUP BY letter 
ORDER BY letter;
```
---
    
