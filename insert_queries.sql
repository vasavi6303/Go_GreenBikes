BEGIN
INSERT INTO users (user_name, first_name, last_name, email_id, password, phone_number, date_of_birth, gender, registration_date, user_status, role)
VALUES ('user1', 'John', 'Doe', 'john.doe@example.com', 'password123', '555-0100', TO_DATE('1985-01-01', 'YYYY-MM-DD'), 'Male', TO_DATE('2024-03-20', 'YYYY-MM-DD'), 'A', 'Customer');

INSERT INTO users (user_name, first_name, last_name, email_id, password, phone_number, date_of_birth, gender, registration_date, user_status, role)
VALUES ('user2', 'Jane', 'Smith', 'jane.smith@example.com', 'password456', '555-0101', TO_DATE('1990-02-02', 'YYYY-MM-DD'), 'Female', TO_DATE('2024-03-21', 'YYYY-MM-DD'), 'A', 'Customer');

INSERT INTO users (user_name, first_name, last_name, email_id, password, phone_number, date_of_birth, gender, registration_date, user_status, role)
VALUES ('user3', 'Emily', 'Jones', 'emily.jones@example.com', 'password789', '555-0102', TO_DATE('1995-03-03', 'YYYY-MM-DD'), 'Female', TO_DATE('2024-03-22', 'YYYY-MM-DD'), 'A', 'Customer');

INSERT INTO users (user_name, first_name, last_name, email_id, password, phone_number, date_of_birth, gender, registration_date, user_status, role)
VALUES ('user4', 'Michael', 'Brown', 'michael.brown@example.com', 'password101', '555-0103', TO_DATE('1988-04-04', 'YYYY-MM-DD'), 'Male', TO_DATE('2024-03-23', 'YYYY-MM-DD'), 'A', 'Customer');

INSERT INTO users (user_name, first_name, last_name, email_id, password, phone_number, date_of_birth, gender, registration_date, user_status, role)
VALUES ('user5', 'Linda', 'Taylor', 'linda.taylor@example.com', 'password202', '555-0104', TO_DATE('1992-05-05', 'YYYY-MM-DD'), 'Female', TO_DATE('2024-03-24', 'YYYY-MM-DD'), 'A', 'Customer');

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/


select * from users;

BEGIN
INSERT INTO address (street_address_1, street_address_2, city, state, country, zipcode, latitude, longitude, user_user_id)
VALUES ('100 Beacon St', 'Apt 1', 'Boston', 'MA', 'USA', 02108, 42.3557, -71.0723, 1);

INSERT INTO address (street_address_1, street_address_2, city, state, country, zipcode, latitude, longitude, user_user_id)
VALUES ('200 Clarendon St', 'Floor 25', 'Boston', 'MA', 'USA', 02116, 42.3494, -71.0759, 2);

INSERT INTO address (street_address_1, street_address_2, city, state, country, zipcode, latitude, longitude, user_user_id)
VALUES ('150 Dorchester Ave', 'Suite 5', 'Boston', 'MA', 'USA', 02127, 42.3412, -71.0567, 3);

INSERT INTO address (street_address_1, street_address_2, city, state, country, zipcode, latitude, longitude, user_user_id)
VALUES ('101 Seaport Blvd', 'Apt 15', 'Boston', 'MA', 'USA', 02210, 42.3495, -71.0435, 4);

INSERT INTO address (street_address_1, street_address_2, city, state, country, zipcode, latitude, longitude, user_user_id)
VALUES ('5 Park Plaza', 'Unit B', 'Boston', 'MA', 'USA', 02116, 42.3515, -71.0702, 5);

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from address;



BEGIN
INSERT INTO subs_plan (subsplan_id, subscription_type, price, duration_time, description)
VALUES (1, 'Basic', 10, 100, '100 minutes');

INSERT INTO subs_plan (subsplan_id, subscription_type, price, duration_time, description)
VALUES (2, 'Standard', 20, 250, '250 minutes');

INSERT INTO subs_plan (subsplan_id, subscription_type, price, duration_time, description)
VALUES (3, 'Premium', 30, 370, '370 minutes');

INSERT INTO subs_plan (subsplan_id, subscription_type, price, duration_time, description)
VALUES (4, 'Gold', 40, 490, '490 minutes');

INSERT INTO subs_plan (subsplan_id, subscription_type, price, duration_time, description)
VALUES (5, 'Platinum', 50, 600, '600 minutes');

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

---user_subs
BEGIN
INSERT INTO user_subs (user_subs_id, subs_start_date, subs_end_date, alloted_time, remaining_time, user_subs_status, subs_plan_subsplan_id, user_user_id)
VALUES (1, TO_DATE('2024-03-20', 'YYYY-MM-DD'), TO_DATE('2024-03-20', 'YYYY-MM-DD') + 100, 100, 100, 'Active', 1, 1);

