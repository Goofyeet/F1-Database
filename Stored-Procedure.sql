DELIMITER $$

-- Deletes any data related to this driver
-- Updates race results as if this driver never participated
DROP PROCEDURE IF EXISTS deleteDriverFromHistory$$
CREATE PROCEDURE deleteDriverFromHistory(IN fName VARCHAR(35), IN lName VARCHAR(35))
BEGIN
START TRANSACTION;
	SET @delete_id = (SELECT driver_id FROM drivers WHERE first_name = fName AND last_name = lName);
	
    -- Delete driver from driver table
    DELETE FROM drivers
		WHERE driver_id = @delete_id;
        
	-- Decrement driver_id on drivers below deleted driver
	UPDATE drivers
		SET driver_id = driver_id - 1
        WHERE driver_id > @delete_id;
COMMIT;
END $$

-- Disqualifies driver from a race
DROP PROCEDURE IF EXISTS disqualifyDriver$$
CREATE PROCEDURE disqualifyDriver(IN driver INT, IN race INT)
BEGIN
START TRANSACTION;
	SET @oldPos = (SELECT position_order FROM results WHERE driver_id = driver AND race_id = race);
    SET @maxPos = (SELECT MAX(position_order) FROM results WHERE race_id = race);

	-- Update positions of drivers that placed below driver
    UPDATE results
		SET position_order = position_order - 1,
        
			-- update finish position to position_order if it is not null
			finish_position = CASE
				WHEN finish_position IS NOT NULL THEN position_order END,
                
			-- update position_text to position_order if they finished the race
			position_text = CASE
				WHEN position_text REGEXP '^[0-9]+$' THEN CONVERT(position_order, CHAR(2))
				ELSE position_text END
        WHERE position_order > @oldPos AND race_id = race;

	-- Update drivers position in a race
	UPDATE results
		SET position_text = 'D', position_order = @maxPos, finish_position = null, points = 0
        WHERE driver_id = driver AND race_id = race;
        
COMMIT;
END $$

DELIMITER ;


SET @first = 'Lewis';
SET @last = 'Hamilton';

-- Deletes Lewis Hamilton from driver and results records
CALL deleteDriverFromHistory(@first, @last);

-- Disqualifies driver with driver_id 1 from race with race_id 18
CALL disqualifyDriver(1, 18);