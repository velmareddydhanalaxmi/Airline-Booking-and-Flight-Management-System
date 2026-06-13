-- =========================================
-- AIRLINE BOOKING & FLIGHT MANAGEMENT SYSTEM
-- =========================================

CREATE DATABASE airline_db;
USE airline_db;

-- =========================================
-- 1. AIRPORT TABLE
-- =========================================

CREATE TABLE AIRPORT (
    airport_id INT PRIMARY KEY,
    airport_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);

-- =========================================
-- 2. AIRCRAFT TABLE
-- =========================================

CREATE TABLE AIRCRAFT (
    aircraft_id INT PRIMARY KEY,
    model VARCHAR(50) NOT NULL,
    total_seats INT NOT NULL
);

-- =========================================
-- 3. FLIGHT TABLE
-- =========================================

CREATE TABLE FLIGHT (
    flight_id INT PRIMARY KEY,
    flight_number VARCHAR(20) UNIQUE NOT NULL,

    source_airport_id INT NOT NULL,
    destination_airport_id INT NOT NULL,

    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,

    aircraft_id INT NOT NULL,

    FOREIGN KEY (source_airport_id)
        REFERENCES AIRPORT(airport_id),

    FOREIGN KEY (destination_airport_id)
        REFERENCES AIRPORT(airport_id),

    FOREIGN KEY (aircraft_id)
        REFERENCES AIRCRAFT(aircraft_id)
);

-- =========================================
-- 4. PASSENGER TABLE
-- =========================================

CREATE TABLE PASSENGER (
    passenger_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender CHAR(1),
    date_of_birth DATE,
    passport_number VARCHAR(20) UNIQUE
);

-- =========================================
-- 5. BOOKING TABLE
-- =========================================

CREATE TABLE BOOKING (
    booking_id INT PRIMARY KEY,

    passenger_id INT NOT NULL,
    flight_id INT NOT NULL,

    booking_date DATE,
    seat_number VARCHAR(5),

    booking_status VARCHAR(20),

    FOREIGN KEY (passenger_id)
        REFERENCES PASSENGER(passenger_id),

    FOREIGN KEY (flight_id)
        REFERENCES FLIGHT(flight_id)
);

-- =========================================
-- 6. PAYMENT TABLE
-- =========================================

CREATE TABLE PAYMENT (
    payment_id INT PRIMARY KEY,

    booking_id INT NOT NULL,

    payment_date DATE,
    amount DECIMAL(10,2),

    payment_method VARCHAR(30),

    FOREIGN KEY (booking_id)
        REFERENCES BOOKING(booking_id)
);

-- =========================================
-- 7. CREW TABLE
-- =========================================

CREATE TABLE CREW (
    crew_id INT PRIMARY KEY,
    crew_name VARCHAR(100) NOT NULL,
    role VARCHAR(50)
);

-- =========================================
-- 8. FLIGHT_CREW TABLE
-- MANY-TO-MANY RELATION
-- =========================================

CREATE TABLE FLIGHT_CREW (
    flight_id INT,
    crew_id INT,

    PRIMARY KEY (flight_id, crew_id),

    FOREIGN KEY (flight_id)
        REFERENCES FLIGHT(flight_id),

    FOREIGN KEY (crew_id)
        REFERENCES CREW(crew_id)
);

-- =========================================================
-- ================= DDL QUERIES ===========================
-- =========================================================

-- 1. Add new column email to PASSENGER table

ALTER TABLE PASSENGER
ADD email VARCHAR(100);

-- 2. Modify seat_number datatype

ALTER TABLE BOOKING
MODIFY seat_number VARCHAR(10);

-- 3. Drop PAYMENT table

DROP TABLE PAYMENT;

-- 4. Rename CREW table

RENAME TABLE CREW TO FLIGHT_CREW_MEMBER;

-- =========================================================
-- ================= DML QUERIES ===========================
-- =========================================================

-- INSERT INTO AIRPORT

INSERT INTO AIRPORT VALUES
(1,'Rajiv Gandhi International Airport','Hyderabad','India'),
(2,'Kempegowda International Airport','Bangalore','India'),
(3,'Chhatrapati Shivaji Airport','Mumbai','India'),
(4,'Indira Gandhi International Airport','Delhi','India'),
(5,'Chennai International Airport','Chennai','India');

