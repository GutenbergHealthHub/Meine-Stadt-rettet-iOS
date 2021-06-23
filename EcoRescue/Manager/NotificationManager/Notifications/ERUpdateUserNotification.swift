//
//  ERUpdateUserNotification.swift
//  EcoRescue
//
//  Created by Christoph Erl on 13.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

private let kTypeIdentifier = "UpdateUserNotificationIdentifier"
private let kType           = "EmergencyStatePushy"

class ERUpdateUserNotification: ERNotification {
    
    static let identifier = kTypeIdentifier
    
    init?(userInfo: [AnyHashable: Any]?) {
    
        if let event = userInfo?["event"] as? [String:String], let type = event["type"], type == "userdata"  {
            super.init(userInfo: userInfo ?? [:], identifier: kTypeIdentifier)
        } else {
            return nil
        }
    }
    
    init() {
        let userInfo = ["type": kType]
        
        super.init(userInfo: userInfo, identifier: kTypeIdentifier)
    }

}
