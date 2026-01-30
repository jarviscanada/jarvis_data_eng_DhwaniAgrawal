
# SQL Project: Country Club

## Table Setup (DDL)

The following tables were created in PostgreSQL for the Country Club project.  
All tables include **primary keys, foreign keys, and constraints** to maintain data integrity.  
Foreign key relationships are named explicitly for clarity and maintainability.

---

### 1?? Table: members

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
    
