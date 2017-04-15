# SPE-CLO5

CLO5
===================

#### <i class="icon-hdd"></i> Route :

- [method: GET, uri: "/"]: 
parametre = none
retour = "<html><title>Ok ça marche putain</title><body>Ok ça marche putain<</body></html>"

- [method: POST, uri: "/hotel"]: 
parametre = name: String, address: String, phone: String, rating: Int, country: String, description: String, room: [number: String, category:String, maxPerson: Int, price: Int]
retour = 200

- [method: GET, uri: "/hotel"]: 
parametre = none
retour = liste hotel => JSON

- [method: GET, uri: "/hotel/{id}"]: 
parametre = id
retour = account hotel => JSON

-------------


