//
//  EREmergencyStateNotification.swift
//  EcoRescue
//
//  Created by Christoph Erl on 11.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class EREmergencyStateNotification: ERNotification {
    
    let emergencyStateId: String

    init?(userInfo: [AnyHashable: Any]?) {
        if let userInfo = userInfo, let emergencyStateId = userInfo["emergencyStateId"] as? String, let _ = userInfo["config"] {
            self.emergencyStateId = emergencyStateId
        } else {
           return nil
        }
        
        super.init(userInfo: userInfo ?? [:], identifier:  "")
    }
    
}
