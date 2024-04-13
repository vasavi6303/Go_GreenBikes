
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
        v_all_completed VARCHAR2(1) := 'Y'; -- Changed from BOOLEAN to VARCHAR2
    BEGIN
        -- Check if the user exists in the users table
        SELECT COUNT(*) INTO v_user_exists FROM users WHERE user_id = p_user_user_id;
        IF v_user_exists = 0 THEN
            dbms_output.put_line('User does not exist.');
            RETURN;
        END IF;

        -- Retrieve the cost and duration from the subscription plan table
        SELECT price, duration_time INTO v_plan_cost, v_duration_time
        FROM subs_plan
        WHERE subsplan_id = p_subs_plan_id;

        -- Check if the amount matches the plan cost
        IF p_amount != v_plan_cost THEN
            dbms_output.put_line('Check the plan amount: does not match the subscription plan cost.');
        ELSE
            -- Check for pending miscellaneous costs
            FOR rec IN (SELECT mc.status
                        FROM miscellaneous_cost mc
                        JOIN ride r ON mc.ride_ride_id = r.ride_id
                        WHERE r.user_user_id = p_user_user_id) LOOP
                IF rec.status != 'Completed' THEN
                    v_all_completed := 'N';
                    EXIT;
                END IF;
            END LOOP;

            -- Calculate end date, which is defaulted to 90 days from start date
            v_end_date := v_start_date + 90;

            IF v_all_completed = 'Y' THEN
                -- Update or insert user_subs record if all costs are completed
                IF v_user_exists > 0 THEN
                    UPDATE user_subs
                    SET alloted_time = alloted_time + v_duration_time,
                        remaining_time = remaining_time + v_duration_time,
                        subs_plan_subsplan_id = p_subs_plan_id,
                        subs_start_date = v_start_date,
                        subs_end_date = v_end_date,
                        user_subs_status = 'Active'
                    WHERE user_user_id = p_user_user_id;
                ELSE
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

            -- Insert the transaction record with either 'C' or 'F'
            INSERT INTO trans (
                description,
                transaction_time,
                amount,
                transaction_status,
                user_user_id,
                trans_type_trans_type_id
            ) VALUES (
                'Sub_Payment',
                p_transaction_time,
                p_amount,
                CASE WHEN v_all_completed = 'Y' THEN 'C' ELSE 'F' END,
                p_user_user_id,
                1  -- Assuming the transaction type ID for subscriptions is 1
            );
        END IF;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Subscription plan does not exist.');
        WHEN OTHERS THEN
            dbms_output.put_line('Transaction failed: An unexpected error occurred.');
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



