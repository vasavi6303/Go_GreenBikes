CREATE OR REPLACE PACKAGE application_user_pkg IS
    PROCEDURE insert_all(
        p_user_name        IN users.user_name%TYPE,
        p_first_name       IN users.first_name%TYPE,
        p_last_name        IN users.last_name%TYPE, 
        p_email_id         IN users.email_id%TYPE,
        p_password         IN users.password%TYPE,
        p_phone_number     IN users.phone_number%TYPE, 
        p_date_of_birth    IN users.date_of_birth%TYPE,
        p_gender           IN users.gender%TYPE,
        p_user_status      IN users.user_status%TYPE,
        p_role             IN users.role%TYPE,
        p_street_address_1 IN address.street_address_1%TYPE,
        p_street_address_2 IN address.street_address_2%TYPE, 
        p_city             IN address.city%TYPE,
        p_state            IN address.state%TYPE,
        p_country          IN address.country%TYPE, 
        p_zipcode          IN address.zipcode%TYPE,
        p_latitude         IN address.latitude%TYPE,
        p_longitude        IN address.longitude%TYPE,
        p_id_type          IN id_detail.id_type%TYPE,
        p_id_path          IN id_detail.id_path%TYPE
    );
END application_user_pkg;
/


CREATE OR REPLACE PACKAGE BODY application_user_pkg IS
    PROCEDURE insert_all(
        p_user_name        IN users.user_name%TYPE,
        p_first_name       IN users.first_name%TYPE,
        p_last_name        IN users.last_name%TYPE, 
        p_email_id         IN users.email_id%TYPE,
        p_password         IN users.password%TYPE,
        p_phone_number     IN users.phone_number%TYPE, 
        p_date_of_birth    IN users.date_of_birth%TYPE,
        p_gender           IN users.gender%TYPE,
        p_user_status      IN users.user_status%TYPE,
        p_role             IN users.role%TYPE,
        p_street_address_1 IN address.street_address_1%TYPE,
        p_street_address_2 IN address.street_address_2%TYPE, 
        p_city             IN address.city%TYPE,
        p_state            IN address.state%TYPE,
        p_country          IN address.country%TYPE, 
        p_zipcode          IN address.zipcode%TYPE,
        p_latitude         IN address.latitude%TYPE,
        p_longitude        IN address.longitude%TYPE,
        p_id_type          IN id_detail.id_type%TYPE,
        p_id_path          IN id_detail.id_path%TYPE) IS
                         
        v_user_id NUMBER;

        -- Exceptions for input validation
        username_already_exists EXCEPTION;
        PRAGMA EXCEPTION_INIT(username_already_exists, -1);  -- Unique constraint violation
        invalid_pincode EXCEPTION;
        invalid_phone_number EXCEPTION;
        
    BEGIN
        -- Validate phone number length
        IF LENGTH(p_phone_number) != 10 THEN
            RAISE invalid_phone_number;
        END IF;

        -- Validate pincode length
        IF LENGTH(p_zipcode) != 5 THEN
            RAISE invalid_pincode;
        END IF;
        
        -- Insert into users table
        INSERT INTO users (user_name, first_name, last_name, email_id, password, phone_number, 
                           date_of_birth, gender, registration_date, user_status, role)
        VALUES (p_user_name, p_first_name, p_last_name, p_email_id, p_password, p_phone_number, 
                p_date_of_birth, p_gender, SYSDATE,p_user_status  , p_role)
        RETURNING user_id INTO v_user_id;

        -- Insert into address table
        INSERT INTO address (street_address_1, street_address_2, city, state, country, 
                             zipcode, latitude, longitude, user_user_id)
        VALUES (p_street_address_1, p_street_address_2, p_city, p_state, p_country, 
                p_zipcode, p_latitude, p_longitude, v_user_id);
                
        -- Insert into id_detail table
        INSERT INTO id_detail (id_type, id_path, user_user_id)
        VALUES (p_id_type, p_id_path, v_user_id);
        
    EXCEPTION
        WHEN username_already_exists THEN
            dbms_output.put_line('Error: Username already exists.');
        WHEN invalid_pincode THEN
            dbms_output.put_line('Error: Zipcode must be exactly 5 characters.');
        WHEN invalid_phone_number THEN
            dbms_output.put_line('Error: Phone number must be exactly 10 characters.');
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception: ' || SQLERRM);
    END insert_all;
END application_user_pkg;
/



BEGIN
    application_user_pkg.insert_all('user1', 'John', 'Doe', 'john.doe@example.com', 'password123', '9000907128', 
                                    TO_DATE('1985-01-01', 'YYYY-MM-DD'), 'Male','Active', 'Customer', 
                                    '100 Beacon St', 'Apt 1', 'Boston', 'MA', 'USA','02109', 42.3557, -71.0723, 
                                    'Driving License', '/path/to/driving/license/user1.jpg');
                                    
    application_user_pkg.insert_all('user2', 'Jane', 'Smith', 'jane.smith@example.com', 'password456', '9000907128', 
                                    TO_DATE('1990-02-02', 'YYYY-MM-DD'), 'Female', 'Active','Customer', 
                                    '200 Clarendon St', 'Floor 25', 'Boston', 'MA', 'USA','02116', 42.3494, -71.0759, 
                                    'SSN', '/path/to/ssn/user2.jpg');
                                    
    application_user_pkg.insert_all('user3', 'Emily', 'Jones', 'emily.jones@example.com', 'password789', '9000907128', 
                                    TO_DATE('1995-03-03', 'YYYY-MM-DD'), 'Female', 'Active','Customer', 
                                    '150 Dorchester Ave', 'Suite 5', 'Boston', 'MA', 'USA','02127', 42.3412, -71.0567, 
                                    'Driving License', '/path/to/driving/license/user3.jpg');
                                    
    application_user_pkg.insert_all('user4', 'Michael', 'Brown', 'michael.brown@example.com', 'password101', '9000907128', 
                                    TO_DATE('1988-04-04', 'YYYY-MM-DD'), 'Male','Active', 'Customer', 
                                    '101 Seaport Blvd', 'Apt 15', 'Boston', 'MA', 'USA','02210', 42.3495, -71.0435, 
                                    'SSN', '/path/to/ssn/user4.jpg');
                                    
    application_user_pkg.insert_all('user5', 'Linda', 'Taylor', 'linda.taylor@example.com', 'password202', '9000907128', 
                                    TO_DATE('1992-05-05', 'YYYY-MM-DD'), 'Female','Active', 'Customer', 
                                    '5 Park Plaza', 'Unit B', 'Boston', 'MA', 'USA','02116', 42.3515, -71.0702, 
                                    'Driving License', '/path/to/driving/license/user5.jpg');
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;


