//
//  Hotel.swift
//  HotelMicroService
//
//  Created by Administrateur on 28/03/2017.
//
//

import PerfectLib

class Hotel : JSONConvertibleObject {
    
    static let registerName = "hotel"
    
    var id: Int
    var name: String = ""
    var address: String = ""
    var phone: String = ""
    var rating: Int = 0
    var country: String = ""
    var description:String = ""
    var room: [Room]?
    
    var location: String {
        return "\(address) \(country)"
    }
    
    init(id: Int, name: String, address: String, phone: String, country: String, description: String) {
        self.id = id
        self.name	= name
        self.address	= address
        self.phone		= phone
        self.country	= country
        self.description = description
        
    }
    
    init(id: Int, name: String, address: String, phone: String, rating: Int, country: String, description: String, room:[Room]?) {
        self.id = id
        self.name	= name
        self.address	= address
        self.phone		= phone
        self.rating	= rating
        self.country	= country
        self.description = description
        self.room = room
    }
    
    override public func setJSONValues(_ values: [String : Any]) {
        self.id =  getJSONValue(named: "id", from: values, defaultValue: 1)
        self.name		= getJSONValue(named: "name", from: values, defaultValue: "")
        self.address		= getJSONValue(named: "address", from: values, defaultValue: "")
        self.phone			= getJSONValue(named: "phone", from: values, defaultValue: "")
        self.rating		= getJSONValue(named: "rating", from: values, defaultValue: 0)
        self.country			= getJSONValue(named: "country", from: values, defaultValue: "")
        self.description			= getJSONValue(named: "description", from: values, defaultValue: "")
        self.room			= getJSONValue(named: "room", from: values, defaultValue: [])
    }
    override public func getJSONValues() -> [String : Any] {
        return [
            "id": id,
            "name":name,
            "address":address,
            "phone":phone,
            "rating":rating,
            "country":country,
            "description":description,
            "room":room as Any
        ]
    }
    
}
