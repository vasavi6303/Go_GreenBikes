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
    BEGIN
        INSERT INTO bike ( bike_status_status_id, location_location_id)
        VALUES (p_bike_status_status_id, p_location_location_id);
    END insert_bike;
    
    
END application_bike_pkg;
/


BEGIN
    application_bike_pkg.insert_bike( 1, 1);
    application_bike_pkg.insert_bike( 1, 2);
    application_bike_pkg.insert_bike( 1, 3);
    application_bike_pkg.insert_bike( 1, 4);
    application_bike_pkg.insert_bike( 1, 5);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;



