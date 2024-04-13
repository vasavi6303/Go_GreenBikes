CREATE OR REPLACE PACKAGE application_user_delete_pkg IS
    PROCEDURE delete_all(
        p_subsplan_id IN subs_plan.subsplan_id%TYPE DEFAULT NULL,
        p_location_id IN location.location_id%TYPE DEFAULT NULL
       
    );
END application_user_delete_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_user_delete_pkg IS
    PROCEDURE delete_all(
        p_subsplan_id IN subs_plan.subsplan_id%TYPE DEFAULT NULL,
        p_location_id IN location.location_id%TYPE DEFAULT NULL
       
    ) IS
    BEGIN
        -- Handling deletion for trans_type, least likely to have dependencies
        
        
        -- Handling deletion for location, check for dependencies
        IF p_location_id IS NOT NULL THEN
            DELETE FROM bike WHERE location_location_id = p_location_id;
            DELETE FROM location_address WHERE location_location_id = p_location_id;
            DELETE FROM location WHERE location_id = p_location_id;
            IF SQL%ROWCOUNT = 0 THEN
                dbms_output.put_line('No location found with ID: ' || p_location_id);
            END IF;
        END IF;

        -- Handling deletion for subs_plan, check for dependencies in user_subs
        IF p_subsplan_id IS NOT NULL THEN
            DELETE FROM user_subs WHERE subs_plan_subsplan_id = p_subsplan_id;
            DELETE FROM subs_plan WHERE subsplan_id = p_subsplan_id;
            IF SQL%ROWCOUNT = 0 THEN
                dbms_output.put_line('No subscription plan found with ID: ' || p_subsplan_id);
            END IF;
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception: ' || SQLERRM);
            RAISE; -- Re-raise the exception to ensure it can be caught by the calling block
    END delete_all;
END application_user_delete_pkg;
/

BEGIN
    -- Sample usage of the delete_all procedure
    application_user_delete_pkg.delete_all(
        p_subsplan_id => 4,
        p_location_id => 4
    
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
