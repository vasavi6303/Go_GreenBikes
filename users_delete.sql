
CREATE OR REPLACE PACKAGE application_user_delete_pkg IS
    PROCEDURE delete_all(p_user_id IN users.user_id%TYPE);
END application_user_delete_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_user_delete_pkg IS
    PROCEDURE delete_all(p_user_id IN users.user_id%TYPE) IS
        v_count NUMBER;
        user_not_found EXCEPTION;  -- Custom exception for user not found scenario
    BEGIN
        -- Check if the user_id exists
        SELECT COUNT(*)
        INTO v_count
        FROM users
        WHERE user_id = p_user_id;

        IF v_count = 0 THEN
            RAISE user_not_found;  -- Raise the custom exception if no user found
        END IF;

        -- Delete related address records
        DELETE FROM address WHERE user_user_id = p_user_id;
        
        -- Delete related ID detail records
        DELETE FROM id_detail WHERE user_user_id = p_user_id;
        
        -- Finally, delete the user record
        DELETE FROM users WHERE user_id = p_user_id;

        -- Output message for successful deletion
        dbms_output.put_line('User and related data successfully deleted.');

    EXCEPTION
        WHEN user_not_found THEN
            dbms_output.put_line('No user found with the specified user_id.');  -- Custom message for user not found
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception during deletion: ' || SQLERRM);
            ROLLBACK;  -- Rollback in case of other exceptions
            RAISE;     -- Optionally re-raise the exception to be handled by the caller
    END delete_all;
END application_user_delete_pkg;
/



BEGIN
    application_user_delete_pkg.delete_all(p_user_id => 4);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;