INSERT INTO user_subs (user_subs_id, subs_start_date, subs_end_date, alloted_time, remaining_time, user_subs_status, subs_plan_subsplan_id, user_user_id)
VALUES (2, TO_DATE('2024-03-21', 'YYYY-MM-DD'), TO_DATE('2024-03-21', 'YYYY-MM-DD') + 250, 250, 250, 'Active', 2, 2);

INSERT INTO user_subs (user_subs_id, subs_start_date, subs_end_date, alloted_time, remaining_time, user_subs_status, subs_plan_subsplan_id, user_user_id)
VALUES (3, TO_DATE('2024-03-22', 'YYYY-MM-DD'), TO_DATE('2024-03-22', 'YYYY-MM-DD') + 370, 370, 370, 'Active', 3, 3);

INSERT INTO user_subs (user_subs_id, subs_start_date, subs_end_date, alloted_time, remaining_time, user_subs_status, subs_plan_subsplan_id, user_user_id)
VALUES (4, TO_DATE('2024-03-23', 'YYYY-MM-DD'), TO_DATE('2024-03-23', 'YYYY-MM-DD') + 490, 490, 490, 'Active', 4, 4);

INSERT INTO user_subs (user_subs_id, subs_start_date, subs_end_date, alloted_time, remaining_time, user_subs_status, subs_plan_subsplan_id, user_user_id)
VALUES (5, TO_DATE('2024-03-24', 'YYYY-MM-DD'), TO_DATE('2024-03-24', 'YYYY-MM-DD') + 600, 600, 600, 'Active', 5, 5);

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from user_subs;


BEGIN
INSERT INTO id_detail (id_verf_id, id_type, id_path, user_user_id)
VALUES (1, 'Driving License', '/path/to/driving/license/user1.jpg', 1);

INSERT INTO id_detail (id_verf_id, id_type, id_path, user_user_id)
VALUES (2, 'SSN', '/path/to/ssn/user2.jpg', 2);

INSERT INTO id_detail (id_verf_id, id_type, id_path, user_user_id)
VALUES (3, 'Driving License', '/path/to/driving/license/user3.jpg', 3);

INSERT INTO id_detail (id_verf_id, id_type, id_path, user_user_id)
VALUES (4, 'SSN', '/path/to/ssn/user4.jpg', 4);

INSERT INTO id_detail (id_verf_id, id_type, id_path, user_user_id)
VALUES (5, 'Driving License', '/path/to/driving/license/user5.jpg', 5);

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/


select * from id_detail;


--instert statements for address table

BEGIN
INSERT INTO location (location_id, location_name, loc_status, no_of_slots, address_address_id)
VALUES (1, 'Beacon Hill', 'Y', 15, 1);

INSERT INTO location (location_id, location_name, loc_status, no_of_slots, address_address_id)
VALUES (2, 'Back Bay', 'Y', 20, 2);

INSERT INTO location (location_id, location_name, loc_status, no_of_slots, address_address_id)
VALUES (3, 'South Boston', 'N', 10, 3);

INSERT INTO location (location_id, location_name, loc_status, no_of_slots, address_address_id)
VALUES (4, 'Seaport District', 'Y', 25, 4);

INSERT INTO location (location_id, location_name, loc_status, no_of_slots, address_address_id)
VALUES (5, 'Boston Common', 'N', 30, 5);

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from address;

select * from location;



BEGIN
INSERT INTO bike_status (status_id, status_name)
VALUES (1, 'Available');

INSERT INTO bike_status (status_id, status_name)
VALUES (2, 'In Transit');

INSERT INTO bike_status (status_id, status_name)
VALUES (3, 'Lost/Damage');

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from bike_status;

BEGIN
INSERT INTO bike (bike_id, bike_status_status_id, location_location_id)
VALUES (1, 1, 1); -- Bike 1 is Available at Beacon Hill

INSERT INTO bike (bike_id, bike_status_status_id, location_location_id)
VALUES (2, 2, 2); -- Bike 2 is In Transit at Back Bay

INSERT INTO bike (bike_id, bike_status_status_id, location_location_id)
VALUES (3, 3, 3); -- Bike 3 is Lost/Damage at South Boston

INSERT INTO bike (bike_id, bike_status_status_id, location_location_id)
VALUES (4, 1, 4); -- Bike 4 is Available at Seaport District

INSERT INTO bike (bike_id, bike_status_status_id, location_location_id)
VALUES (5, 1, 5); -- Bike 5 is Available at Boston Common

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from bike;


