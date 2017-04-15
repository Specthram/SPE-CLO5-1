//
//  Room.swift
//  HotelsMicroService
//
//  Created by DARKNIGHT on 31/03/2017.
//
//

import Foundation
import PerfectLib

class Room : JSONConvertibleObject {
    
    static let registerName = "room"
    
    var id: Int
    var number: Int
    var category: String
    var maxPerson: String
    var price: String
    var isBooked: Bool = false
    
    init(id: Int, number: Int, category:String, maxPerson: String, price: String, isBooked: Bool) {
        self.id = id
        self.number = number
        self.category = category
        self.maxPerson = maxPerson
        self.price = price
        self.isBooked = isBooked
    }
    
    override public func setJSONValues(_ values: [String : Any]) {
        self.id =  getJSONValue(named: "id", from: values, defaultValue: 1)
        self.number		= getJSONValue(named: "number", from: values, defaultValue: 0)
        self.category		= getJSONValue(named: "category", from: values, defaultValue: "")
        self.maxPerson			= getJSONValue(named: "maxPerson", from: values, defaultValue: "")
        self.price		= getJSONValue(named: "price", from: values, defaultValue: "")
        self.isBooked		= getJSONValue(named: "isBooked", from: values, defaultValue: false)
    }
    
    
    override public func getJSONValues() -> [String : Any] {
        return [
            "id": id,
            "number":number,
            "category":category,
            "maxPerson": maxPerson,
            "price":price,
            "isBooked": isBooked
        ]
    }
    
}
