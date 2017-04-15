//
//  RouteHandler.swift
//  HotelMicroService
//
//  Created by Administrateur on 28/03/2017.
//
//

import PerfectHTTP
import TurnstilePerfect
import Turnstile
import TurnstileCrypto
import TurnstileWeb
import PerfectLogger
import PerfectRequestLogger

func makeUrlRoutes() -> Routes {
    
    // here I create a variable for all my route I want to add with base URI
    var routes = Routes(baseUri: "/api/v1")
    
    // Register my routes in Routes Object
    routes.add(method: .post, uri: "/login", handler: loginHandler)
    routes.add(method: .post, uri: "/register", handler: registerHandler)
    routes.add(method: .get, uri: "/me", handler: getSelfUserHandler)
    routes.add(method: .get, uri: "/logout", handler: logoutHandler)
    routes.add(method: .get, uri: "/checkauth", handler: logoutHandler)

    
    print("\(routes.navigator.description)")
    
    return routes
}


/////////////////
/// HANDLER ////
///////////////


func loginHandler(request: HTTPRequest, _ response: HTTPResponse) {
    guard let username = request.param(name: "username"),
        let password = request.param(name: "password") else {
            response.appendBody(string: toStringJon(str: "Missing username or password"))
            LogFile.debug("Missing username or password")
            return
    }
    let credentials = UsernamePassword(username: username, password: password)
    
    do {
        try request.user.login(credentials: credentials, persist: true)
        let account = request.user.authDetails?.account.uniqueID
        response.appendBody(string: toStringJon(str: account!))
        append(key: "uniqueID", value: account!)
    } catch {
        response.appendBody(string: toStringJon(str: "Invalid Username or Password"))
    }
    
    response.setHeader(.contentType, value: "application/json")
    response.completed()
}

func checkauthHandler(request: HTTPRequest, _ response: HTTPResponse) {
    guard let username = request.param(name: "uniqueID")else {
            response.appendBody(string: toStringJon(str: "Missing uniqueID"))
            LogFile.debug("Missing uniqueID")
            return
    }
    
    var re = getData(key: "uniqueID")
    
    if re?.range(of:username) != nil{
        response.appendBody(string: toStringJon(str: "OK USA"))
    }else{
        response.appendBody(string: toStringJon(str: "fuck off"))
    }
    
    response.setHeader(.contentType, value: "application/json")
    response.completed()
}

func registerHandler(request: HTTPRequest, _ response: HTTPResponse) {
    guard let username = request.param(name: "username"),
        let password = request.param(name: "password") else {
            response.appendBody(string: "Missing username or password")
            LogFile.debug("Missing username or password")
            return
    }
    let credentials = UsernamePassword(username: username, password: password)
    
    do {
        try request.user.register(credentials: credentials)
        try request.user.login(credentials: credentials, persist: true)
    } catch let e as TurnstileError {
        response.appendBody(string: toStringJon(str: e.description))
    } catch {
        response.appendBody(string: "An unknown error occurred.")
        LogFile.critical(" An unknown error occurred.")
    }
    
    response.setHeader(.contentType, value: "application/json")
    response.completed()
}

func getSelfUserHandler(request: HTTPRequest, _ response: HTTPResponse) {
    guard let account = request.user.authDetails?.account as? User else {
        response.status = .unauthorized
        response.appendBody(string: "401 Unauthorized")
        LogFile.info("\(request): 401 Unauthorized")
        response.completed()
        return
    }
    response.appendBody(string: account.json)
    response.completed()
    return
}

func logoutHandler(request: HTTPRequest, _ response: HTTPResponse) {
    request.user.logout()
    response.appendBody(string: "ok logout")
    LogFile.info("ok logout")
    response.completed()
}

func toStringJon(str: String) -> String {
    var out = String()
    
        do {
            out = try str.jsonEncodedString()
        } catch {
            print(error)
            LogFile.error("JSON \(error)")
        }
    
    return out
}