-- INSERT INTO AIRCRAFT

INSERT INTO AIRCRAFT VALUES
(101,'Airbus A320',180),
(102,'Boeing 737',200),
(103,'Airbus A321',220),
(104,'Boeing 777',350),
(105,'ATR 72',90);

-- INSERT INTO PASSENGER

INSERT INTO PASSENGER VALUES
(1,'Rahul','Sharma','M','1998-05-12','P12345','rahul@gmail.com'),
(2,'Sneha','Reddy','F','2000-02-18','P67890','sneha@gmail.com'),
(3,'Arjun','Kumar','M','1995-08-20','P11111','arjun@gmail.com'),
(4,'Priya','Singh','F','1999-10-10','P22222','priya@gmail.com'),
(5,'Kiran','Patel','M','2001-01-15','P33333','kiran@gmail.com');

-- INSERT INTO FLIGHT

INSERT INTO FLIGHT VALUES
(201,'AI101',1,2,'2026-05-20 06:00:00','2026-05-20 08:00:00',101),
(202,'AI102',2,3,'2026-05-21 09:00:00','2026-05-21 11:30:00',102),
(203,'AI103',3,4,'2026-05-22 01:00:00','2026-05-22 03:30:00',103),
(204,'AI104',4,5,'2026-05-23 04:00:00','2026-05-23 06:00:00',104),
(205,'AI105',5,1,'2026-05-24 07:00:00','2026-05-24 09:00:00',105);

-- INSERT INTO BOOKING

INSERT INTO BOOKING VALUES
(301,1,201,'2026-05-10','A1','Confirmed'),
(302,2,202,'2026-05-11','B2','Confirmed'),
(303,3,203,'2026-05-12','C3','Pending'),
(304,4,204,'2026-05-13','D4','Confirmed'),
(305,5,205,'2026-05-14','E5','Cancelled');

-- INSERT INTO PAYMENT
-- (Create again if dropped)

CREATE TABLE IF NOT EXISTS PAYMENT (
    payment_id INT PRIMARY KEY,
    booking_id INT,
    payment_date DATE,
    amount DECIMAL(10,2),
    payment_method VARCHAR(30),

    FOREIGN KEY (booking_id)
        REFERENCES BOOKING(booking_id)
);

INSERT INTO PAYMENT VALUES
(401,301,'2026-05-10',5000.00,'UPI'),
(402,302,'2026-05-11',7000.00,'Card'),
(403,303,'2026-05-12',6500.00,'Cash'),
(404,304,'2026-05-13',9000.00,'UPI'),
(405,305,'2026-05-14',4500.00,'Card');

-- =========================================================
-- ================= UPDATE / DELETE =======================
-- =========================================================

-- Update booking status

UPDATE BOOKING
SET booking_status = 'Cancelled'
WHERE booking_id = 303;

-- Increase payment amount by 10%

UPDATE PAYMENT
SET amount = amount + (amount * 0.10);

-- Delete passengers with no bookings

DELETE FROM PASSENGER
WHERE passenger_id NOT IN (
    SELECT passenger_id
    FROM BOOKING
);

-- =========================================================
-- ================= SQL CLAUSES ===========================
-- =========================================================

-- 1. Flights departing from Hyderabad

SELECT F.flight_number, A.city
FROM FLIGHT F
JOIN AIRPORT A
ON F.source_airport_id = A.airport_id
WHERE A.city = 'Hyderabad';

-- 2. Passengers born after 1995

SELECT *
FROM PASSENGER
WHERE YEAR(date_of_birth) > 1995;

-- 3. Total bookings per flight

SELECT flight_id, COUNT(*) AS total_bookings
FROM BOOKING
GROUP BY flight_id;

-- 4. Flights with more than 50 bookings

SELECT flight_id, COUNT(*) AS total_bookings
FROM BOOKING
GROUP BY flight_id
HAVING COUNT(*) > 50;

-- 5. Order passengers by last name

SELECT *
FROM PASSENGER
ORDER BY last_name ASC;

