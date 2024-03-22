SET SERVEROUTPUT ON;

DECLARE
    v_view_name VARCHAR2(100);
BEGIN
    -- Drop SubscriptionUsageReport view if it exists
    v_view_name := 'SUBSCRIPTIONUSAGEREPORT';
    FOR c IN (SELECT view_name FROM user_views WHERE view_name = v_view_name) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v_view_name;
        DBMS_OUTPUT.PUT_LINE('Dropped view ' || v_view_name);
    END LOOP;

    -- Drop Citywiseusers view if it exists
    v_view_name := 'CITYWISEUSERS';
    FOR c IN (SELECT view_name FROM user_views WHERE view_name = v_view_name) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v_view_name;
        DBMS_OUTPUT.PUT_LINE('Dropped view ' || v_view_name);
    END LOOP;

    -- Drop RidesByTimeOfDay view if it exists
    v_view_name := 'RIDESBYTIMEOFDAY';
    FOR c IN (SELECT view_name FROM user_views WHERE view_name = v_view_name) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v_view_name;
        DBMS_OUTPUT.PUT_LINE('Dropped view ' || v_view_name);
    END LOOP;

    -- Drop RevenueByTransactionType view if it exists
    v_view_name := 'REVENUEBYTRANSACTIONTYPE';
    FOR c IN (SELECT view_name FROM user_views WHERE view_name = v_view_name) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v_view_name;
        DBMS_OUTPUT.PUT_LINE('Dropped view ' || v_view_name);
    END LOOP;

    -- Drop BikeUtilizationRate view if it exists
    v_view_name := 'BIKEUTILIZATIONRATE';
    FOR c IN (SELECT view_name FROM user_views WHERE view_name = v_view_name) LOOP
        EXECUTE IMMEDIATE 'DROP VIEW ' || v_view_name;
        DBMS_OUTPUT.PUT_LINE('Dropped view ' || v_view_name);
    END LOOP;


    -- Create SubscriptionUsageReport view
    BEGIN
        EXECUTE IMMEDIATE '
        CREATE VIEW SubscriptionUsageReport AS
        SELECT
            u.user_id,
            u.user_name,
            u.email_id,
            sp.subscription_type,
            us.subs_start_date,
            us.subs_end_date,
            us.alloted_time,
            us.remaining_time,
            us.user_subs_status AS subscription_status
        FROM
            users u
        JOIN
            user_subs us ON u.user_id = us.user_user_id
        JOIN
            subs_plan sp ON us.subs_plan_subsplan_id = sp.subsplan_id';
        DBMS_OUTPUT.PUT_LINE('Created view SubscriptionUsageReport');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating view SubscriptionUsageReport: ' || SQLERRM);
    END;

    -- Create Citywiseusers view
    BEGIN
        EXECUTE IMMEDIATE '
        CREATE VIEW Citywiseusers AS
        SELECT
            a.city,
            COUNT(*) AS user_count
        FROM
            users u
        JOIN
            address a ON u.user_id = a.user_user_id
        GROUP BY
            a.city';
        DBMS_OUTPUT.PUT_LINE('Created view Citywiseusers');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating view Citywiseusers: ' || SQLERRM);
    END;

    -- Create RidesByTimeOfDay view
    BEGIN
        EXECUTE IMMEDIATE '
        CREATE VIEW RidesByTimeOfDay AS
        SELECT
            CASE
                WHEN EXTRACT(HOUR FROM start_time) BETWEEN 6 AND 11 THEN ''Morning''
                WHEN EXTRACT(HOUR FROM start_time) BETWEEN 12 AND 17 THEN ''Afternoon''
                WHEN EXTRACT(HOUR FROM start_time) BETWEEN 18 AND 23 THEN ''Evening''
                ELSE ''Night''
            END AS time_of_day,
            COUNT(*) AS ride_count
        FROM
            ride
        GROUP BY
            CASE
                WHEN EXTRACT(HOUR FROM start_time) BETWEEN 6 AND 11 THEN ''Morning''
                WHEN EXTRACT(HOUR FROM start_time) BETWEEN 12 AND 17 THEN ''Afternoon''
                WHEN EXTRACT(HOUR FROM start_time) BETWEEN 18 AND 23 THEN ''Evening''
                ELSE ''Night''
            END
        ORDER BY
            1';
        DBMS_OUTPUT.PUT_LINE('Created view RidesByTimeOfDay');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating view RidesByTimeOfDay: ' || SQLERRM);
    END;

    -- Create RevenueByTransactionType view
    BEGIN
        EXECUTE IMMEDIATE '
        CREATE VIEW RevenueByTransactionType AS
        SELECT
            tt.transaction_name,
            SUM(t.amount) AS total_revenue
        FROM
            trans t
        JOIN
            trans_type tt ON t.trans_type_trans_type_id = tt.trans_type_id
        GROUP BY
            tt.transaction_name';
        DBMS_OUTPUT.PUT_LINE('Created view RevenueByTransactionType');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating view RevenueByTransactionType: ' || SQLERRM);
    END;

    -- Create BikeUtilizationRate view
    BEGIN
        EXECUTE IMMEDIATE '
        CREATE VIEW BikeUtilizationRate AS
        SELECT
            l.location_name,
            bs.status_name,
            COUNT(r.ride_id) AS total_rides,
            COUNT(DISTINCT b.bike_id) AS total_bikes,
            ROUND(COUNT(r.ride_id) * 100.0 / COUNT(DISTINCT b.bike_id), 2) AS utilization_rate_percent
        FROM
            bike b
        LEFT JOIN
            ride r ON b.bike_id = r.bike_bike_id
        JOIN
            location l ON b.location_location_id = l.location_id
        JOIN
            bike_status bs ON b.bike_status_status_id = bs.status_id
        GROUP BY
            l.location_name,
            bs.status_name
        ORDER BY
            l.location_name,
            bs.status_name';
        DBMS_OUTPUT.PUT_LINE('Created view BikeUtilizationRate');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error creating view BikeUtilizationRate: ' || SQLERRM);
    END;
END;
/


select * from SubscriptionUsageReport;
select * from citywiseusers;
select * from RidesByTimeOfDay;
select * from RevenueByTransactionType;
select * from BikeUtilizationRate;