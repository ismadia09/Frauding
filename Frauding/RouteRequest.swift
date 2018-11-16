//
//  RouteRequest.swift
//  Frauding
//
//  Created by Isma Dia on 05/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import Alamofire
import MapKit
import CoreLocation

class RouteRequest {
    
  
    static func getRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([Itineraire]) -> Void ){
        let fromLatitude = from.latitude
        let fromLongitude = from.longitude
        let toLatitude = to.latitude
        let toLongitude = to.longitude
        var itineraires =  [Itineraire]()
       //"http://10.33.0.99:3000/?from=2.3749036;48.8467927&to=2.2922926;48.8583736"
        //let urlString = "http://10.33.0.99:3000/?from=\(fromLongitude);\(fromLatitude)&to=\(toLongitude);\(toLatitude)"
        let urlString = "\(UidDef.hostname)?from=\(fromLongitude);\(fromLatitude)&to=\(toLongitude);\(toLatitude)"
        guard let url = URL(string: urlString) else {
            completion(itineraires)
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if ( response.error != nil) {
                print("ERROR = \(response.error)")
            }
            if let JSON = response.result.value as?  [[Any]]{
                
                print("################")
                print(JSON)
                print(JSON.count)
                print("################")
                
                for itineraire in JSON {
                    print(itineraire)
                    print("*****")
                    var steps = [Route]()
                    for step in itineraire as! [[String: Any]] {
                        
                        var portique_to : Portique?
                        var portique_from : Portique?
                        print(step["portique_to"] as? NSNull)
                        if (step["portique_to"] as? NSNull == nil && step["portique_from"] as? NSNull == nil){
                            let portitque_toDictionnary = step["portique_to"] as! [String : Any]
                            let portique_fromDictionnary = step["portique_from"] as! [String : Any]
                            
                            portique_to = Portique(id_name: portitque_toDictionnary["id_name"] as? String,
                                                   id: portitque_toDictionnary["id"] as? NSNumber,
                                                   name: portitque_toDictionnary["name"] as? String,
                                                   photo: portitque_toDictionnary["photo"] as? String
                            )
                            portique_from = Portique(id_name: portique_fromDictionnary["id_name"] as? String,
                                                     id: portique_fromDictionnary["id"] as? NSNumber,
                                                     name: portique_fromDictionnary["name"] as? String,
                                                     photo: portique_fromDictionnary["photo"] as? String
                            )
                        }
                        
                        
                        
                        let route = Route(duration: step["duration"] as? NSNumber,
                                          embedded_type: step["embedded_type"] as? String,
                                          from_name_station: step["from_name_station"] as? String,
                                          stop_point_from: step["stop_point_from"] as? String,
                                          stop_point_from_controleurs: step["stop_point_from_controleurs"] as? NSNumber,
                                          stop_point_to: step["stop_point_to"] as? String,
                                          stop_point_to_controleurs: step["stop_point_to_controleurs"] as? NSNumber,
                                          to_name_station: step["to_name_station"] as? String,
                                          transfer_type: step["transfer_type"] as? String,
                                          type: step["type"] as? String,
                                          vehicule: step["vehicule"] as? String,
                                          portique_to: portique_to,
                                          portique_from: portique_from)
                        
                        print(route)
                        steps.append(route)
                        
                    }
                    let itineraire = Itineraire(routes: steps)
                    itineraires.append(itineraire)
                    print(itineraires)
                }
                completion(itineraires)
            }
        }
        print(itineraires)
    }
    
    static func getTest(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D, completion: @escaping ([Itineraire]) -> Void ){
        /*let fromLatitude = from.latitude
        let fromLongitude = from.longitude
        let toLatitude = to.latitude
        let toLongitude = to.longitude*/
        var itineraires =  [Itineraire]()
        //"http://10.33.0.99:3000/?from=2.3749036;48.8467927&to=2.2922926;48.8583736"
        //let urlString = "http://10.33.0.99:3000/?from=\(fromLongitude);\(fromLatitude)&to=\(toLongitude);\(toLatitude)"
        let urlString = "\(UidDef.hostname)static"
        guard let url = URL(string: urlString) else {
            completion(itineraires)
            return
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if ( response.error != nil) {
                print("ERROR = \(response.error)")
            }
            if let JSON = response.result.value as?  [[Any]]{
                
                print("################")
                print(JSON)
                print(JSON.count)
                print("################")
                
                for itineraire in JSON {
                    print(itineraire)
                    print("*****")
                    var steps = [Route]()
                    for step in itineraire as! [[String: Any]] {
                        
                        var portique_to : Portique?
                        var portique_from : Portique?
                        if (step["portique_to"] as? NSNull == nil && step["portique_from"] as? NSNull == nil){
                            let portitque_toDictionnary = step["portique_to"] as! [String : Any]
                            let portique_fromDictionnary = step["portique_from"] as! [String : Any]
                            
                            portique_to = Portique(id_name: portitque_toDictionnary["id_name"] as? String,
                                                       id: portitque_toDictionnary["id"] as? NSNumber,
                                                       name: portitque_toDictionnary["name"] as? String,
                                                       photo: portitque_toDictionnary["photo"] as? String
                            )
                            portique_from = Portique(id_name: portique_fromDictionnary["id_name"] as? String,
                                                         id: portique_fromDictionnary["id"] as? NSNumber,
                                                         name: portique_fromDictionnary["name"] as? String,
                                                         photo: portique_fromDictionnary["photo"] as? String
                            )
                        }
                     
                        
                        
                        let route = Route(duration: step["duration"] as? NSNumber,
                                          embedded_type: step["embedded_type"] as? String,
                                          from_name_station: step["from_name_station"] as? String,
                                          stop_point_from: step["stop_point_from"] as? String,
                                          stop_point_from_controleurs: step["stop_point_from_controleurs"] as? NSNumber,
                                          stop_point_to: step["stop_point_to"] as? String,
                                          stop_point_to_controleurs: step["stop_point_to_controleurs"] as? NSNumber,
                                          to_name_station: step["to_name_station"] as? String,
                                          transfer_type: step["transfer_type"] as? String,
                                          type: step["type"] as? String,
                                          vehicule: step["vehicule"] as? String,
                                          portique_to: portique_to,
                                          portique_from: portique_from)
                        
                        print(route)
                        steps.append(route)
                        
                    }
                    let itineraire = Itineraire(routes: steps)
                    itineraires.append(itineraire)
                    print(itineraires)
                }
                completion(itineraires)
            }
        }
        print(itineraires)
    }

}