-- =========================================================
-- ================= JOINS QUERIES =========================
-- =========================================================

-- 1. Passenger name and flight number

SELECT
    P.first_name,
    P.last_name,
    F.flight_number
FROM PASSENGER P
INNER JOIN BOOKING B
ON P.passenger_id = B.passenger_id
INNER JOIN FLIGHT F
ON B.flight_id = F.flight_id;

-- 2. All flights and passengers (LEFT JOIN)

SELECT
    F.flight_number,
    P.first_name,
    P.last_name
FROM FLIGHT F
LEFT JOIN BOOKING B
ON F.flight_id = B.flight_id
LEFT JOIN PASSENGER P
ON B.passenger_id = P.passenger_id;

-- 3. Flights with payment details

SELECT
    F.flight_number,
    P.payment_id,
    P.amount,
    P.payment_method
FROM FLIGHT F
JOIN BOOKING B
ON F.flight_id = B.flight_id
JOIN PAYMENT P
ON B.booking_id = P.booking_id;

-- 4. Crew members assigned to each flight

SELECT
    F.flight_number,
    C.crew_name,
    C.role
FROM FLIGHT_CREW FC
JOIN FLIGHT F
ON FC.flight_id = F.flight_id
JOIN FLIGHT_CREW_MEMBER C
ON FC.crew_id = C.crew_id;

-- 5. Passenger details with source & destination

SELECT
    P.first_name,
    P.last_name,
    SA.city AS source_city,
    DA.city AS destination_city
FROM PASSENGER P
JOIN BOOKING B
ON P.passenger_id = B.passenger_id
JOIN FLIGHT F
ON B.flight_id = F.flight_id
JOIN AIRPORT SA
ON F.source_airport_id = SA.airport_id
JOIN AIRPORT DA
ON F.destination_airport_id = DA.airport_id;

-- =========================================================
-- ================= SUBQUERIES ============================
-- =========================================================

-- 1. Passengers booked same flight more than once

SELECT passenger_id, flight_id, COUNT(*)
FROM BOOKING
GROUP BY passenger_id, flight_id
HAVING COUNT(*) > 1;

-- 2. Flights having bookings more than average

SELECT flight_id, COUNT(*) AS total_bookings
FROM BOOKING
GROUP BY flight_id
HAVING COUNT(*) >
(
    SELECT AVG(total_count)
    FROM
    (
        SELECT COUNT(*) AS total_count
        FROM BOOKING
        GROUP BY flight_id
    ) AS avg_table
);

-- 3. Most expensive booking

SELECT *
FROM PAYMENT
WHERE amount =
(
    SELECT MAX(amount)
    FROM PAYMENT
);

-- 4. Passengers who never made payment

SELECT *
FROM PASSENGER
WHERE passenger_id NOT IN
(
    SELECT B.passenger_id
    FROM BOOKING B
    JOIN PAYMENT P
    ON B.booking_id = P.booking_id
);

-- 5. Flight with maximum duration

SELECT *
FROM FLIGHT
WHERE TIMESTAMPDIFF(MINUTE, departure_time, arrival_time) =
(
    SELECT MAX(
        TIMESTAMPDIFF(MINUTE, departure_time, arrival_time)
    )
    FROM FLIGHT
);

-- =========================================================
-- ================= VIEWS =================================
-- =========================================================

-- 1. View passenger + flight + seat

CREATE VIEW passenger_flight_view AS
SELECT
    P.first_name,
    P.last_name,
    F.flight_number,
    B.seat_number
FROM PASSENGER P
JOIN BOOKING B
ON P.passenger_id = B.passenger_id
JOIN FLIGHT F
ON B.flight_id = F.flight_id;

-- 2. Active bookings view

CREATE VIEW active_bookings AS
SELECT *
FROM BOOKING
WHERE booking_status = 'Confirmed';

-- 3. Revenue per flight

CREATE VIEW revenue_per_flight AS
SELECT
    F.flight_number,
    SUM(P.amount) AS total_revenue
FROM FLIGHT F
JOIN BOOKING B
ON F.flight_id = B.flight_id
JOIN PAYMENT P
ON B.booking_id = P.booking_id
GROUP BY F.flight_number;

