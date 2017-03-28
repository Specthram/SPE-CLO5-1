//
//  Catalogue.swift
//  HotelMicroService
//
//  Created by Administrateur on 28/03/2017.
//
//

import PerfectHTTP

public class Catalogue {
    // Container for array of type Person
    var data = [Hotel]()
    
    // Datafixture on init
    init(){
        data = [
            Hotel(name: "Le normandie", address: "12 rue du deauville, Deauville", phone: "0148866545", rating: 5, country: "France", description: "Hotel de la mort qui tue"),
            Hotel(name: "Hilton hotel", address: "the fifht avenue, New York", phone: "555-456", rating: 5, country: "United State", description: "American hotel for best place ever in the big apple"),
            Hotel(name: "Chez moi ça pue", address: "02 rue devillers, Pamiers", phone: "0915456841", rating: 1, country: "France", description: "Mieux vaut pas y séjourner")
        ]
    }
    
    public func list() -> String {
        return toString()
    }
    
    public func add(_ request: HTTPRequest) -> String {
        let new = Hotel(
            name: request.param(name: "name")!,
            address: request.param(name: "address")!,
            phone: request.param(name: "phone")!,
            country: request.param(name: "country")!,
            description: request.param(name: "description")!
        )
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
    
}