BEGIN
INSERT INTO ride (ride_id, start_time, end_time, duration_time, start_location_id, end_location_id, user_user_id, bike_bike_id)
VALUES (1, TO_TIMESTAMP_TZ('2024-03-20 08:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'), TO_TIMESTAMP_TZ('2024-03-20 09:30:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'),
        (EXTRACT(HOUR FROM (TO_TIMESTAMP_TZ('2024-03-20 09:30:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-20 08:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))) * 60) +
        EXTRACT(MINUTE FROM (TO_TIMESTAMP_TZ('2024-03-20 09:30:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-20 08:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))), 1, 2, 1, 1);

INSERT INTO ride (ride_id, start_time, end_time, duration_time, start_location_id, end_location_id, user_user_id, bike_bike_id)
VALUES (2, TO_TIMESTAMP_TZ('2024-03-21 10:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'), TO_TIMESTAMP_TZ('2024-03-21 11:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'),
        (EXTRACT(HOUR FROM (TO_TIMESTAMP_TZ('2024-03-21 11:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-21 10:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))) * 60) +
        EXTRACT(MINUTE FROM (TO_TIMESTAMP_TZ('2024-03-21 11:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-21 10:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))), 2, 3, 2, 2);

INSERT INTO ride (ride_id, start_time, end_time, duration_time, start_location_id, end_location_id, user_user_id, bike_bike_id)
VALUES (3, TO_TIMESTAMP_TZ('2024-03-22 14:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'), TO_TIMESTAMP_TZ('2024-03-22 15:45:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'),
        (EXTRACT(HOUR FROM (TO_TIMESTAMP_TZ('2024-03-22 15:45:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-22 14:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))) * 60) +
        EXTRACT(MINUTE FROM (TO_TIMESTAMP_TZ('2024-03-22 15:45:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-22 14:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))), 3, 4, 3, 3);

INSERT INTO ride (ride_id, start_time, end_time, duration_time, start_location_id, end_location_id, user_user_id, bike_bike_id)
VALUES (4, TO_TIMESTAMP_TZ('2024-03-23 09:15:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'), TO_TIMESTAMP_TZ('2024-03-23 10:15:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'),
        (EXTRACT(HOUR FROM (TO_TIMESTAMP_TZ('2024-03-23 10:15:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-23 09:15:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))) * 60) +
        EXTRACT(MINUTE FROM (TO_TIMESTAMP_TZ('2024-03-23 10:15:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-23 09:15:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))), 4, 5, 4, 4);

INSERT INTO ride (ride_id, start_time, end_time, duration_time, start_location_id, end_location_id, user_user_id, bike_bike_id)
VALUES (5, TO_TIMESTAMP_TZ('2024-03-24 16:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'), TO_TIMESTAMP_TZ('2024-03-24 17:30:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'),
        (EXTRACT(HOUR FROM (TO_TIMESTAMP_TZ('2024-03-24 17:30:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-24 16:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))) * 60) +
        EXTRACT(MINUTE FROM (TO_TIMESTAMP_TZ('2024-03-24 17:30:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM') - TO_TIMESTAMP_TZ('2024-03-24 16:00:00-05:00', 'YYYY-MM-DD HH24:MI:SSTZH:TZM'))), 5, 1, 5, 5);

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/


select * from ride;

BEGIN
INSERT INTO miscellaneous_cost (misc_cost_id, cost_type, amount, ride_ride_id, status)
VALUES (1, 'Minutes Exceeded', 60, 1, 'Not Paid');

INSERT INTO miscellaneous_cost (misc_cost_id, cost_type, amount, ride_ride_id, status)
VALUES (2, 'Damage', 100, 2, 'Paid');

INSERT INTO miscellaneous_cost (misc_cost_id, cost_type, amount, ride_ride_id, status)
VALUES (3, 'Lost', 500, 3, 'Not Paid');

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from miscellaneous_cost;


BEGIN
INSERT INTO trans_type (trans_type_id, transaction_name)
VALUES (1, 'Subscription Payment');

INSERT INTO trans_type (trans_type_id, transaction_name)
VALUES (2, 'Miscellaneous Cost');

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from trans_type;

BEGIN
INSERT INTO trans (trans_id, description, transaction_time, amount, transaction_status, user_user_id, trans_type_trans_type_id)
VALUES (1, 'Subscription Payment', SYSTIMESTAMP, 20, 'Y', 1, 1);

INSERT INTO trans (trans_id, description, transaction_time, amount, transaction_status, user_user_id, trans_type_trans_type_id)
VALUES (2, 'Miscellaneous Cost', SYSTIMESTAMP, 100, 'Y', 2, 2); -- Reflecting the paid status of the damage cost for User ID 2

INSERT INTO trans (trans_id, description, transaction_time, amount, transaction_status, user_user_id, trans_type_trans_type_id)
VALUES (3, 'Subscription Payment', SYSTIMESTAMP, 20, 'N', 3, 1);

INSERT INTO trans (trans_id, description, transaction_time, amount, transaction_status, user_user_id, trans_type_trans_type_id)
VALUES (4, 'Miscellaneous Cost', SYSTIMESTAMP, 500, 'N', 4, 2); -- Assuming an unpaid miscellaneous cost for demonstration

INSERT INTO trans (trans_id, description, transaction_time, amount, transaction_status, user_user_id, trans_type_trans_type_id)
VALUES (5, 'Subscription Payment', SYSTIMESTAMP, 50, 'Y', 5, 1);

COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;
/

select * from trans;

