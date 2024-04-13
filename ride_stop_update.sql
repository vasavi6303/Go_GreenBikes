SET SERVEROUTPUT ON;

CREATE OR REPLACE PACKAGE application_ride_stop_pkg IS
    PROCEDURE stop_ride(
        p_ride_id           IN ride.ride_id%TYPE,
        p_end_time          IN ride.end_time%TYPE,
        p_end_location_id   IN ride.end_location_id%TYPE,
        p_bike_status       IN bike_status.status_id%TYPE
    );
END application_ride_stop_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_ride_stop_pkg IS
    PROCEDURE stop_ride(
        p_ride_id           IN ride.ride_id%TYPE,
        p_end_time          IN ride.end_time%TYPE,
        p_end_location_id   IN ride.end_location_id%TYPE,
        p_bike_status       IN bike_status.status_id%TYPE
    ) IS
        v_bike_id        NUMBER;
        v_user_id        NUMBER;
        v_start_time     TIMESTAMP;
        v_end_time     TIMESTAMP;
        v_duration       NUMBER;
        v_remaining_time NUMBER;
        v_status_name    VARCHAR2(20);
        v_cost_type      VARCHAR2(100);
        v_amount         NUMBER := 0;
        v_extra_amount     NUMBER := 0;
        v_dummy          NUMBER;

        -- Custom exceptions
        e_invalid_ride_id        EXCEPTION;
        e_invalid_location_id    EXCEPTION;
        e_invalid_bike_status    EXCEPTION;

    BEGIN
        -- Validate ride_id
        BEGIN
            SELECT bike_bike_id, user_user_id, start_time , end_time INTO v_bike_id, v_user_id, v_start_time, v_end_time
            FROM ride WHERE ride_id = p_ride_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_invalid_ride_id;
        END;
        
        
        -- Validate end_location_id
        BEGIN
            SELECT 1 INTO v_dummy FROM location WHERE location_id = p_end_location_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_invalid_location_id;
        END;

        -- Validate bike_status
        BEGIN
            SELECT status_name INTO v_status_name FROM bike_status WHERE status_id = p_bike_status;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE e_invalid_bike_status;
        END;
        
        IF v_bike_id IS NOT NULL THEN
        
        IF v_end_time IS NULL THEN

        DBMS_OUTPUT.PUT_LINE(v_start_time);
        DBMS_OUTPUT.PUT_LINE( p_end_time);
        
       


        -- Calculate the ride duration in minutes
        v_duration := (EXTRACT(DAY FROM p_end_time) * 1440) - (EXTRACT(DAY FROM v_start_time) * 1440) +
(EXTRACT(HOUR FROM p_end_time) * 60) - (EXTRACT(HOUR FROM v_start_time) * 60) +
(EXTRACT(MINUTE FROM p_end_time)) - (EXTRACT(MINUTE FROM v_start_time));

    
      

        -- Retrieve remaining time from user_subs
        SELECT remaining_time INTO v_remaining_time FROM user_subs WHERE user_user_id = v_user_id;
        
        IF v_remaining_time >= v_duration THEN
        -- Update the remaining time and ride information
        UPDATE user_subs
        SET remaining_time = GREATEST(v_remaining_time - v_duration, 0)
        WHERE user_user_id = v_user_id;
        
        ELSE
        UPDATE user_subs
        SET remaining_time = 0,user_subs_status ='InActive'
        WHERE user_user_id = v_user_id;
       
       -- Handle extra time costs if duration exceeds remaining time 
        v_extra_amount := CEIL((v_duration - v_remaining_time) / 5);
            INSERT INTO miscellaneous_cost (cost_type, amount, ride_ride_id, status)
            VALUES ('Minutes Exceeded', v_extra_amount, p_ride_id, 'Pending');
        
        END IF;

        UPDATE ride
        SET end_time = p_end_time,
            duration_time = v_duration,
            end_location_id = p_end_location_id
        WHERE ride_id = p_ride_id;

        -- Update bike status
        UPDATE bike
        SET bike_status_status_id = p_bike_status
        WHERE bike_id = v_bike_id;

        -- Handle miscellaneous costs based on status name
        IF v_status_name = 'Lost' THEN
            v_amount := 1200;
            v_cost_type := 'Lost';
        ELSIF v_status_name = 'Damage' THEN
            v_amount := 200;
            v_cost_type := 'Damage';
        END IF;

        -- Insert lost or damage costs
        IF v_amount > 0 THEN
            INSERT INTO miscellaneous_cost (cost_type, amount, ride_ride_id, status)
            VALUES (v_cost_type, v_amount, p_ride_id, 'Pending');
            
            UPDATE user_subs
            SET user_subs_status = 'InActive'
            WHERE user_user_id = v_user_id;
        END IF;
        
        ELSE
            dbms_output.put_line('Error: Ride is completed');

     END IF;
    END IF;

        COMMIT;
    EXCEPTION
        WHEN e_invalid_ride_id THEN
            dbms_output.put_line('Error: Invalid ride ID provided.');
            ROLLBACK;
        WHEN e_invalid_location_id THEN
            dbms_output.put_line('Error: Invalid end location ID provided.');
            ROLLBACK;
        WHEN e_invalid_bike_status THEN
            dbms_output.put_line('Error: Invalid bike status ID provided.');
            ROLLBACK;
        WHEN OTHERS THEN
            dbms_output.put_line('Error stopping ride: ' || SQLERRM);
            ROLLBACK;
    END stop_ride;
END application_ride_stop_pkg;
/





BEGIN
    application_ride_stop_pkg.stop_ride(
        p_ride_id => 1,  -- This ID does not exist
        p_end_time => SYSTIMESTAMP,
        p_end_location_id => 2,  -- Assume this ID is provided
        p_bike_status => 3  -- Example status ID
    );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || SQLERRM);
END;

