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
    
    static func reportControleur(from: CLLocationCoordinate2D) -> Bool{
        let result = false
        let fromLatitude = from.latitude
        let fromLongitude = from.longitude
        //"http://10.33.0.99:3000/?from=2.3749036;48.8467927&to=2.2922926;48.8583736"
        //let urlString = "http://10.33.0.99:3000/?from=\(fromLongitude);\(fromLatitude)&to=\(toLongitude);\(toLatitude)"
        let urlString = "\(UidDef.hostname)controleur?from=\(fromLongitude);\(fromLatitude)"
        guard let url = URL(string: urlString) else {
            return result
        }
        
        Alamofire.request(url).responseJSON { (response) in
            if ( response.error != nil) {
                print("ERROR = \(response.error)")
            }
            if let JSON = response.result.value{
                print(JSON)
                print(JSON)
            }
        }
        return result
    }
}
