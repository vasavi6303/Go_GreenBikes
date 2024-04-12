CREATE OR REPLACE PACKAGE application_user_update_pkg IS
    PROCEDURE update_all(
        p_user_id          IN users.user_id%TYPE,
        p_email_id         IN users.email_id%TYPE DEFAULT NULL,
        p_phone_number     IN users.phone_number%TYPE DEFAULT NULL,
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
    BEGIN
        -- Update User Table
        IF p_email_id IS NOT NULL OR p_phone_number IS NOT NULL THEN
            UPDATE users
            SET email_id = COALESCE(p_email_id, email_id),
                phone_number = COALESCE(p_phone_number, phone_number)
            WHERE user_id = p_user_id;
        END IF;
        
        -- Update Address Table
        IF p_street_address_1 IS NOT NULL OR p_street_address_2 IS NOT NULL OR
           p_city IS NOT NULL OR p_state IS NOT NULL OR p_country IS NOT NULL OR
           p_zipcode IS NOT NULL OR p_latitude IS NOT NULL OR p_longitude IS NOT NULL THEN
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
        END IF;
        
        -- Update ID Detail Table
        IF p_id_type IS NOT NULL OR p_id_path IS NOT NULL THEN
            UPDATE id_detail
            SET id_type = COALESCE(p_id_type, id_type),
                id_path = COALESCE(p_id_path, id_path)
            WHERE user_user_id = p_user_id;
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Unhandled exception: ' || SQLERRM);
    END update_all;
END application_user_update_pkg;
/


BEGIN
    application_user_update_pkg.update_all(
        p_user_id          => 1,
        p_email_id         => 'updated.email@example.com',
        p_phone_number     => '555-0202',
        p_street_address_1 => '101 New Street',
        p_city             => 'New City'
        -- Other parameters can be omitted if not updating
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('Error: ' || SQLERRM);
END;

select * from users;