CREATE OR REPLACE PACKAGE application_trans_pkg IS
    PROCEDURE insert_trans(
        p_description              VARCHAR2,
        p_transaction_time         TIMESTAMP WITH TIME ZONE,
        p_amount                   NUMBER,
        p_transaction_status       CHAR,
        p_user_user_id             ride.user_user_id%TYPE,
        p_trans_type_trans_type_id trans_type.trans_type_id%TYPE,
        p_misc_cost_id             miscellaneous_cost.misc_cost_id%TYPE
    );
END application_trans_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_trans_pkg IS
    PROCEDURE insert_trans(
        p_description              VARCHAR2,
        p_transaction_time         TIMESTAMP WITH TIME ZONE,
        p_amount                   NUMBER,
        p_transaction_status       CHAR,
        p_user_user_id             ride.user_user_id%TYPE,
        p_trans_type_trans_type_id trans_type.trans_type_id%TYPE,
        p_misc_cost_id             miscellaneous_cost.misc_cost_id%TYPE
    ) IS
        v_cost_amount NUMBER;
        v_cost_status VARCHAR2(30);
        v_ride_user_id ride.user_user_id%TYPE;
    BEGIN
        -- Attempt to retrieve the associated cost and status from the miscellaneous_cost table
        BEGIN
            SELECT amount, status INTO v_cost_amount, v_cost_status
            FROM miscellaneous_cost
            WHERE misc_cost_id = p_misc_cost_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('Transaction failed: No such miscellaneous cost ID.');
                RETURN;
        END;

        -- Check if the miscellaneous cost has already been completed
        IF v_cost_status = 'Completed' THEN
            dbms_output.put_line('Transaction not required: Payment already completed.');
            RETURN;
        END IF;

        -- Retrieve the user ID associated with the miscellaneous cost from the ride table
        SELECT r.user_user_id INTO v_ride_user_id
        FROM ride r
        JOIN miscellaneous_cost mc ON mc.ride_ride_id = r.ride_id
        WHERE mc.misc_cost_id = p_misc_cost_id;

        -- Check if the user ID matches the one associated with the ride
        IF v_ride_user_id != p_user_user_id THEN
            dbms_output.put_line('Transaction failed: User ID does not match with the associated ride.');
            RETURN;
        END IF;

        -- Proceed if the amount matches the miscellaneous cost
        IF p_amount = v_cost_amount THEN
            -- Insert the transaction record
            INSERT INTO trans (
                description,
                transaction_time,
                amount,
                transaction_status,
                user_user_id,
                trans_type_trans_type_id
            ) VALUES (
                p_description,
                p_transaction_time,
                p_amount,
                p_transaction_status,
                p_user_user_id,
                p_trans_type_trans_type_id
            );
            
            -- Update the status of the miscellaneous cost to 'Completed'
            UPDATE miscellaneous_cost
            SET status = 'Completed'
            WHERE misc_cost_id = p_misc_cost_id;
        ELSE
            dbms_output.put_line('Transaction failed: Amount does not match the miscellaneous cost.');
            RETURN;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Transaction failed: An unexpected error occurred.');
    END insert_trans;
END application_trans_pkg;
/


BEGIN
    -- Example call with dummy data (make sure these IDs and values exist and are appropriate)
    application_trans_pkg.insert_trans(
        p_description              => 'Misc cost',
        p_transaction_time         => SYSTIMESTAMP,  -- Current timestamp
        p_amount                   => 200.00,        -- Amount that matches the miscellaneous cost record
        p_transaction_status       => 'C',           -- Assuming 'C' represents 'Completed'
        p_user_user_id             => 5,             -- Example user ID
        p_trans_type_trans_type_id => 2,             -- Example transaction type ID
        p_misc_cost_id             => 7              -- Example miscellaneous cost ID
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error during transaction insertion: ' || SQLERRM);
END;
/

