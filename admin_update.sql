CREATE OR REPLACE PACKAGE application_user_pkg IS
    PROCEDURE insert_subs_plan(p_subscription_type IN subs_plan.subscription_type%TYPE, 
                               p_price IN subs_plan.price%TYPE, 
                               p_duration_time IN subs_plan.duration_time%TYPE, 
                               p_description IN subs_plan.description%TYPE);
                               
    PROCEDURE insert_location(p_location_name IN location.location_name%TYPE, 
                              p_loc_status IN location.loc_status%TYPE, 
                              p_no_of_slots IN location.no_of_slots%TYPE,
                              p_street_address_1 IN location_address.street_address_1%TYPE,
                              p_street_address_2 IN location_address.street_address_2%TYPE,
                              p_city IN location_address.city%TYPE,
                              p_state IN location_address.state%TYPE,
                              p_country IN location_address.country%TYPE,
                              p_zipcode IN location_address.zipcode%TYPE,
                              p_latitude IN location_address.latitude%TYPE,
                              p_longitude IN location_address.longitude%TYPE);
                              
    PROCEDURE insert_bike_status(p_status_name IN bike_status.status_name%TYPE);
    
    PROCEDURE insert_trans_type(p_transaction_name IN trans_type.transaction_name%TYPE);
END application_user_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_user_pkg IS

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
    
    PROCEDURE insert_location(p_location_name IN location.location_name%TYPE, 
                              p_loc_status IN location.loc_status%TYPE, 
                              p_no_of_slots IN location.no_of_slots%TYPE,
                              p_street_address_1 IN location_address.street_address_1%TYPE,
                              p_street_address_2 IN location_address.street_address_2%TYPE,
                              p_city IN location_address.city%TYPE,
                              p_state IN location_address.state%TYPE,
                              p_country IN location_address.country%TYPE,
                              p_zipcode IN location_address.zipcode%TYPE,
                              p_latitude IN location_address.latitude%TYPE,
                              p_longitude IN location_address.longitude%TYPE) IS
        v_location_id NUMBER;
    BEGIN
        -- Insert into location and retrieve location_id
        INSERT INTO location (location_name, loc_status, no_of_slots)
        VALUES (p_location_name, p_loc_status, p_no_of_slots)
        RETURNING location_id INTO v_location_id;

        -- Insert into location_address using the new location_id
        INSERT INTO location_address (location_location_id, street_address_1, street_address_2, city, state, country, zipcode, latitude, longitude)
        VALUES (v_location_id, p_street_address_1, p_street_address_2, p_city, p_state, p_country, p_zipcode, p_latitude, p_longitude);
    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
            dbms_output.put_line('Duplicate value for location or location address.');
        WHEN OTHERS THEN
            dbms_output.put_line('Error inserting location or location address: ' || SQLERRM);
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
    
    -- Other procedures remain unchanged...
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
    application_user_pkg.insert_location('Roxbury', 'Active', 15, '115 Northampton','Roxbury','Boston','MA','USA','02118','42.361145','-71.057083');
    application_user_pkg.insert_location('King Street', 'Active', 20, '14 John Eliot Square','Roxbury','Boston','MA','USA','02119','42.361145','-71.057083');
    application_user_pkg.insert_location('Jamaica Plain', 'Active', 10, '44 Iffley','Jamaica Plain','Boston','MA','USA','02117','42.361145','-71.057083');
    application_user_pkg.insert_location('Northeastern ', 'Active', 25, '213 Culinane','Huntington Ave','Boston','MA','USA','02115','42.361145','-71.057083');
    application_user_pkg.insert_location('Boston Common', 'Active', 30, '200 Washington Street','Northeastern ','Boston','MA','USA','02118','42.361145','-71.057083');
    
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


