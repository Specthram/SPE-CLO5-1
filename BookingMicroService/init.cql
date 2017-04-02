CREATE KEYSPACE booking WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE booking;

CREATE TABLE booking (
id text PRIMARY KEY,
room int,
reserved boolean,
start_date timestamp,
end_date timestamp,
user text
);

CREATE TABLE users (
id text PRIMARY KEY,
username varchar,
password varchar,
session_token varchar,
firstname varchar,
lastname varchar,
address varchar
);

INSERT INTO users ("id", "username", "password", "session_token", "firstname", "lastname", "address") VALUES ('uuid1', 'admin', 'admin', 'tokenadmin', 'admin', 'admin', 'random address');
INSERT INTO users ("id", "username", "password", "session_token", "firstname", "lastname", "address") VALUES ('uuid2', 'michel64', 'michel', 'tokenmichel', 'michel', 'dupont', 'random address');
INSERT INTO users ("id", "username", "password", "session_token", "firstname", "lastname", "address") VALUES ('uuid3', 'yvette42', 'yvette', 'tokenyvette', 'yvette', 'martin', 'random address');