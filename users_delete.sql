
CREATE OR REPLACE PACKAGE application_user_delete_pkg IS
    PROCEDURE delete_all(p_user_id IN users.user_id%TYPE);
END application_user_delete_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_user_delete_pkg IS
    PROCEDURE delete_all(p_user_id IN users.user_id%TYPE) IS
    BEGIN
        -- Delete related address records
        DELETE FROM address WHERE user_user_id = p_user_id;
        
        -- Delete related ID detail records
        DELETE FROM id_detail WHERE user_user_id = p_user_id;
        
        -- Finally, delete the user record
        DELETE FROM users WHERE user_id = p_user_id;
        
        -- Depending on your application's requirements, you might want to add additional deletes for other related tables
        
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception: ' || SQLERRM);
    END delete_all;
END application_user_delete_pkg;
/


BEGIN
    application_user_delete_pkg.delete_all(p_user_id => 1);
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;



