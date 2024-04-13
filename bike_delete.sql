SET SERVEROUTPUT ON;
CREATE OR REPLACE PACKAGE application_bike_delete_pkg IS
    PROCEDURE delete_bike(
        p_bike_id IN bike.bike_id%TYPE
    );
END application_bike_delete_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_bike_delete_pkg IS
    PROCEDURE delete_bike(
        p_bike_id IN bike.bike_id%TYPE
    ) IS
        v_count NUMBER;
        bike_not_found EXCEPTION;
    BEGIN
        -- Check if bike_id exists
        SELECT COUNT(*)
        INTO v_count
        FROM bike
        WHERE bike_id = p_bike_id;

        IF v_count = 0 THEN
            RAISE bike_not_found;
        ELSE
            DELETE FROM bike WHERE bike_id = p_bike_id;
            dbms_output.put_line('Bike with ID: ' || p_bike_id || ' has been successfully deleted.');
        END IF;
    EXCEPTION
        WHEN bike_not_found THEN
            dbms_output.put_line('No bike found with ID: ' || p_bike_id);
        WHEN OTHERS THEN
            dbms_output.put_line('Error: ' || SQLERRM);
            ROLLBACK; -- Ensure transaction is rolled back on error
    END delete_bike;
END application_bike_delete_pkg;
/

BEGIN
    application_bike_delete_pkg.delete_bike(p_bike_id => 10);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error in transaction: ' || SQLERRM);
END;
/
