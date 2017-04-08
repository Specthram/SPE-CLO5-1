CREATE KEYSPACE emailing WITH REPLICATION = {'class': 'SimpleStrategy', 'replication_factor': 1};

USE emailing;

CREATE TABLE users (
id text PRIMARY KEY,
username varchar,
password varchar,
admin boolean,
session_token varchar,
firstname varchar,
lastname varchar,
address varchar,
email varchar
);

INSERT INTO users ("id", "username", "password", "admin", "session_token", "firstname", "lastname", "address", "email") VALUES ('uuid1', 'admin', 'admin', true,'tokenadmin', 'admin', 'admin', 'random address', 'ossent_a@etna-alternance.net');
INSERT INTO users ("id", "username", "password", "admin", "session_token", "firstname", "lastname", "address", "email") VALUES ('uuid2', 'michel64', 'michel', false, 'tokenmichel', 'michel', 'dupont', 'random address', 'aloui_a@etna-alternance.net');
INSERT INTO users ("id", "username", "password", "admin", "session_token", "firstname", "lastname", "address", "email") VALUES ('uuid3', 'yvette42', 'yvette', false, 'tokenyvette', 'yvette', 'martin', 'random address', 'thai_q@etna-alternance.net');