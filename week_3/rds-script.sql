create database week3_db;
\c week3_db

create user week3_user with encrypted password 'PutvIQBP0XlF';
grant all privileges on database week3_db to week3_user;

CREATE TABLE accounts
(
    user_id    serial PRIMARY KEY,
    username   VARCHAR(50) UNIQUE  NOT NULL,
    password   VARCHAR(50)         NOT NULL,
    email      VARCHAR(255) UNIQUE NOT NULL,
    created_on TIMESTAMP           NOT NULL,
    last_login TIMESTAMP
);


INSERT INTO accounts (username, password, email, created_on)
VALUES ('mkyong', 'secure_password', 'aaa@gmail.com', current_timestamp);