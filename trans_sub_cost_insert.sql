
set serveroutput on
CREATE OR REPLACE PACKAGE application_trans_sub_pkg IS
    PROCEDURE insert_trans(
      
        p_transaction_time         TIMESTAMP WITH TIME ZONE,
        p_amount                   NUMBER,
     
        p_user_user_id             user_subs.user_user_id%TYPE,
        p_subs_plan_id             user_subs.subs_plan_subsplan_id%TYPE
    );
END application_trans_sub_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_trans_sub_pkg IS
    PROCEDURE insert_trans(
        p_transaction_time         TIMESTAMP WITH TIME ZONE,
        p_amount                   NUMBER,
        p_user_user_id             user_subs.user_user_id%TYPE,
        p_subs_plan_id             user_subs.subs_plan_subsplan_id%TYPE
    ) IS
        v_plan_cost NUMBER;
        v_duration_time NUMBER;
        v_start_date DATE := SYSDATE;
        v_end_date DATE;
        v_user_exists NUMBER;
        v_all_completed VARCHAR2(1) := 'Y'; -- Assume 'Y' unless found otherwise
        v_cost_count NUMBER;
    BEGIN
        dbms_output.put_line('Starting transaction insert procedure...');
        SELECT COUNT(*) INTO v_user_exists FROM users WHERE user_id = p_user_user_id;
        dbms_output.put_line('User existence check: ' || v_user_exists);
        
        IF v_user_exists = 0 THEN
            dbms_output.put_line('User does not exist.');
            RETURN;
        END IF;

        SELECT price, duration_time INTO v_plan_cost, v_duration_time
        FROM subs_plan
        WHERE subsplan_id = p_subs_plan_id;
        
        dbms_output.put_line('Plan cost check: ' || p_amount || ' vs ' || v_plan_cost);
        IF p_amount != v_plan_cost THEN
            dbms_output.put_line('Check the plan amount: does not match the subscription plan cost.');
        ELSE
            SELECT COUNT(*) INTO v_cost_count
            FROM miscellaneous_cost mc
            JOIN ride r ON mc.ride_ride_id = r.ride_id
            WHERE r.user_user_id = p_user_user_id AND mc.status != 'Completed';
            dbms_output.put_line('Pending cost count: ' || v_cost_count);

            IF v_cost_count > 0 THEN
                v_all_completed := 'N';
            END IF;

            dbms_output.put_line('All costs completed: ' || v_all_completed);
            v_end_date := v_start_date + 90;
                        -- Determine if the user subscription needs to be updated or inserted
            SELECT COUNT(*) INTO v_user_exists FROM user_subs WHERE user_user_id = p_user_user_id;

            IF v_all_completed = 'Y' THEN
                IF v_user_exists > 0 THEN
                    dbms_output.put_line('Updating user_subs record.');
                    UPDATE user_subs
                    SET alloted_time = alloted_time + v_duration_time,
                        remaining_time = remaining_time + v_duration_time,
                        subs_plan_subsplan_id = p_subs_plan_id,
                        subs_start_date = v_start_date,
                        subs_end_date = v_end_date,
                        user_subs_status = 'Active'
                    WHERE user_user_id = p_user_user_id;
                ELSE
                    dbms_output.put_line('Inserting new user_subs record.');
                    INSERT INTO user_subs (
                        user_user_id,
                        alloted_time,
                        remaining_time,
                        user_subs_status,
                        subs_plan_subsplan_id,
                        subs_start_date,
                        subs_end_date
                    ) VALUES (
                        p_user_user_id,
                        v_duration_time,
                        v_duration_time,
                        'Active',
                        p_subs_plan_id,
                        v_start_date,
                        v_end_date
                    );
                END IF;
            ELSE
                dbms_output.put_line('Cannot activate subscription: Pending miscellaneous costs.');
            END IF;

        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('No data found for provided IDs.');
        WHEN OTHERS THEN
            dbms_output.put_line('Transaction failed: ' || SQLERRM);
    END insert_trans;
END application_trans_sub_pkg;
/



BEGIN
    application_trans_sub_pkg.insert_trans(
       
        p_transaction_time         => SYSTIMESTAMP,
        p_amount                   => 10,
        p_user_user_id             => 1,
        p_subs_plan_id             => 1
    );
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error during transaction insertion: ' || SQLERRM);
END;
/


