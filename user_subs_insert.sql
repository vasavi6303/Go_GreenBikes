

CREATE OR REPLACE PACKAGE application_user_subs_pkg IS
    PROCEDURE insert_user_subs(
        p_subs_start_date      IN user_subs.subs_start_date%TYPE,
        p_subs_end_date        IN user_subs.subs_end_date%TYPE,
        p_alloted_time         IN user_subs.alloted_time%TYPE,
        p_remaining_time       IN user_subs.remaining_time%TYPE,
        p_user_subs_status     IN user_subs.user_subs_status%TYPE,
        p_subs_plan_subsplan_id IN user_subs.subs_plan_subsplan_id%TYPE,
        p_user_user_id         IN user_subs.user_user_id%TYPE
    );
END application_user_subs_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_user_subs_pkg IS
    PROCEDURE insert_user_subs(
        p_subs_start_date      IN user_subs.subs_start_date%TYPE,
        p_subs_end_date        IN user_subs.subs_end_date%TYPE,
        p_alloted_time         IN user_subs.alloted_time%TYPE,
        p_remaining_time       IN user_subs.remaining_time%TYPE,
        p_user_subs_status     IN user_subs.user_subs_status%TYPE,
        p_subs_plan_subsplan_id IN user_subs.subs_plan_subsplan_id%TYPE,
        p_user_user_id         IN user_subs.user_user_id%TYPE
    ) IS
        e_foreign_key_violation EXCEPTION;
        PRAGMA EXCEPTION_INIT(e_foreign_key_violation, -2291);
    BEGIN
        INSERT INTO user_subs (
            subs_start_date, 
            subs_end_date, 
            alloted_time, 
            remaining_time, 
            user_subs_status, 
            subs_plan_subsplan_id, 
            user_user_id
        ) VALUES (
            p_subs_start_date,
            p_subs_end_date,
            p_alloted_time,
            p_remaining_time,
            p_user_subs_status,
            p_subs_plan_subsplan_id,
            p_user_user_id
        );
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Duplicate entry detected for user subscription.');
        WHEN VALUE_ERROR THEN
            dbms_output.put_line('Invalid value entered.');
        WHEN e_foreign_key_violation THEN
            dbms_output.put_line('Foreign key constraint violation.');
        WHEN OTHERS THEN
            dbms_output.put_line('General error in insert_user_subs: ' || SQLERRM);
    END insert_user_subs;
END application_user_subs_pkg;
/



BEGIN
    application_user_subs_pkg.insert_user_subs(
        TO_DATE('2024-03-20', 'YYYY-MM-DD'), 
        TO_DATE('2024-03-20', 'YYYY-MM-DD') + 100, 
        100, 
        100, 
        'Active', 
        1, 
        1
    );
    
    application_user_subs_pkg.insert_user_subs(
        TO_DATE('2024-03-21', 'YYYY-MM-DD'), 
        TO_DATE('2024-03-21', 'YYYY-MM-DD') + 250, 
        250, 
        250, 
        'Active', 
        2, 
        2
    );

    application_user_subs_pkg.insert_user_subs(
        TO_DATE('2024-03-22', 'YYYY-MM-DD'), 
        TO_DATE('2024-03-22', 'YYYY-MM-DD') + 370, 
        370, 
        370, 
        'Active', 
        3, 
        3
    );

    application_user_subs_pkg.insert_user_subs(
        TO_DATE('2024-03-23', 'YYYY-MM-DD'), 
        TO_DATE('2024-03-23', 'YYYY-MM-DD') + 490, 
        490, 
        490, 
        'Active', 
        4, 
        4
    );

    application_user_subs_pkg.insert_user_subs(
        TO_DATE('2024-03-24', 'YYYY-MM-DD'), 
        TO_DATE('2024-03-24', 'YYYY-MM-DD') + 600, 
        600, 
        600, 
        'Active', 
        5, 
        5
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;

