DROP DATABASE IF EXISTS f1;
CREATE DATABASE f1;
USE f1;

-- Drop tables if they exist
DROP TABLE IF EXISTS results;
DROP TABLE IF EXISTS races;
DROP TABLE IF EXISTS constructors;
DROP TABLE IF EXISTS drivers;
DROP TABLE IF EXISTS circuits;

-- 
-- CREATE TABLE STATEMENTS
-- 
-- Creates circuits table
CREATE TABLE circuits (
	circuit_id SMALLINT PRIMARY KEY,	-- Assigns Primary Key
    circuit_name VARCHAR(255),
    location VARCHAR(50),
    country VARCHAR(50),
    lat DOUBLE,							-- Latitude
    lon DOUBLE,							-- Longitude
    alt INT								-- Altitude
);


-- Creates races table
CREATE TABLE races (
	race_id INT PRIMARY KEY,	-- Assigns Primary Key
    round INT,
    circuit_id SMALLINT,
    race_name VARCHAR(50),
    race_date DATE,
    CHECK (round > 0),
    FOREIGN KEY (circuit_id) REFERENCES circuits(circuit_id) ON UPDATE CASCADE	-- Assigns circuit_id as a Foreign Key referencing circuit_id in the circuits table
);


-- Creates drivers table
CREATE TABLE drivers (
	driver_id INT PRIMARY KEY,	-- Assigns Primary Key
    first_name VARCHAR(35),
    last_name VARCHAR(35),
    birth_date DATE,
    nationality VARCHAR(35)
);


-- Creates constructors table
CREATE TABLE constructors (
	constructor_id INT PRIMARY KEY,	-- Assigns Primary Key
    constructor_name VARCHAR(35),
    nationality VARCHAR(35)
);


-- Creates results table
CREATE TABLE results (
	result_id INT AUTO_INCREMENT PRIMARY KEY,	-- Assigns Primary Key and sets this attribute as auto incrementing
    race_id INT,				-- Foreign key
    driver_id INT,				-- Foreign Key
    constructor_id INT,			-- Foreign Key
    car_num INT,				-- The number assigned to the car
    grid_position INT,			-- The position the driver started the race in
    finish_position TINYINT,	-- The position the driver finished the race in, null if did not finish
    position_text VARCHAR(2),	-- Allows us to indicate a driver retirement, R signifies a retirement
    position_order INT,			-- The position the driver finished in after taking in account for retirements
    points INT,					-- # of points the driver won from the race
    laps SMALLINT,				-- # of laps the driver raced
    milliseconds INT,
    
    -- FASTEST LAP STATS ONLY AVAILABLE FOR 2004 SEASON AND AFTER
    fastest_lap INT,				-- The lap that the driver set their fastest time on
    fastest_lap_rank INT,			-- #'s the drivers from fastest to slowest lap times
    fastest_lap_time TIME,			-- The time of the driver's fastest lap
    fastest_lap_speed DECIMAL(6,3),	-- The average speed of their fastest lap in km/h
    CHECK(car_num >= 0),
    CHECK(points >= 0),
    FOREIGN KEY (race_id) REFERENCES races(race_id) ON DELETE CASCADE ON UPDATE CASCADE,						-- Assigns race_id as a Foreign Key referencing race_id in the races table
    FOREIGN KEY (driver_id) REFERENCES drivers(driver_id) ON DELETE CASCADE ON UPDATE CASCADE,					-- Assigns driver_id as a Foreign Key referencing driver_id in the drivers table
    FOREIGN KEY (constructor_id) REFERENCES constructors(constructor_id) ON DELETE CASCADE ON UPDATE CASCADE	-- Assigns constructor_id as a Foreign Key referencing constructor_id in the constructors table
);


-- 
-- LOAD DATA STATEMENTS
-- 
-- Loads data into circuits table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/circuits.csv'
INTO TABLE circuits
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


-- Loads data into races table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/races.csv'
INTO TABLE races
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


-- Loads data into drivers table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/drivers.csv'
INTO TABLE drivers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


-- Loads data into constructors table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/constructors.csv'
INTO TABLE constructors
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;


-- Loads data into results table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/results.csv'
INTO TABLE results
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(race_id, driver_id, constructor_id, car_num, grid_position, finish_position, position_text, position_order, points, laps, milliseconds, fastest_lap, fastest_lap_rank, fastest_lap_time, fastest_lap_speed);