-- 4. Update using view

UPDATE active_bookings
SET booking_status = 'Cancelled'
WHERE booking_id = 301;

-- 5. Drop view

DROP VIEW revenue_per_flight;

-- =========================================================
-- ================= STORED PROCEDURES =====================
-- =========================================================

DELIMITER $$

-- 1. Book flight

CREATE PROCEDURE book_flight(
    IN b_id INT,
    IN p_id INT,
    IN f_id INT,
    IN seat_no VARCHAR(10)
)
BEGIN
    INSERT INTO BOOKING
    VALUES(
        b_id,
        p_id,
        f_id,
        CURDATE(),
        seat_no,
        'Confirmed'
    );
END $$

-- 2. Passenger booking history

CREATE PROCEDURE passenger_history(
    IN p_id INT
)
BEGIN
    SELECT *
    FROM BOOKING
    WHERE passenger_id = p_id;
END $$

-- 3. Cancel booking

CREATE PROCEDURE cancel_booking(
    IN b_id INT
)
BEGIN
    UPDATE BOOKING
    SET booking_status = 'Cancelled'
    WHERE booking_id = b_id;
END $$

-- 4. Total revenue of flight

CREATE PROCEDURE total_revenue(
    IN f_id INT
)
BEGIN
    SELECT
        SUM(P.amount) AS total_amount
    FROM PAYMENT P
    JOIN BOOKING B
    ON P.booking_id = B.booking_id
    WHERE B.flight_id = f_id;
END $$

-- 5. Insert passenger

CREATE PROCEDURE add_passenger(
    IN p_id INT,
    IN fname VARCHAR(50),
    IN lname VARCHAR(50),
    IN gen CHAR(1),
    IN dob DATE,
    IN passport VARCHAR(20),
    IN mail VARCHAR(100)
)
BEGIN
    INSERT INTO PASSENGER
    VALUES(
        p_id,
        fname,
        lname,
        gen,
        dob,
        passport,
        mail
    );
END $$

DELIMITER ;

-- =========================================================
-- ================= TRIGGERS ===============================
-- =========================================================

DELIMITER $$

-- 1. Prevent overbooking

CREATE TRIGGER check_seat_limit
BEFORE INSERT ON BOOKING
FOR EACH ROW
BEGIN

    DECLARE booked_count INT;
    DECLARE seat_capacity INT;

    SELECT COUNT(*)
    INTO booked_count
    FROM BOOKING
    WHERE flight_id = NEW.flight_id;

    SELECT A.total_seats
    INTO seat_capacity
    FROM AIRCRAFT A
    JOIN FLIGHT F
    ON A.aircraft_id = F.aircraft_id
    WHERE F.flight_id = NEW.flight_id;

    IF booked_count >= seat_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seats Full';
    END IF;

END $$

-- 2. Update booking status after payment

CREATE TRIGGER payment_status_update
AFTER INSERT ON PAYMENT
FOR EACH ROW
BEGIN

    UPDATE BOOKING
    SET booking_status = 'Confirmed'
    WHERE booking_id = NEW.booking_id;

END $$

-- 3. Audit deleted bookings

CREATE TABLE booking_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    deleted_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER booking_delete_audit
AFTER DELETE ON BOOKING
FOR EACH ROW
BEGIN

    INSERT INTO booking_audit(booking_id)
    VALUES(OLD.booking_id);

END $$

-- 4. Prevent deleting flights with bookings

CREATE TRIGGER prevent_flight_delete
BEFORE DELETE ON FLIGHT
FOR EACH ROW
BEGIN

    DECLARE total_bookings INT;

    SELECT COUNT(*)
    INTO total_bookings
    FROM BOOKING
    WHERE flight_id = OLD.flight_id;

    IF total_bookings > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete flight with bookings';
    END IF;

END $$

-- 5. Auto payment date

CREATE TRIGGER auto_payment_date
BEFORE INSERT ON PAYMENT
FOR EACH ROW
BEGIN

    IF NEW.payment_date IS NULL THEN
        SET NEW.payment_date = CURDATE();
    END IF;

END $$

DELIMITER ;