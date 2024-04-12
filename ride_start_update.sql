CREATE OR REPLACE PACKAGE application_ride_stop_pkg IS
    PROCEDURE stop_ride(
        p_ride_id           IN ride.ride_id%TYPE,
        p_end_time          IN ride.end_time%TYPE,
        p_bike_status       IN bike_status.status_name%TYPE
    );
END application_ride_stop_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_ride_stop_pkg IS
    PROCEDURE stop_ride(
        p_ride_id           IN ride.ride_id%TYPE,
        p_end_time          IN ride.end_time%TYPE,
        p_bike_status       IN bike_status.status_name%TYPE
    ) IS
        v_bike_id        NUMBER;
        v_user_id        NUMBER;
        v_start_time     TIMESTAMP;
        v_duration       NUMBER;
        v_remaining_time NUMBER;
        v_new_status_id  NUMBER;
        v_cost_type      VARCHAR2(100);
        v_amount         NUMBER := 0;

    BEGIN
        -- Retrieve current ride details
        SELECT bike_bike_id, user_user_id, start_time INTO v_bike_id, v_user_id, v_start_time
        FROM ride WHERE ride_id = p_ride_id;

        -- Calculate the ride duration in minutes
        v_duration := (p_end_time - v_start_time) * 1440;  -- Minutes between timestamps

        -- Retrieve remaining time from user_subs
        SELECT remaining_time INTO v_remaining_time FROM user_subs WHERE user_user_id = v_user_id;

        -- Update the remaining time
        UPDATE user_subs
        SET remaining_time = GREATEST(v_remaining_time - v_duration, 0)  -- Ensure it does not go negative
        WHERE user_user_id = v_user_id;

        -- Update the ride with the end time
        UPDATE ride
        SET end_time = p_end_time
        WHERE ride_id = p_ride_id;

        -- Update bike status
        SELECT status_id INTO v_new_status_id FROM bike_status WHERE status_name = p_bike_status;
        UPDATE bike
        SET bike_status_status_id = v_new_status_id
        WHERE bike_id = v_bike_id;

        -- Handle miscellaneous costs
        IF p_bike_status = 'Lost' THEN
            v_amount := 1200;
            v_cost_type := 'Lost';
        ELSIF p_bike_status = 'Damage' THEN
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
            v_amount := CEIL((v_duration - v_remaining_time) / 5);  -- $1 for every 5 minutes over
            INSERT INTO miscellaneous_cost (cost_type, amount, ride_ride_id, status)
            VALUES ('Minutes Exceeded', v_amount, p_ride_id, 'Pending');
        END IF;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            dbms_output.put_line('Error stopping ride: ' || SQLERRM);
    END stop_ride;
END application_ride_stop_pkg;
/

BEGIN
    application_ride_stop_pkg.stop_ride(
        p_ride_id => 101,
        p_end_time => SYSTIMESTAMP,
        p_bike_status => 'Damage'  -- or 'Lost' or any valid status
    );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || SQLERRM);
END;
