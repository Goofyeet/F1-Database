USE f1;

-- QUERY 1 -- Drivers born in the 1800's --
SELECT first_name, last_name, birth_date, TIMESTAMPDIFF(YEAR,birth_date, CURRENT_DATE()) AS years_since_dob FROM drivers
	WHERE birth_date < '1900-01-01'
    ORDER BY birth_date ASC;


-- QUERY 2 -- Fastest speeds recorded in a race --
SELECT race_date, race_name, fastest_lap_speed FROM results INNER JOIN races USING(race_id)
	WHERE fastest_lap_speed IS NOT NULL AND fastest_lap_speed > 220
    ORDER BY fastest_lap_speed DESC;
    

-- QUERY 3 -- Number of races raced at each circuit --
SELECT race_name, circuit_name, country, count(*) AS 'num_races' FROM races inner join circuits using(circuit_id)
	GROUP BY race_name, circuit_name, country
    ORDER BY COUNT(*) DESC;
    

-- QUERY 4 -- Average number of races and points per driver --
SELECT AVG(num_races) AS avg_num_races, AVG(total_points) AS avg_points, AVG(total_points) / AVG(num_races) AS points_per_race FROM 
    (SELECT driver_id, COUNT(*) AS num_races, AVG(position_order) AS avg_position, SUM(points) AS total_points  FROM results
		GROUP BY driver_id) poles;
    

-- QUERY 5 -- Creates a view from an easier to read result table --
CREATE VIEW nice_result AS
SELECT CONCAT(drivers.first_name,' ', drivers.last_name) AS full_name, constructors.constructor_name AS constructor, races.race_name AS race, car_num, grid_position, position_text, position_order, points, laps, milliseconds, races.race_date AS race_date
	FROM results INNER JOIN drivers USING(driver_id) INNER JOIN constructors USING(constructor_id) INNER JOIN races USING(race_id);

-- select from view
SELECT * FROM nice_result;

-- Delete any result in results that didn't score a point
DELETE FROM results
	WHERE result_id IN (SELECT result_id FROM (SELECT * FROM results)new_results
	WHERE points = 0);
    
-- select from view again and notice that there are no more results that scored zero points
SELECT * FROM nice_result;
