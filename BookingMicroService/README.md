# Slim Framework 3 Booking Micro Service

# Route list

## GET /api/v1/debug/users

liste tous les utilisateurs

## GET /api/v1/debug/booking

Liste les reservations effectuées

## GET /api/v1/debug/test

Vérifie la connection à la base de données

## GET /api/v1/booking

Liste les routes disponibles

## GET /api/v1/booking/book/{id}

Affiche une reservation par son id

* TOKEN : token ou username et password


## POST /api/v1/booking/book

Deposer une reservation

* TOKEN : token ou username et password
* BODY : JSON avec room (string), start_date (yyyy-mm-dd), end_date (yyyy-mm-dd), reserved (true ou false)

exemple :
`{"room": "34", "reserved": true, "start_date": "2016-01-01", "end_date":"2016-01-02"}`

retourne 200 quand ok.

##PATCH /api/v1/booking/book/{id}

* TOKEN : token ou username et password
* BODY : JSON (opération prise en compte : replace)

exemples :
- `{"op":"replace", "key": "reserved", "value": "false"}`
- `{"op":"replace", "key": "paid", "value": "true"}`


