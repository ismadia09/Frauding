//
//  ControleurRequest.swift
//  Frauding
//
//  Created by Isma Dia on 05/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import Alamofire
import MapKit
import CoreLocation

class ControleurRequest {
    
    static func reportControleur(id : String, completion: @escaping (Bool) -> Void ){
        var result = false
        let urlString = "\(UidDef.hostname)alert?id=\(id)"
        guard let url = URL(string: urlString) else {
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if ( response.error != nil) {
                print("ERROR = \(response.error)")
            }
            /*if let JSON = response.result.value as? [Any]{
                print(JSON)
                print(JSON)
                
                
            }*/
            if (response.response?.statusCode == 200){
                result = true
            }
            completion(result)
        }
    }
    
    static func getStationsList(completion: @escaping ([Station]) -> Void ){
        var stationsList = [Station]()
        let urlString = "\(UidDef.hostname)get_list_stations"
        guard let url = URL(string: urlString) else {
            return
        }
        
        Alamofire.request(url).responseJSON{ (response) in
            if ( response.error != nil) {
                print("ERROR = \(response.error)")
            }
            if let JSON = response.result.value as? [[String: Any]] {
                
                print("################")
                print(JSON)
                print("################")
                
               for station in JSON{
                    print("################")
                    print(station)
                    print("################")
                let s = Station(id: station["id"] as! NSNumber, agent: station["agent"] as! NSNumber, id_name: station["id_name"] as! String, name: station["name"] as! String)
                stationsList.append(s)
                }
                completion(stationsList)
            }
        }
    }
}
