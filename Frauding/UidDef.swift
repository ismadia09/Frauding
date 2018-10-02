//
//  UidDef.swift
//  Frauding
//
//  Created by Isma Dia on 06/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import UIKit

class UidDef {
    static let hostname = "http://localhost:3000/"
   //static let hostname = "http://10.33.0.99:8000/"
    static let metroDictionary : [String : String] = ["line:RAT:M1":"Ligne 1","line:RAT:M2":"Ligne 2","line:RAT:M3":"Ligne 3","line:RAT:M4":"Ligne 4","line:RAT:M5":"Ligne 5","line:RAT:M6":"Ligne 6","line:RAT:M7":"Ligne 7","line:RAT:M8":"Ligne 8","line:RAT:M9":"Ligne 9","line:RAT:M10":"Ligne 10","line:RAT:M11":"Ligne 11","line:RAT:M12":"Ligne 12","line:RAT:M13":"Ligne 13","line:RAT:M14":"Ligne 14"]
    static let metroImageDictionary : [String : String] = ["line:RAT:M1":"M1genRVB","line:RAT:M2":"M2genRVB","line:RAT:M3":"M3genRVB","line:RAT:M4":"M4genRVB","line:RAT:M5":"M5genRVB","line:RAT:M6":"M6genRVB","line:RAT:M7":"M7genRVB","line:RAT:M8":"M8genRVB","line:RAT:M9":"M9genRVB","line:RAT:M10":"M10genRVB","line:RAT:M11":"M11genRVB","line:RAT:M12":"M12genRVB","line:RAT:M13":"M13genRVB","line:RAT:M14":"M14genRVB"]
}

extension UIColor {
    static func mainColor() -> UIColor {
        return UIColor(red: 40/255, green: 40/255, blue: 40/225, alpha: 1)
    }
    static func greenColor() -> UIColor {
        return UIColor(red: 30/255, green: 215/255, blue: 95/255, alpha: 1)
    }
}
