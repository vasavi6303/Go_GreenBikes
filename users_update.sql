CREATE OR REPLACE PACKAGE application_user_update_pkg IS
    PROCEDURE update_all(
        p_user_id          IN users.user_id%TYPE,
        p_email_id         IN users.email_id%TYPE DEFAULT NULL,
        p_phone_number     IN users.phone_number%TYPE DEFAULT NULL,
        p_user_status      IN users.user_status%TYPE DEFAULT NULL,
        p_user_name        IN users.user_name%TYPE DEFAULT NULL,  -- Make sure this is included if it's in the body
        p_street_address_1 IN address.street_address_1%TYPE DEFAULT NULL,
        p_street_address_2 IN address.street_address_2%TYPE DEFAULT NULL, 
        p_city             IN address.city%TYPE DEFAULT NULL,
        p_state            IN address.state%TYPE DEFAULT NULL,
        p_country          IN address.country%TYPE DEFAULT NULL, 
        p_zipcode          IN address.zipcode%TYPE DEFAULT NULL,
        p_latitude         IN address.latitude%TYPE DEFAULT NULL,
        p_longitude        IN address.longitude%TYPE DEFAULT NULL,
        p_id_type          IN id_detail.id_type%TYPE DEFAULT NULL,
        p_id_path          IN id_detail.id_path%TYPE DEFAULT NULL
    );
END application_user_update_pkg;
/

CREATE OR REPLACE PACKAGE BODY application_user_update_pkg IS
    PROCEDURE update_all(
        p_user_id          IN users.user_id%TYPE,
        p_email_id         IN users.email_id%TYPE DEFAULT NULL,
        p_phone_number     IN users.phone_number%TYPE DEFAULT NULL,
        p_user_status      IN users.user_status%TYPE DEFAULT NULL,
        p_user_name        IN users.user_name%TYPE DEFAULT NULL,
        p_street_address_1 IN address.street_address_1%TYPE DEFAULT NULL,
        p_street_address_2 IN address.street_address_2%TYPE DEFAULT NULL, 
        p_city             IN address.city%TYPE DEFAULT NULL,
        p_state            IN address.state%TYPE DEFAULT NULL,
        p_country          IN address.country%TYPE DEFAULT NULL, 
        p_zipcode          IN address.zipcode%TYPE DEFAULT NULL,
        p_latitude         IN address.latitude%TYPE DEFAULT NULL,
        p_longitude        IN address.longitude%TYPE DEFAULT NULL,
        p_id_type          IN id_detail.id_type%TYPE DEFAULT NULL,
        p_id_path          IN id_detail.id_path%TYPE DEFAULT NULL
    ) IS
        v_exists NUMBER;
        username_already_exists EXCEPTION;
        user_not_found EXCEPTION;  -- Declare the missing exception
        PRAGMA EXCEPTION_INIT(username_already_exists, -1); -- Unique constraint error code
        PRAGMA EXCEPTION_INIT(user_not_found, -20001);  -- Map to the correct Oracle error for user not found
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

        -- Check if user_id exists
        SELECT COUNT(*)
        INTO v_exists
        FROM users
        WHERE user_id = p_user_id;

        IF v_exists = 0 THEN
            RAISE user_not_found;  -- Raise the correctly declared exception
        END IF;

        -- Check for unique username if it is being updated
        IF p_user_name IS NOT NULL THEN
            SELECT COUNT(*)
            INTO v_exists
            FROM users
            WHERE user_name = p_user_name AND user_id != p_user_id;

            IF v_exists > 0 THEN
                RAISE username_already_exists;
            ELSE
                -- Update username if it's provided and unique
                UPDATE users
                SET user_name = p_user_name
                WHERE user_id = p_user_id;
            END IF;
        END IF;

        -- Update other user details if username update is successful or not required
        UPDATE users
        SET email_id = COALESCE(p_email_id, email_id),
            phone_number = COALESCE(p_phone_number, phone_number),
            user_status = COALESCE(p_user_status, user_status)
        WHERE user_id = p_user_id;

        -- Update address details
        UPDATE address
        SET street_address_1 = COALESCE(p_street_address_1, street_address_1),
            street_address_2 = COALESCE(p_street_address_2, street_address_2),
            city = COALESCE(p_city, city),
            state = COALESCE(p_state, state),
            country = COALESCE(p_country, country),
            zipcode = COALESCE(p_zipcode, zipcode),
            latitude = COALESCE(p_latitude, latitude),
            longitude = COALESCE(p_longitude, longitude)
        WHERE user_user_id = p_user_id;

        -- Update ID details
        UPDATE id_detail
        SET id_type = COALESCE(p_id_type, id_type),
            id_path = COALESCE(p_id_path, id_path)
        WHERE user_user_id = p_user_id;

        -- Handle successful update
        dbms_output.put_line('Update successful for user ID ' || p_user_id);

    EXCEPTION
        WHEN invalid_pincode THEN
            dbms_output.put_line('Error: Zipcode must be exactly 5 characters.');
        WHEN invalid_phone_number THEN
            dbms_output.put_line('Error: Phone number must be exactly 10 characters.');
        WHEN username_already_exists THEN
            dbms_output.put_line('Error: Username already exists and must be unique.');
        WHEN user_not_found THEN
            dbms_output.put_line('Error: User ID does not exist.');
        WHEN OTHERS THEN
            dbms_output.put_line('Error during update: ' || SQLERRM);
            ROLLBACK; -- Ensure transaction is rolled back on error
    END update_all;
END application_user_update_pkg;
/


BEGIN
    application_user_update_pkg.update_all(
        p_user_id          => 3,
        p_user_name        => 'user3',
        p_email_id         => 'updated.email@example.com',
        p_phone_number     => '555-0202',
        p_street_address_1 => '101 New Street',
        p_city             => 'New City',
        p_user_status      => 'InActive'
        -- Other parameters can be omitted if not updating
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;

