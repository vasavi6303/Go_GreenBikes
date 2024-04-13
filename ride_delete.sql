CREATE OR REPLACE PACKAGE application_ride_delete_pkg IS
    PROCEDURE delete_ride(
        p_ride_id      IN ride.ride_id%TYPE DEFAULT NULL
       
    );
END application_ride_delete_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_ride_delete_pkg IS
    PROCEDURE delete_ride(
        p_ride_id      IN ride.ride_id%TYPE DEFAULT NULL
      
    ) IS
        v_deletion_count NUMBER;
    BEGIN
        -- Delete by specific ride ID if provided
        IF p_ride_id IS NOT NULL THEN
            DELETE FROM ride WHERE ride_id = p_ride_id;
            v_deletion_count := SQL%ROWCOUNT;
            IF v_deletion_count = 0 THEN
                dbms_output.put_line('No ride found with ride ID: ' || p_ride_id);
            ELSE
                dbms_output.put_line('Ride deleted successfully.');
            END IF;
            RETURN;
        END IF;
    
        -- Inform if no parameter is provided
        dbms_output.put_line('No valid identifiers provided for deletion.');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception during ride deletion: ' || SQLERRM);
            RAISE;
    END delete_ride;
END application_ride_delete_pkg;
/



BEGIN
    application_ride_delete_pkg.delete_ride(
        p_ride_id => 3  -- This ID does not exist
      
    );
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || SQLERRM);
END;

