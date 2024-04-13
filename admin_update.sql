CREATE OR REPLACE PACKAGE application_user_update_pkg IS
    -- Existing procedures...

    PROCEDURE update_subs_plan(p_subsplan_id IN subs_plan.subsplan_id%TYPE, 
                               p_subscription_type IN subs_plan.subscription_type%TYPE DEFAULT NULL, 
                               p_price IN subs_plan.price%TYPE DEFAULT NULL, 
                               p_duration_time IN subs_plan.duration_time%TYPE DEFAULT NULL, 
                               p_description IN subs_plan.description%TYPE DEFAULT NULL);

    PROCEDURE update_location(p_location_id IN location.location_id%TYPE, 
                              p_location_name IN location.location_name%TYPE DEFAULT NULL,  
                              p_no_of_slots IN location.no_of_slots%TYPE DEFAULT NULL);

    PROCEDURE update_bike_status(p_status_id IN bike_status.status_id%TYPE, 
                                 p_status_name IN bike_status.status_name%TYPE DEFAULT NULL);

    PROCEDURE update_trans_type(p_trans_type_id IN trans_type.trans_type_id%TYPE, 
                                p_transaction_name IN trans_type.transaction_name%TYPE DEFAULT NULL);
END application_user_update_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_user_update_pkg IS
    -- Existing procedures...

    PROCEDURE update_subs_plan(p_subsplan_id IN subs_plan.subsplan_id%TYPE, 
                               p_subscription_type IN subs_plan.subscription_type%TYPE DEFAULT NULL, 
                               p_price IN subs_plan.price%TYPE DEFAULT NULL, 
                               p_duration_time IN subs_plan.duration_time%TYPE DEFAULT NULL, 
                               p_description IN subs_plan.description%TYPE DEFAULT NULL) IS
        invalid_duration EXCEPTION;
        invalid_price EXCEPTION;
    BEGIN
    -- Validate duration
        IF p_duration_time <= 0 THEN
            RAISE invalid_duration;
        END IF;

        -- Validate price
        IF p_price < 0 THEN
            RAISE invalid_price;
        END IF;
        
        UPDATE subs_plan
        SET subscription_type = COALESCE(p_subscription_type, subscription_type),
            price = COALESCE(p_price, price),
            duration_time = COALESCE(p_duration_time, duration_time),
            description = COALESCE(p_description, description)
        WHERE subsplan_id = p_subsplan_id;
        EXCEPTION
        WHEN invalid_duration THEN
            dbms_output.put_line('Error: Duration must be valid and non-negative');
        WHEN invalid_price THEN
            dbms_output.put_line('Error: Price should be valid and non negative');
        WHEN OTHERS THEN
            dbms_output.put_line('Error during update: ' || SQLERRM);
            ROLLBACK; -- Ensure transaction is rolled back on error
    END update_subs_plan;

    PROCEDURE update_location(p_location_id IN location.location_id%TYPE, 
                              p_location_name IN location.location_name%TYPE DEFAULT NULL,  
                              p_no_of_slots IN location.no_of_slots%TYPE DEFAULT NULL) IS
    BEGIN
        UPDATE location
        SET location_name = COALESCE(p_location_name, location_name),
            no_of_slots = COALESCE(p_no_of_slots, no_of_slots)
        WHERE location_id = p_location_id;
    END update_location;

    PROCEDURE update_bike_status(p_status_id IN bike_status.status_id%TYPE, 
                                 p_status_name IN bike_status.status_name%TYPE DEFAULT NULL) IS
    BEGIN
        UPDATE bike_status
        SET status_name = COALESCE(p_status_name, status_name)
        WHERE status_id = p_status_id;
    END update_bike_status;

    PROCEDURE update_trans_type(p_trans_type_id IN trans_type.trans_type_id%TYPE, 
                                p_transaction_name IN trans_type.transaction_name%TYPE DEFAULT NULL) IS
    BEGIN
        UPDATE trans_type
        SET transaction_name = COALESCE(p_transaction_name, transaction_name)
        WHERE trans_type_id = p_trans_type_id;
    

    -- Additional procedures as needed...
    
    END update_trans_type;
END application_user_update_pkg;
/


BEGIN
    -- Update records in subs_plan
    application_user_update_pkg.update_subs_plan(p_subsplan_id => 1, 
                                                 p_subscription_type => 'Basic Plus', 
                                                 p_price => -12, 
                                                 p_duration_time => 110, 
                                                 p_description => '110 minutes of service');
    application_user_update_pkg.update_subs_plan(p_subsplan_id => 2, 
                                                 p_subscription_type => 'Standard Plus', 
                                                 p_price => 25, 
                                                 p_duration_time => -260, 
                                                 p_description => '260 minutes of service');
    application_user_update_pkg.update_subs_plan(p_subsplan_id => 3, 
                                                 p_subscription_type => 'Premium Plus', 
                                                 p_price => 35, 
                                                 p_duration_time => 380, 
                                                 p_description => '380 minutes of service');
    application_user_update_pkg.update_subs_plan(p_subsplan_id => 4, 
                                                 p_subscription_type => 'Gold Plus', 
                                                 p_price => 45, 
                                                 p_duration_time => 500, 
                                                 p_description => '500 minutes of service');
    application_user_update_pkg.update_subs_plan(p_subsplan_id => 5, 
                                                 p_subscription_type => 'Platinum Plus', 
                                                 p_price => 55, 
                                                 p_duration_time => 620, 
                                                 p_description => '620 minutes of service');

    -- Update records in location
    application_user_update_pkg.update_location(p_location_id => 1, 
                                                p_location_name => 'Beacon Hill', 
                                                p_no_of_slots => 18);
    application_user_update_pkg.update_location(p_location_id => 2, 
                                                p_location_name => 'Back Bay',  
                                                p_no_of_slots => 22);

    -- Update records in bike_status
    application_user_update_pkg.update_bike_status(p_status_id => 1, 
                                                   p_status_name => 'Available');
    application_user_update_pkg.update_bike_status(p_status_id => 2, 
                                                   p_status_name => 'In Use');

    -- Update records in trans_type
    application_user_update_pkg.update_trans_type(p_trans_type_id => 1, 
                                                  p_transaction_name => 'Subscription Payment');
    application_user_update_pkg.update_trans_type(p_trans_type_id => 2, 
                                                  p_transaction_name => 'Miscellaneous Cost');

    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;