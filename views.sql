DROP VIEW SubscriptionUsageReport;
DROP VIEW Citywiseusers;
DROP VIEW RidesByTimeOfDay;
DROP VIEW RevenueByTransactionType;
DROP VIEW BikeUtilizationRate;


-----View to check the usage report based on subscription plan----
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
    subs_plan sp ON us.subs_plan_subsplan_id = sp.subsplan_id;
    
select * from SUBSCRIPTIONUSAGEREPORT;



---- View to get the count of users for each city --
CREATE VIEW Citywiseusers AS
SELECT
    a.city,
    COUNT(*) AS user_count
FROM
    users u
JOIN
    address a ON u.user_id = a.user_user_id
GROUP BY
    a.city;
    
select * from CITYWISEUSERS;

-----View for numbers of rides for each time interval of day --

CREATE VIEW RidesByTimeOfDay AS
SELECT
    CASE
        WHEN EXTRACT(HOUR FROM start_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM start_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM start_time) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(*) AS ride_count
FROM
    ride
GROUP BY
    CASE
        WHEN EXTRACT(HOUR FROM start_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM start_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        WHEN EXTRACT(HOUR FROM start_time) BETWEEN 18 AND 23 THEN 'Evening'
        ELSE 'Night'
    END
ORDER BY
    1;

select * from RIDESBYTIMEOFDAY;


--View for Revenvue generated from Subscriptions and Miscilleneous costs --
CREATE VIEW RevenueByTransactionType AS
SELECT
    tt.transaction_name,
    SUM(t.amount) AS total_revenue
FROM
    trans t
JOIN
    trans_type tt ON t.trans_type_trans_type_id = tt.trans_type_id
GROUP BY
    tt.transaction_name;


select * from REVENUEBYTRANSACTIONTYPE;



---- View for Userdemographics based on age, gender, place -- 
CREATE VIEW UserDemographics AS
SELECT
    u.gender,
    CASE 
        WHEN EXTRACT(MONTH FROM u.date_of_birth) > EXTRACT(MONTH FROM SYSDATE) 
             OR (EXTRACT(MONTH FROM u.date_of_birth) = EXTRACT(MONTH FROM SYSDATE) 
                 AND EXTRACT(DAY FROM u.date_of_birth) > EXTRACT(DAY FROM SYSDATE))
        THEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.date_of_birth) - 1
        ELSE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.date_of_birth)
    END AS age,
    a.city,
    a.state,
    a.country,
    COUNT(*) AS user_count
FROM
    users u
JOIN
    address a ON u.user_id = a.user_user_id
GROUP BY
    u.gender,
    CASE 
        WHEN EXTRACT(MONTH FROM u.date_of_birth) > EXTRACT(MONTH FROM SYSDATE) 
             OR (EXTRACT(MONTH FROM u.date_of_birth) = EXTRACT(MONTH FROM SYSDATE) 
                 AND EXTRACT(DAY FROM u.date_of_birth) > EXTRACT(DAY FROM SYSDATE))
        THEN EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.date_of_birth) - 1
        ELSE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM u.date_of_birth)
    END,
    a.city,
    a.state,
    a.country;
    
select * from USERDEMOGRAPHICS;

----View for BikeutilizationRates ---

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
    bs.status_name;

select * from BIKEUTILIZATIONRATE;


