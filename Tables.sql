SET SERVEROUTPUT ON;

DECLARE
    v_table_name user_tables.table_name%TYPE;
BEGIN
    -- Drop foreign key constraints before dropping tables
    FOR c_fk IN (
        SELECT table_name, constraint_name
        FROM user_constraints
        WHERE constraint_type = 'R' -- Foreign Key Constraint
          AND r_constraint_name IN (
              SELECT constraint_name
              FROM user_constraints
              WHERE table_name IN ('ADDRESS', 'BIKE', 'BIKE_STATUS', 'ID_DETAIL',
                                   'LOCATION', 'MISCELLANEOUS_COST', 'RIDE',
                                   'SUBS_PLAN', 'TRANS', 'TRANS_TYPE', 'USERS', 'USER_SUBS')
          )
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 'ALTER TABLE ' || c_fk.table_name || ' DROP CONSTRAINT ' || c_fk.constraint_name;
            dbms_output.put_line('Dropped foreign key constraint ' || c_fk.constraint_name || ' on table ' || c_fk.table_name);
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error dropping foreign key constraint ' || c_fk.constraint_name || ': ' || sqlerrm);
        END;
    END LOOP;

    -- Loop over the tables to drop them if they exist
    FOR c IN (
        SELECT table_name
        FROM user_tables
        WHERE table_name IN ('ADDRESS', 'BIKE', 'BIKE_STATUS', 'ID_DETAIL',
                             'LOCATION', 'MISCELLANEOUS_COST', 'RIDE',
                             'SUBS_PLAN', 'TRANS', 'TRANS_TYPE', 'USERS', 'USER_SUBS')
    ) LOOP
        v_table_name := c.table_name;

        -- Check if the table exists before attempting to drop
        BEGIN
            EXECUTE IMMEDIATE 'DROP TABLE ' || v_table_name;
            dbms_output.put_line('Dropped table ' || v_table_name);
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line('Error dropping table ' || v_table_name || ': ' || sqlerrm);
        END;
    END LOOP;
END;
/

SET SERVEROUTPUT ON;

DECLARE
    v_sequence_name VARCHAR2(100);
BEGIN
    -- Loop over the sequences to drop them if they exist
    FOR c IN (
        SELECT sequence_name
        FROM user_sequences
        WHERE sequence_name IN ('ADDRESS_SEQ', 'BIKE_SEQ', 'BIKE_STATUS_SEQ', 'ID_DETAIL_SEQ',
                                'LOCATION_SEQ', 'MISCELLANEOUS_COST_SEQ', 'RIDE_SEQ',
                                'SUBS_PLAN_SEQ', 'TRANS_SEQ', 'TRANS_TYPE_SEQ', 'USER_SEQ', 'USER_SUBS_SEQ')
    ) LOOP
        v_sequence_name := c.sequence_name;

        -- Check if the sequence exists before attempting to drop
        BEGIN
            EXECUTE IMMEDIATE 'DROP SEQUENCE ' || v_sequence_name;
            dbms_output.put_line('Dropped sequence ' || v_sequence_name);
        EXCEPTION
            WHEN OTHERS THEN
                -- Output the error if the sequence cannot be dropped
                dbms_output.put_line('Error dropping sequence ' || v_sequence_name || ': ' || sqlerrm);
        END;
    END LOOP;
END;
/



-- Now you can execute your create table and sequence statements here
CREATE SEQUENCE address_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE bike_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;

CREATE SEQUENCE bike_status_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE id_detail_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE location_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE miscellaneous_cost_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE ride_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;

CREATE SEQUENCE subs_plan_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE trans_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE trans_type_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE user_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;
CREATE SEQUENCE user_subs_seq START WITH 1 INCREMENT BY 1 NOMAXVALUE NOCYCLE;

-- Create Tables
CREATE TABLE address (
    address_id       NUMBER DEFAULT address_seq.NEXTVAL NOT NULL,
    street_address_1 VARCHAR2(30 CHAR),
    street_address_2 VARCHAR2(30 CHAR),
    city             VARCHAR2(30 CHAR),
    state            VARCHAR2(30 CHAR),
    country          VARCHAR2(30 CHAR),
    zipcode          VARCHAR2(10 CHAR),
    latitude         NUMBER,
    longitude        NUMBER,
    user_user_id     NUMBER NOT NULL
);

CREATE TABLE bike (
    bike_id               NUMBER DEFAULT bike_seq.NEXTVAL NOT NULL,
    bike_status_status_id NUMBER NOT NULL,
    location_location_id  NUMBER NOT NULL
);

CREATE TABLE bike_status (
    status_id   NUMBER DEFAULT bike_status_seq.NEXTVAL  NOT NULL ,
    status_name VARCHAR2(20 CHAR)
);

CREATE TABLE id_detail (
    id_verf_id   NUMBER DEFAULT id_detail_seq.NEXTVAL NOT NULL,
    id_type      VARCHAR2(20 CHAR),
    id_path      VARCHAR2(50 CHAR),
    user_user_id NUMBER NOT NULL
);

CREATE TABLE location (
    location_id        NUMBER DEFAULT location_seq.NEXTVAL NOT NULL,
    location_name      VARCHAR2(20 CHAR),
    loc_status         VARCHAR2(20 CHAR),
    no_of_slots        NUMBER,
    address_address_id NUMBER NOT NULL
);

CREATE TABLE miscellaneous_cost (
    misc_cost_id NUMBER DEFAULT miscellaneous_cost_seq.NEXTVAL NOT NULL,
    cost_type    VARCHAR2(20 CHAR),
    amount       NUMBER,
    ride_ride_id NUMBER NOT NULL,
    status       VARCHAR2(30 CHAR)
);

CREATE TABLE ride (
    ride_id           NUMBER DEFAULT ride_seq.NEXTVAL NOT NULL,
    start_time        TIMESTAMP WITH TIME ZONE,
    end_time          TIMESTAMP WITH TIME ZONE,
    duration_time     NUMBER,
    start_location_id NUMBER,
    end_location_id   NUMBER,
    user_user_id      NUMBER NOT NULL,
    bike_bike_id      NUMBER NOT NULL
);

CREATE TABLE subs_plan (
    subsplan_id       NUMBER DEFAULT subs_plan_seq.NEXTVAL NOT NULL,
    subscription_type VARCHAR2(10 CHAR),
    price             NUMBER,
    duration_time     NUMBER,
    description       VARCHAR2(20 CHAR)
);

CREATE TABLE trans (
    trans_id                 NUMBER DEFAULT trans_seq.NEXTVAL NOT NULL,
    description              VARCHAR2(50 CHAR),
    transaction_time         TIMESTAMP WITH TIME ZONE,
    amount                   NUMBER,
    transaction_status       CHAR(1),
    user_user_id             NUMBER NOT NULL,
    trans_type_trans_type_id NUMBER NOT NULL
);

CREATE TABLE trans_type (
    trans_type_id    NUMBER  DEFAULT trans_type_seq.NEXTVAL NOT NULL,
    transaction_name VARCHAR2(20 CHAR)
);

CREATE TABLE users (
    user_id           NUMBER DEFAULT user_seq.NEXTVAL NOT NULL,
    user_name         VARCHAR2(20 CHAR),
    first_name        VARCHAR2(20 CHAR),
    last_name         VARCHAR2(20 CHAR),
    email_id          VARCHAR2(50 CHAR),
    password          VARCHAR2(100 CHAR),
    phone_number      VARCHAR2(20 CHAR),
    date_of_birth     DATE,
    gender            VARCHAR2(30 CHAR),
    registration_date DATE,
    user_status       CHAR(1),
    role              VARCHAR2(30 CHAR)
);

CREATE TABLE user_subs (
    user_subs_id          NUMBER DEFAULT user_subs_seq.NEXTVAL NOT NULL,
    subs_start_date       TIMESTAMP WITH TIME ZONE,
    subs_end_date         TIMESTAMP WITH TIME ZONE,
    alloted_time          NUMBER,
    remaining_time        NUMBER,
    user_subs_status      VARCHAR2(10 CHAR),
    subs_plan_subsplan_id NUMBER NOT NULL,
    user_user_id          NUMBER NOT NULL
);

-- Add Primary Keys
ALTER TABLE address ADD CONSTRAINT address_pk PRIMARY KEY (address_id);
ALTER TABLE bike ADD CONSTRAINT bike_pk PRIMARY KEY (bike_id);
ALTER TABLE bike_status ADD CONSTRAINT bike_status_pk PRIMARY KEY (status_id);
ALTER TABLE id_detail ADD CONSTRAINT id_detail_pk PRIMARY KEY (id_verf_id);
ALTER TABLE location ADD CONSTRAINT location_pk PRIMARY KEY (location_id);
ALTER TABLE miscellaneous_cost ADD CONSTRAINT miscellaneous_cost_pk PRIMARY KEY (misc_cost_id);
ALTER TABLE ride ADD CONSTRAINT ride_pk PRIMARY KEY (ride_id);
ALTER TABLE subs_plan ADD CONSTRAINT subs_plan_pk PRIMARY KEY (subsplan_id);
ALTER TABLE trans ADD CONSTRAINT trans_pk PRIMARY KEY (trans_id);
ALTER TABLE trans_type ADD CONSTRAINT trans_type_pk PRIMARY KEY (trans_type_id);
ALTER TABLE users ADD CONSTRAINT user_pk PRIMARY KEY (user_id);
ALTER TABLE user_subs ADD CONSTRAINT user_subs_pk PRIMARY KEY (user_subs_id);

-- Add Foreign Key Constraints
ALTER TABLE address ADD CONSTRAINT address_user_fk FOREIGN KEY (user_user_id) REFERENCES users (user_id);
ALTER TABLE bike ADD CONSTRAINT bike_bike_status_fk FOREIGN KEY (bike_status_status_id) REFERENCES bike_status (status_id);
ALTER TABLE bike ADD CONSTRAINT bike_location_fk FOREIGN KEY (location_location_id) REFERENCES location (location_id);
ALTER TABLE id_detail ADD CONSTRAINT id_detail_user_fk FOREIGN KEY (user_user_id) REFERENCES users (user_id);
ALTER TABLE location ADD CONSTRAINT location_address_fk FOREIGN KEY (address_address_id) REFERENCES address (address_id);
ALTER TABLE miscellaneous_cost ADD CONSTRAINT miscellaneous_cost_ride_fk FOREIGN KEY (ride_ride_id) REFERENCES ride (ride_id);
ALTER TABLE ride ADD CONSTRAINT ride_user_fk FOREIGN KEY (user_user_id) REFERENCES users (user_id);
ALTER TABLE ride ADD CONSTRAINT ride_bike_fk FOREIGN KEY (bike_bike_id) REFERENCES bike (bike_id);
ALTER TABLE user_subs ADD CONSTRAINT user_subs_subs_plan_fk FOREIGN KEY (subs_plan_subsplan_id) REFERENCES subs_plan (subsplan_id);
ALTER TABLE user_subs ADD CONSTRAINT user_subs_user_fk FOREIGN KEY (user_user_id) REFERENCES users (user_id);

-- Create Indexes
CREATE UNIQUE INDEX address__idx ON address (user_user_id ASC);
CREATE UNIQUE INDEX location__idx ON location (address_address_id ASC);
CREATE UNIQUE INDEX user_subs__idx ON user_subs (user_user_id ASC);


COMMIT;


