
//
//  Hotel.swift
//  HotelMicroService
//
//  Created by Administrateur on 28/03/2017.
//
//


import PerfectLib
import PerfectHTTP
import PerfectHTTPServer
import PerfectRedis

// C'est trop bon rhooo

// here I create my server
let server = HTTPServer()

// Listen on port 8181.
server.serverPort = 8181

// Add our routes.
let routes = makeUrlRoutes()
server.addRoutes(routes)

print("fin")


do {
    // Launch the HTTP server.
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}

