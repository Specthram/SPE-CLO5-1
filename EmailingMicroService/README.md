# Slim Framework 3 Booking Micro Service

# Route list

## POST /api/v1/mailing/post

permet d'envoyer un mail

* header TOKEN : uniquement l'admin peut envoyer des emails
* BODY : Json (voir exemple)'

`{
    "to" : {
                "name":"antho",
                "address":"frag132@gmail.com"
           },
    "subject" : "title test",
    "body" : "this is the mail body",
    "smtpUser" : "exemple@gmail.com",
    "smtpPassword" : "password"
}`