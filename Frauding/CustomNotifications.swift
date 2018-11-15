//
//  CustomNotifications.swift
//  Frauding
//
//  Created by Isma Dia on 15/11/2018.
//  Copyright © 2018 Isma Dia. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class CustomNotifications {
    
    
    static func sendNotification(station : String){
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else {
            return
        }
        var notificationRequest = URLRequest(url: url)
        notificationRequest.httpMethod = "POST"
        let headers: HTTPHeaders = [
            "Content-Type":"application/json",
            "Authorization":"key=\(UidDef.cloudMessagingKey)"
        ]
        var parameters : [String : Any] = [:]
            parameters = [
                "to": "/topics/ALL",
                "notification" : [
                    "body" : "Un problème à la station \(station)",
                    "title": "Alert "
                ],
                "data" : [
                    //"conversationId" : "\(conversationId)",
                    "stationName" : "\(station)",
                ],
            ]
        
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
        
    }
}
