//
//  User.swift
//  UserMicroService
//
//  Created by DARKNIGHT on 31/03/2017.
//
//

import PerfectLib
import Foundation
import Turnstile
import TurnstileCrypto

class User : JSONConvertibleObject {
    
    static let registerName = "user"
    
    public var uniqueID: String
    public var username: String?
    public var password: String?
    public var admin: Bool?
    public var token: String?
    public var firstname: String?
    public var lastname: String?
    public var adresse: String?
    public var apiKeySecret: String = URandom().secureToken
    
    public var facebookID: String?
    public var googleID: String?
    
    var data = [User]()
    
    init(id: String) {
        uniqueID = id
        data = [User(uniqueID:"uuid1", username: "admin", password: "admin", admin: true,token: "tokenadmin",firstname: "admin",lastname: "admin",adresse: "random address"),
            User(uniqueID: "uuid2", username: "michel64", password: "michel", admin: false, token: "tokenmichel", firstname: "michel", lastname: "dupont", adresse: "random address"),
            User(uniqueID: "uuid3", username: "yvette42", password: "yvette", admin: false, token: "tokenyvette", firstname: "yvette", lastname: "martin", adresse: "random address")]
        
    }
    
    init(uniqueID: String, username: String, password: String,admin: Bool, token: String, firstname: String, lastname: String, adresse: String ) {
        self.uniqueID = uniqueID
        self.username	= username
        self.password	= password
        self.admin		= admin
        self.token	= token
        self.firstname = firstname
        self.lastname	= lastname
        self.adresse = adresse
    }
    
    
    
    var dict: [String: String] {
        return [ "id": uniqueID,
                 "username": username ?? "",
                 "password": password ?? "",
                 "api_key_id": uniqueID,
                 "api_key_secret": apiKeySecret
        ]
    }
    
    var json: String {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []),
            let result = String(data: jsonData, encoding: .utf8) {
            return result
        }
        return ""
        
    }
}
