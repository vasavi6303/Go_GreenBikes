CREATE OR REPLACE PACKAGE application_ride_pkg IS
    PROCEDURE start_ride(
        p_user_id  IN ride.user_user_id%TYPE,
        p_bike_id  IN ride.bike_bike_id%TYPE
    );
END application_ride_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_ride_pkg IS
    PROCEDURE start_ride(
        p_user_id  IN ride.user_user_id%TYPE,
        p_bike_id  IN ride.bike_bike_id%TYPE
    ) IS
        v_bike_status_id     NUMBER;
        v_remaining_time     NUMBER;
        v_location_id        NUMBER;
        v_location_status    VARCHAR2(20);

        -- Exceptions
        bike_not_available           EXCEPTION;
        PRAGMA EXCEPTION_INIT(bike_not_available, -20001);

        insufficient_subscription_time EXCEPTION;
        PRAGMA EXCEPTION_INIT(insufficient_subscription_time, -20002);

        no_bike_found EXCEPTION;
        PRAGMA EXCEPTION_INIT(no_bike_found, -20204);

        no_user_subscription_found EXCEPTION;
        PRAGMA EXCEPTION_INIT(no_user_subscription_found, -20205);

        location_not_active EXCEPTION;
        PRAGMA EXCEPTION_INIT(location_not_active, -20206);

        user_not_found EXCEPTION;
        bike_not_found EXCEPTION;
BEGIN
        -- Check if user exists
SELECT COUNT(*) INTO v_remaining_time FROM user_subs WHERE user_user_id = p_user_id;
IF v_remaining_time = 0 THEN
            RAISE user_not_found;
END IF;

        -- Check if bike exists
SELECT COUNT(*) INTO v_bike_status_id FROM bike WHERE bike_id = p_bike_id;
IF v_bike_status_id = 0 THEN
            RAISE bike_not_found;
END IF;

        -- Check bike availability and fetch its location
SELECT bike_status_status_id, location_location_id INTO v_bike_status_id, v_location_id
FROM bike WHERE bike_id = p_bike_id;

-- Ensure bike is available
IF v_bike_status_id != 1 THEN -- Assuming '1' is the status ID for 'Available'
            RAISE bike_not_available;
END IF;

        -- Check if location is active
SELECT loc_status INTO v_location_status FROM location WHERE location_id = v_location_id;
IF v_location_status != 'Active' THEN
            RAISE location_not_active;
END IF;

        -- Check user's subscription validity
SELECT remaining_time INTO v_remaining_time FROM user_subs WHERE user_user_id = p_user_id;
IF v_remaining_time <= 0 THEN
            RAISE insufficient_subscription_time;
END IF;

        -- Update the bike status to 'In Use'
UPDATE bike SET bike_status_status_id = 2 WHERE bike_id = p_bike_id; -- Assuming '2' is 'In Use'

-- Insert a new ride record
INSERT INTO ride (start_time, start_location_id, user_user_id, bike_bike_id)
VALUES (SYSTIMESTAMP, v_location_id, p_user_id, p_bike_id);
EXCEPTION
        WHEN user_not_found THEN
            dbms_output.put_line('Error: No user found with the given user ID.');
WHEN bike_not_found THEN
            dbms_output.put_line('Error: No bike found with the given bike ID.');
WHEN bike_not_available THEN
            dbms_output.put_line('Error: Bike is not available for use.');
WHEN insufficient_subscription_time THEN
            dbms_output.put_line('Error: Insufficient subscription time to start a ride.');
WHEN no_bike_found THEN
            dbms_output.put_line('Error: No bike found with the given ID.');
WHEN no_user_subscription_found THEN
            dbms_output.put_line('Error: No subscription record found for the user ID.');
WHEN location_not_active THEN
            dbms_output.put_line('Error: The bike location is not active.');
WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception: ' || SQLERRM);
END start_ride;
END application_ride_pkg;
/




BEGIN
    application_ride_pkg.start_ride(

        p_user_id => 1,
        p_bike_id => 4
    );
COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error during ride start: ' || SQLERRM);
END;



