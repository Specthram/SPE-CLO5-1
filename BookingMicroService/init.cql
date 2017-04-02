CREATE KEYSPACE booking WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE booking;

CREATE TABLE booking (
id int PRIMARY KEY,
room varchar,
reserved boolean,
start_date date,
end_date date,
user int
);

CREATE TABLE users (
id int PRIMARY KEY,
username varchar,
password varchar,
session_token varchar,
firstname varchar,
lastname varchar,
address varchar
);

INSERT INTO users ("id", "username", "password", "session_token", "firstname", "lastname", "address") VALUES (1, 'admin', 'admin', 'token1', 'admin', 'admin', 'random address');
INSERT INTO users ("id", "username", "password", "session_token", "firstname", "lastname", "address") VALUES (1, 'michel64', 'michel', 'tokenmichel', 'michel', 'dupont', 'random address');
INSERT INTO users ("id", "username", "password", "session_token", "firstname", "lastname", "address") VALUES (1, 'yvette42', 'yvette', 'tokenyvette', 'yvette', 'martin', 'random address');