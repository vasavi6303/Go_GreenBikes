CREATE OR REPLACE PACKAGE application_user_pkg IS
    -- Existing procedures...
    PROCEDURE insert_subs_plan(p_subscription_type IN subs_plan.subscription_type%TYPE, 
                               p_price IN subs_plan.price%TYPE, 
                               p_duration_time IN subs_plan.duration_time%TYPE, 
                               p_description IN subs_plan.description%TYPE);
                               
    PROCEDURE insert_location(p_location_name IN location.location_name%TYPE, 
                              p_loc_status IN location.loc_status%TYPE, 
                              p_no_of_slots IN location.no_of_slots%TYPE, 
                              p_address_address_id IN location.address_address_id%TYPE);
                              
    PROCEDURE insert_bike_status(p_status_name IN bike_status.status_name%TYPE);
    
    PROCEDURE insert_trans_type(p_transaction_name IN trans_type.transaction_name%TYPE);
END application_user_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_user_pkg IS

    -- Procedure to insert data into subs_plan
    PROCEDURE insert_subs_plan(p_subscription_type IN subs_plan.subscription_type%TYPE, 
                               p_price IN subs_plan.price%TYPE, 
                               p_duration_time IN subs_plan.duration_time%TYPE, 
                               p_description IN subs_plan.description%TYPE) IS
    BEGIN
        INSERT INTO subs_plan (subscription_type, price, duration_time, description)
        VALUES (p_subscription_type, p_price, p_duration_time, p_description);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Duplicate value for subscription plan.');
    END insert_subs_plan;
    
    -- Procedure to insert data into location
    PROCEDURE insert_location(p_location_name IN location.location_name%TYPE, 
                              p_loc_status IN location.loc_status%TYPE, 
                              p_no_of_slots IN location.no_of_slots%TYPE, 
                              p_address_address_id IN location.address_address_id%TYPE) IS
    BEGIN
        INSERT INTO location (location_name, loc_status, no_of_slots, address_address_id)
        VALUES (p_location_name, p_loc_status, p_no_of_slots, p_address_address_id);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Duplicate value for location.');
        WHEN OTHERS THEN
            dbms_output.put_line('Error inserting location: ' || SQLERRM);
    END insert_location;
    
    -- Procedure to insert data into bike_status
    PROCEDURE insert_bike_status(p_status_name IN bike_status.status_name%TYPE) IS
    BEGIN
        INSERT INTO bike_status (status_name)
        VALUES (p_status_name);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Duplicate status name.');
    END insert_bike_status;
    
    -- Procedure to insert data into trans_type
    PROCEDURE insert_trans_type(p_transaction_name IN trans_type.transaction_name%TYPE) IS
    BEGIN
        INSERT INTO trans_type (transaction_name)
        VALUES (p_transaction_name);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Duplicate transaction type.');
    END insert_trans_type;

END application_user_pkg;
/


BEGIN
    -- Insert data into subs_plan
    application_user_pkg.insert_subs_plan('Basic', 10, 100, '100 minutes');
    application_user_pkg.insert_subs_plan('Standard', 20, 250, '250 minutes');
    application_user_pkg.insert_subs_plan('Premium', 30, 370, '370 minutes');
    application_user_pkg.insert_subs_plan('Gold', 40, 490, '490 minutes');
    application_user_pkg.insert_subs_plan('Platinum', 50, 600, '600 minutes');
    
    -- Assuming address_address_id values are placeholders and already exist.
    -- Insert data into location
    application_user_pkg.insert_location('Beacon Hill', 'Active', 15, 1);
    application_user_pkg.insert_location('Back Bay', 'Active', 20, 2);
    application_user_pkg.insert_location('South Boston', 'Active', 10, 3);
    application_user_pkg.insert_location('Seaport District', 'Active', 25, 4);
    application_user_pkg.insert_location('Boston Common', 'Active', 30, 5);
    
    -- Insert data into bike_status
    application_user_pkg.insert_bike_status('Available');
    application_user_pkg.insert_bike_status('In Transit');
    application_user_pkg.insert_bike_status('Damage');
    application_user_pkg.insert_bike_status('Lost');
    
    -- Insert data into trans_type
    application_user_pkg.insert_trans_type('Subscription Payment');
    application_user_pkg.insert_trans_type('Miscellaneous Cost');
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;

