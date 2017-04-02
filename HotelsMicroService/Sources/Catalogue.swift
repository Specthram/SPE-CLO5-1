//
//  Catalogue.swift
//  HotelMicroService
//
//  Created by Administrateur on 28/03/2017.
//
//

import PerfectHTTP
import Darwin

public class Catalogue {
    // Container for array of type Person
    var data = [Hotel]()
    
    // Datafixture on init
    init(){
        
        data = [
            Hotel(id:Int(arc4random()),name: "Le normandie", address: "12 rue du deauville, Deauville", phone: "0148866545", rating: 5, country: "France", description: "Hotel de la mort qui tue", room: [Room(id: 191, number: 19191, category:"SR", maxPerson: "3", price: "55", isBooked: true)]),
            Hotel(id:Int(arc4random()),name: "Hilton hotel", address: "the fifht avenue, New York", phone: "555-456", rating: 5, country: "United State", description: "American hotel for best place ever in the big apple", room: [Room(id: 11, number: 191, category:"S", maxPerson: "4", price: "555", isBooked: false)]),
            Hotel(id:Int(arc4random()),name: "Chez moi ça pue", address: "02 rue devillers, Pamiers", phone: "0915456841", rating: 1, country: "France", description: "Mieux vaut pas y séjourner", room: [Room(id: 9, number: 1, category:"CD", maxPerson: "5", price: "5500", isBooked: false)])
        ]
        
        setData(key: "Hilton hotel", value: convetToString(arr: [Hotel(id:Int(arc4random()),name: "Hilton hotel", address: "the fifht avenue, New York", phone: "555-456", rating: 5, country: "United State", description: "American hotel for best place ever in the big apple", room: [Room(id: 9, number: 1, category:"CD", maxPerson: "5", price: "5500", isBooked: true)])]))
        
        setData(key: "Le normandie", value: convetToString(arr: [Hotel(id:Int(arc4random()),name: "Le normandie", address: "12 rue du deauville, Deauville", phone: "0148866545", rating: 5, country: "France", description: "Hotel de la mort qui tue",room: [Room(id: 11, number: 191, category:"S", maxPerson: "4", price: "555", isBooked: false), Room(id: 9, number: 1, category:"CD", maxPerson: "5", price: "5500", isBooked: false)])]))
        
        setData(key: "aaa", value: convetToString(arr: [Hotel(id:Int(arc4random()),name: "Chez moi ça pue", address: "02 rue devillers, Pamiers", phone: "0915456841", rating: 1, country: "France", description: "Mieux vaut pas y séjourner", room: [])]))
        
        
        
        
    }
    
    public func list() -> String {
        
        return toString()
    }
    
    public func add(_ request: HTTPRequest) -> String {
        let i = Int(arc4random())
        
        let new = Hotel(
            id: i,
            name: request.param(name: "name")!,
            address: request.param(name: "address")!,
            phone: request.param(name: "phone")!,
            country: request.param(name: "country")!,
            description: request.param(name: "description")!
        )
        
        setData(key: String(i), value: convetToString(arr: [new]))
        data.append(new)
        return toString()
    }
    
    private func toString() -> String {
        var out = [String]()
        
        for m in self.data {
            do {
                out.append(try m.jsonEncodedString())
            } catch {
                print(error)
            }
        }
        return "[\(out.joined(separator: ","))]"
    }
    
    private func convetToString(arr: [Hotel]) -> String {
        var out = [String]()
        
        for m in arr {
            do {
                out.append(try m.jsonEncodedString())
            } catch {
                print(error)
            }
        }
        return "[\(out.joined(separator: ","))]"
    }
    
}
