CREATE OR REPLACE PACKAGE application_bike_update_pkg IS
  
    
    PROCEDURE update_bike(
        p_bike_id               IN bike.bike_id%TYPE,
        p_bike_status_status_id IN bike.bike_status_status_id%TYPE DEFAULT NULL,
        p_location_location_id  IN bike.location_location_id%TYPE DEFAULT NULL
    );
    
 
END application_bike_update_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_bike_update_pkg IS
    
    
    PROCEDURE update_bike(
        p_bike_id               IN bike.bike_id%TYPE,
        p_bike_status_status_id IN bike.bike_status_status_id%TYPE DEFAULT NULL,
        p_location_location_id  IN bike.location_location_id%TYPE DEFAULT NULL
    ) IS
    BEGIN
        UPDATE bike
        SET bike_status_status_id = COALESCE(p_bike_status_status_id, bike_status_status_id),
            location_location_id = COALESCE(p_location_location_id, location_location_id)
        WHERE bike_id = p_bike_id;
    END update_bike;
    
    
END application_bike_update_pkg;
/


BEGIN
    application_bike_update_pkg.update_bike(p_bike_id => 2, p_bike_status_status_id => 2);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;