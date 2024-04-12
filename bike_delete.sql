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
    BEGIN
        DELETE FROM bike WHERE bike_id = p_bike_id;
    END delete_bike;
END application_bike_delete_pkg;
/


BEGIN
    application_bike_delete_pkg.delete_bike(p_bike_id => 5);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
