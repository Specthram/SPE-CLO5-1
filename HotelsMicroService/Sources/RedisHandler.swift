//
//  RedisHandler.swift
//  HotelMicroService
//
//  Created by Administrateur on 28/03/2017.
//
//

import PerfectRedis
import Foundation
import PerfectLogger
import PerfectRequestLogger

func clientIdentifier() -> RedisClientIdentifier {
    return RedisClientIdentifier()
}

func setData(key: String, value: String){
    
    RedisClient.getClient(withIdentifier: clientIdentifier()) {
        c in
        do {
            let client = try c()
            client.set(key: key, value: .string(value)) {
                response in
                guard response.isSimpleOK else {
                    print(false, "Unexpected response \(response)")
                    LogFile.warning("Unexpected response \(response)")
                    return
                }

            }
        } catch {
            print(false, "Could not connect to server \(error)")
            LogFile.error("Could not connect to server \(error)")
            return
        }
    }

}

func getData(key:String) -> String? {

    var result: String? = nil
    
        RedisClient.getClient(withIdentifier: clientIdentifier()) {
            c in
            do {
                let client = try c()
                client.get(key: key) {
                    response in
                    defer {
                        RedisClient.releaseClient(client)
                        
                    }
                    guard case .bulkString = response else {
                        print(false, "Unexpected response \(response)")
                        LogFile.warning("Unexpected response \(response)")
                        return
                    }
                    let s = response.toString()
                    print(true, "Unexpected response \(s)")
                    LogFile.info("Unexpected response \(s)")
                    result = s!
                }
            } catch {
                print(false, "Could not connect to server \(error)")
                LogFile.error("Could not connect to server \(error)")
                return
            }
        }
    
    return result
}

func getAllData(pattern:String) -> Set<String>?{
    
    var result = Set<String>()
    RedisClient.getClient(withIdentifier: clientIdentifier()) {
        c in
        do {
            let client = try c()
            client.keys(pattern: pattern) {
                response in
                defer {
                    RedisClient.releaseClient(client)
                    
                }
                guard case .array  = response else {
                    print(false, "Unexpected response \(response)")
                    LogFile.warning("Unexpected response \(response)")
                    return
                }
                let res = response.toString()?.components(separatedBy: ",")
                let s = response.toString()
                print(true, "Unexpected response \(res)")
                LogFile.info("Unexpected response \(res)")
                
                
            }
        } catch {
            print(false, "Could not connect to server \(error)")
            LogFile.error("Could not connect to server \(error)")
            return
        }
    }
    
    return result
    
    
}

func flushAll() {
      RedisClient.getClient(withIdentifier: clientIdentifier()) {
        c in
        do {
            let client = try c()
            client.flushAll {
                response in
                defer {
                    RedisClient.releaseClient(client)
                }
                guard response.isSimpleOK else {
                    print(false, "Unexpected response \(response)")
                    LogFile.warning("Unexpected response \(response)")
                    return
                }
            }
        } catch {
            print(false, "Could not connect to server \(error)")
            LogFile.error("Could not connect to server \(error)")
            return
        }
    }
     
}

func save() {
       RedisClient.getClient(withIdentifier: clientIdentifier()) {
        c in
        do {
            let client = try c()
            client.save {
                response in
                defer {
                    RedisClient.releaseClient(client)
                     
                }
                guard response.isSimpleOK else {
                    print(false, "Unexpected response \(response)")
                    LogFile.warning("Unexpected response \(response)")
                    return
                }
            }
        } catch {
            print(false, "Could not connect to server \(error)")
            LogFile.error("Could not connect to server \(error)")
            return
        }
    }
}

func exists(key: String) {
    RedisClient.getClient(withIdentifier: clientIdentifier()) {
        c in
        do {
            let client = try c()
            client.exists(keys: key) {
                response in
                defer {
                    RedisClient.releaseClient(client)
                    
                }
                guard case .integer(let i) = response , i == 2 else {
                    print(false, "Unexpected response \(response)")
                    LogFile.warning("Unexpected response \(response)")
                    return
                }
            }
        } catch {
            print(false, "Could not connect to server \(error)")
            LogFile.error("Could not connect to server \(error)")
            return
        }
    }
     
}

func append(key: String, value: String) {
    
    RedisClient.getClient(withIdentifier: clientIdentifier()) {
        c in
        do {
            let client = try c()
            client.append(key: key, value: .string(value)) {
                response in
                guard case .integer(let i) = response , i == value.characters.count*2 else {
                    print(false, "Unexpected response \(response)")
                    LogFile.warning("Unexpected response \(response)")
                    return
                }
            }
        } catch {
            print(false, "Could not connect to server \(error)")
            LogFile.error("Could not connect to server \(error)")
            return
        }
    }
    
}
