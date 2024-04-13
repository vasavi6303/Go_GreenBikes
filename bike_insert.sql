CREATE OR REPLACE PACKAGE application_bike_pkg IS
    PROCEDURE insert_bike(
        p_bike_status_status_id IN bike.bike_status_status_id%TYPE,
        p_location_location_id  IN bike.location_location_id%TYPE
    );
END application_bike_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_bike_pkg IS
    PROCEDURE insert_bike(
        p_bike_status_status_id IN bike.bike_status_status_id%TYPE,
        p_location_location_id  IN bike.location_location_id%TYPE
    ) IS
        v_status_exists   NUMBER;
        v_location_exists NUMBER;

        -- Exceptions
        invalid_status_id EXCEPTION;
        invalid_location_id EXCEPTION;

        PRAGMA EXCEPTION_INIT(invalid_status_id, -20010);
        PRAGMA EXCEPTION_INIT(invalid_location_id, -20020);
    BEGIN
        -- Check if bike_status_status_id exists
        SELECT COUNT(*) INTO v_status_exists FROM bike_status WHERE status_id = p_bike_status_status_id;
        IF v_status_exists = 0 THEN
            RAISE invalid_status_id;
        END IF;

        -- Check if location_location_id exists
        SELECT COUNT(*) INTO v_location_exists FROM location WHERE location_id = p_location_location_id;
        IF v_location_exists = 0 THEN
            RAISE invalid_location_id;
        END IF;

        -- Perform the insert
        INSERT INTO bike (bike_status_status_id, location_location_id)
        VALUES (p_bike_status_status_id, p_location_location_id);
    EXCEPTION
        WHEN invalid_status_id THEN
            dbms_output.put_line('Error: Invalid bike status ID provided.');
        WHEN invalid_location_id THEN
            dbms_output.put_line('Error: Invalid location ID provided.');
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception: ' || SQLERRM);
    END insert_bike;
END application_bike_pkg;
/

-- Invocation block
BEGIN
    application_bike_pkg.insert_bike(1, 1);
    application_bike_pkg.insert_bike(1, 2);
    application_bike_pkg.insert_bike(1, 3);
    application_bike_pkg.insert_bike(1, 4);
    application_bike_pkg.insert_bike(1, 5);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error during bike insertion: ' || SQLERRM);
END;
