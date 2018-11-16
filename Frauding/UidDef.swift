//
//  UidDef.swift
//  Frauding
//
//  Created by Isma Dia on 06/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UidDef {
    //static let hostname = "http://localhost:3000/"
   static let hostname = "http://172.20.10.7:8000/"
   //static let hostname = "http://10.33.6.78:8000/"
    
    static let cloudMessagingKey = "AAAANk-2ynk:APA91bES9fRG6mH8TAGNzA-ouEkfzN_8UcI2sdGEJNUEFhDcGed0vZJXHcrIxsfJ7qclh3OGZ_rVU7eOE6X7Qw2Q2XhBhlGq2G9vHoDdSgSy0SdSgBreI7WOD4A1asqIrpF1HWCPFqaE"
    static let metroDictionary : [String : String] = ["line:RAT:M1":"Ligne 1","line:RAT:M2":"Ligne 2","line:RAT:M3":"Ligne 3","line:RAT:M4":"Ligne 4","line:RAT:M5":"Ligne 5","line:RAT:M6":"Ligne 6","line:RAT:M7":"Ligne 7","line:RAT:M8":"Ligne 8","line:RAT:M9":"Ligne 9","line:RAT:M10":"Ligne 10","line:RAT:M11":"Ligne 11","line:RAT:M12":"Ligne 12","line:RAT:M13":"Ligne 13","line:RAT:M14":"Ligne 14"]
    static let metroImageDictionary : [String : String] = ["line:RAT:M1":"M1genRVB","line:RAT:M2":"M2genRVB","line:RAT:M3":"M3genRVB","line:RAT:M4":"M4genRVB","line:RAT:M5":"M5genRVB","line:RAT:M6":"M6genRVB","line:RAT:M7":"M7genRVB","line:RAT:M8":"M8genRVB","line:RAT:M9":"M9genRVB","line:RAT:M10":"M10genRVB","line:RAT:M11":"M11genRVB","line:RAT:M12":"M12genRVB","line:RAT:M13":"M13genRVB","line:RAT:M14":"M14genRVB"]
}

extension UIColor {
    static func mainColor() -> UIColor {
        return UIColor(red: 40/255, green: 40/255, blue: 40/225, alpha: 1)
    }
    static func greenColor() -> UIColor {
       // return UIColor(red: 30/255, green: 215/255, blue: 95/255, alpha: 1)
        return UIColor(red:1, green:1, blue:1, alpha:1)
        
    }
}

extension UidDef {
    static func openMapApp(coordonnees : CLLocationCoordinate2D?){
        guard let coordinate = coordonnees else {return}
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        //mapItem.name = "Destination/Target Address or Name"
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])

    }
    
    static func alertGoMapApp(viewController : UIViewController, coordonnees : CLLocationCoordinate2D?){
        let alert = UIAlertController(title: "Ouvrir Plans", message: "Voulez-vous poursuivre votre itinéraire dans l'application Plans?", preferredStyle: .alert)
        let openMapAction = UIAlertAction(title: "Oui", style: .cancel) { (action) in
            openMapApp(coordonnees: coordonnees)
        }
        let cancelAction = UIAlertAction(title: "Non", style: .default, handler: nil)
        alert.addAction(openMapAction)
        alert.addAction(cancelAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
}
