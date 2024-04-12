CREATE OR REPLACE PACKAGE application_user_subs_pkg IS
    -- Existing insert and update procedures...
    
    PROCEDURE delete_user_subs(p_user_subs_id IN user_subs.user_subs_id%TYPE);
END application_user_subs_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_user_subs_pkg IS
    -- Existing insert and update procedure implementations...

    PROCEDURE delete_user_subs(p_user_subs_id IN user_subs.user_subs_id%TYPE) IS
    BEGIN
        DELETE FROM user_subs WHERE user_subs_id = p_user_subs_id;
    END delete_user_subs;
END application_user_subs_pkg;
/


BEGIN
    -- Delete a specific user subscription record by user_subs_id
    application_user_subs_pkg.delete_user_subs(p_user_subs_id => 1);
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
