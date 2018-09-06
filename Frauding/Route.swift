//
//  Route.swift
//  Frauding
//
//  Created by Isma Dia on 05/09/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
/*
 duration = 2;
 "embedded_type" = "stop_point";
 "from_name_station" = "Reuilly - Diderot (Paris)";
 "stop_point_from" = "stop_point:RAT:SP:REUIL1";
 "stop_point_from_controleurs" = 0;
 "stop_point_to" = "stop_point:RAT:SP:GDLYO1";
 "stop_point_to_controleurs" = 0;
 "to_name_station" = "Gare de Lyon (Paris)";
 "transfer_type" = "commercial_mode:Metro";
 type = "public_transport";
 vehicule = "line:RAT:M1";*/

struct  Route {
    let duration : NSNumber?
    let embedded_type : String?
    let from_name_station: String?
    let stop_point_from: String?
    let stop_point_from_controleurs : NSNumber?
    let stop_point_to: String?
    let stop_point_to_controleurs : NSNumber?
    let to_name_station: String?
    let transfer_type: String?
    let type: String?
    let vehicule : String?
    
}

struct Itineraire {
    let routes : [Route]?
}

struct Station {
    let id : NSNumber?
    let agent : NSNumber?
    let id_name : String?
    let name : String?
}


