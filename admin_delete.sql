CREATE OR REPLACE PACKAGE application_user_delete_pkg IS
    PROCEDURE delete_all(
        p_subsplan_id IN subs_plan.subsplan_id%TYPE DEFAULT NULL,
        p_location_id IN location.location_id%TYPE DEFAULT NULL,
        p_status_id IN bike_status.status_id%TYPE DEFAULT NULL,
        p_trans_type_id IN trans_type.trans_type_id%TYPE DEFAULT NULL
    );
END application_user_delete_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_user_delete_pkg IS
    PROCEDURE delete_all(
        p_subsplan_id IN subs_plan.subsplan_id%TYPE DEFAULT NULL,
        p_location_id IN location.location_id%TYPE DEFAULT NULL,
        p_status_id IN bike_status.status_id%TYPE DEFAULT NULL,
        p_trans_type_id IN trans_type.trans_type_id%TYPE DEFAULT NULL
    ) IS
    BEGIN
        -- Delete from subs_plan if ID is provided
        IF p_subsplan_id IS NOT NULL THEN
            DELETE FROM subs_plan WHERE subsplan_id = p_subsplan_id;
        END IF;
        
        -- Delete from location if ID is provided
        IF p_location_id IS NOT NULL THEN
            DELETE FROM location WHERE location_id = p_location_id;
        END IF;
        
        -- Delete from bike_status if ID is provided
        IF p_status_id IS NOT NULL THEN
            DELETE FROM bike_status WHERE status_id = p_status_id;
        END IF;
        
        -- Delete from trans_type if ID is provided
        IF p_trans_type_id IS NOT NULL THEN
            DELETE FROM trans_type WHERE trans_type_id = p_trans_type_id;
        END IF;
        
        -- Note: This approach assumes no foreign key constraints are violated with these deletions.
        -- If there are dependent records in other tables, handle those before performing deletions here.
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception: ' || SQLERRM);
    END delete_all;
END application_user_delete_pkg;
/


BEGIN
    application_user_delete_pkg.delete_all(
        p_subsplan_id => 1,
        p_location_id => 1,
        p_status_id => 1,
        p_trans_type_id => 1
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;


