CREATE OR REPLACE PACKAGE application_user_subs_pkg IS
    -- Existing insert procedure...
    
    PROCEDURE update_user_subs(
        p_user_subs_id          IN user_subs.user_subs_id%TYPE,
        p_subs_start_date       IN user_subs.subs_start_date%TYPE DEFAULT NULL,
        p_subs_end_date         IN user_subs.subs_end_date%TYPE DEFAULT NULL,
        p_alloted_time          IN user_subs.alloted_time%TYPE DEFAULT NULL,
        p_remaining_time        IN user_subs.remaining_time%TYPE DEFAULT NULL,
        p_user_subs_status      IN user_subs.user_subs_status%TYPE DEFAULT NULL,
        p_subs_plan_subsplan_id IN user_subs.subs_plan_subsplan_id%TYPE DEFAULT NULL
    );
END application_user_subs_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_user_subs_pkg IS
    -- Existing insert procedure implementation...

    PROCEDURE update_user_subs(
        p_user_subs_id          IN user_subs.user_subs_id%TYPE,
        p_subs_start_date       IN user_subs.subs_start_date%TYPE DEFAULT NULL,
        p_subs_end_date         IN user_subs.subs_end_date%TYPE DEFAULT NULL,
        p_alloted_time          IN user_subs.alloted_time%TYPE DEFAULT NULL,
        p_remaining_time        IN user_subs.remaining_time%TYPE DEFAULT NULL,
        p_user_subs_status      IN user_subs.user_subs_status%TYPE DEFAULT NULL,
        p_subs_plan_subsplan_id IN user_subs.subs_plan_subsplan_id%TYPE DEFAULT NULL
    ) IS
    BEGIN
        UPDATE user_subs
        SET subs_start_date       = COALESCE(p_subs_start_date, subs_start_date),
            subs_end_date         = COALESCE(p_subs_end_date, subs_end_date),
            alloted_time          = COALESCE(p_alloted_time, alloted_time),
            remaining_time        = COALESCE(p_remaining_time, remaining_time),
            user_subs_status      = COALESCE(p_user_subs_status, user_subs_status),
            subs_plan_subsplan_id = COALESCE(p_subs_plan_subsplan_id, subs_plan_subsplan_id)
        WHERE user_subs_id = p_user_subs_id;
    END update_user_subs;
END application_user_subs_pkg;
/


BEGIN
    -- Example: Updating the subscription status and remaining time of a specific user subscription
    application_user_subs_pkg.update_user_subs(
        p_user_subs_id          => 1,
        p_remaining_time        => 80,
        p_user_subs_status      => 'InActive'
    );

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;

