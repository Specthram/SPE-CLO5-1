//
//  RouteHandler.swift
//  HotelMicroService
//
//  Created by Administrateur on 28/03/2017.
//
//

import PerfectHTTP

func makeUrlRoutes() -> Routes {
    
    // here I create a variable for all my route I want to add with base URI
    var routes = Routes(baseUri: "/api/v1")
    
    // Register my routes in Routes Object
    routes.add(method: .get, uri: "/", handler: mainHandler)
    routes.add(method: .get, uri: "/hotel", handler: getHotelHandler)
    routes.add(method: .post, uri: "/hotel", handler: postHotelHandler)
    routes.add(method: .get, uri: "/hotel/{id}", handler: getHotelHandlerByID)

    
    print("\(routes.navigator.description)")
    
    return routes
}


/////////////////
/// HANDLER ////
///////////////

func mainHandler(request: HTTPRequest, _ response: HTTPResponse) {
    response.setHeader(.contentType, value: "text/html")
    response.appendBody(string: "<html><title>Ok ça marche putain</title><body>Ok ça marche putain<</body></html>")
    response.completed()
}

func getHotelHandler(request: HTTPRequest, _ response: HTTPResponse) {
    let hotel = Catalogue()
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: hotel.list())
    response.completed()
}

func postHotelHandler(request: HTTPRequest, _ response: HTTPResponse) {
    let hotel = Catalogue()
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: hotel.add(request))
    response.completed()
}

func getHotelHandlerByID(request: HTTPRequest, _ response: HTTPResponse) {
    _ = Catalogue()
    
    response.appendBody(string: "<html><body>You get to path \(request.path) with variables \(request.urlVariables)</body></html>")
    response.completed()
}
