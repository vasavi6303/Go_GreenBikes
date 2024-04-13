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
        v_duration       NUMBER;
        v_remaining_time NUMBER;
        v_status_name    VARCHAR2(20);
        v_cost_type      VARCHAR2(100);
        v_amount         NUMBER := 0;
        v_dummy          NUMBER;

        -- Custom exceptions
        e_invalid_ride_id        EXCEPTION;
        e_invalid_location_id    EXCEPTION;
        e_invalid_bike_status    EXCEPTION;

    BEGIN
        -- Validate ride_id
        BEGIN
            SELECT bike_bike_id, user_user_id, start_time INTO v_bike_id, v_user_id, v_start_time
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


        DBMS_OUTPUT.PUT_LINE('Start Time: ' || TO_CHAR(v_start_time, 'DD-MON-YYYY HH24:MI:SS'));
        DBMS_OUTPUT.PUT_LINE('End Time: ' || TO_CHAR(p_end_time, 'DD-MON-YYYY HH24:MI:SS'));



        -- Calculate the ride duration in minutes
        v_duration := (EXTRACT(DAY FROM (p_end_time - v_start_time)) * 1440) +
                      (EXTRACT(HOUR FROM (p_end_time - v_start_time)) * 60) +
                      EXTRACT(MINUTE FROM (p_end_time - v_start_time));

        -- Ensure non-negative and meaningful duration
        IF v_duration < 1 THEN
            v_duration := 0;
        ELSE
            v_duration := ROUND(v_duration);
        END IF;

        -- Retrieve remaining time from user_subs
        SELECT remaining_time INTO v_remaining_time FROM user_subs WHERE user_user_id = v_user_id;

        -- Update the remaining time and ride information
        UPDATE user_subs
        SET remaining_time = GREATEST(v_remaining_time - v_duration, 0)
        WHERE user_user_id = v_user_id;

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
        END IF;

        -- Handle extra time costs if duration exceeds remaining time
        IF v_duration > v_remaining_time THEN
            v_amount := CEIL((v_duration - v_remaining_time) / 5);
            INSERT INTO miscellaneous_cost (cost_type, amount, ride_ride_id, status)
            VALUES ('Minutes Exceeded', v_amount, p_ride_id, 'Pending');
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
        p_ride_id => 3,  -- This ID does not exist
        p_end_time => SYSTIMESTAMP,
        p_end_location_id => 2,  -- Assume this ID is provided
        p_bike_status => 1  -- Example status ID
    );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || SQLERRM);
END;


