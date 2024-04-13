CREATE OR REPLACE PACKAGE application_trans_pkg IS
    PROCEDURE insert_trans(
      
        p_transaction_time         TIMESTAMP WITH TIME ZONE,
        p_amount                   NUMBER,
     
        p_user_user_id             user_subs.user_user_id%TYPE,
        p_subs_plan_id             user_subs.subs_plan_subsplan_id%TYPE
    );
END application_trans_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_trans_pkg IS
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
        v_alloted_time NUMBER;
        v_remaining_time NUMBER;
        v_user_count NUMBER;
    BEGIN
        -- Check if the user exists in the users table
        SELECT COUNT(*) INTO v_user_count FROM users WHERE user_id = p_user_user_id;
        IF v_user_count = 0 THEN
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
            -- Calculate end date based on the subscription plan ID
            CASE p_subs_plan_id
                WHEN 1 THEN v_end_date := v_start_date + 100;
                WHEN 2 THEN v_end_date := v_start_date + 250;
                WHEN 3 THEN v_end_date := v_start_date + 370;
                WHEN 4 THEN v_end_date := v_start_date + 490;
                WHEN 5 THEN v_end_date := v_start_date + 600;
                ELSE RAISE_APPLICATION_ERROR(-20001, 'Invalid subscription plan ID');
            END CASE;

            -- Check if the user already has a subscription record
            SELECT COUNT(*) INTO v_user_exists
            FROM user_subs
            WHERE user_user_id = p_user_user_id;

            IF v_user_exists > 0 THEN
                -- Update existing user_subs record
                SELECT alloted_time, remaining_time INTO v_alloted_time, v_remaining_time
                FROM user_subs
                WHERE user_user_id = p_user_user_id;

                UPDATE user_subs
                SET alloted_time = v_alloted_time + v_duration_time,
                    remaining_time = v_remaining_time + v_duration_time,
                    subs_plan_subsplan_id = p_subs_plan_id,
                    subs_start_date = v_start_date,
                    subs_end_date = v_end_date
                WHERE user_user_id = p_user_user_id;
            ELSE
                -- Insert new user_subs record
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
            'C',
            p_user_user_id,
            1  -- Assuming the transaction type ID for subscriptions is 1
        );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('Subscription plan does not exist.');
           
        WHEN OTHERS THEN
            dbms_output.put_line('Transaction failed: An unexpected error occurred.');
           
    END insert_trans;
END application_trans_pkg;
/



BEGIN
    application_trans_pkg.insert_trans(
       
        p_transaction_time         => SYSTIMESTAMP,
        p_amount                   => 10,
        p_user_user_id             => 9,
        p_subs_plan_id             => 1
    );
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error during transaction insertion: ' || SQLERRM);
END;
/



