//
//  ERCancelEmergencyNotification.swift
//  EcoRescue
//
//  Created by Christoph Erl on 13.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

private let kTypeIdentifier = "CancelEmergencyNotificationIdentifier"

class ERCancelEmergencyNotification: ERNotification {

    let emergencyStateId: String
    let cancel: Bool
    
    init?(userInfo: [AnyHashable: Any]?) {
        
        let emergencyStateId = userInfo?["emergencyStateId"] as? String
        let cancel = userInfo?["cancel"] as? NSNumber
        
        if let emergencyStateId = emergencyStateId, let cancel = cancel {
            self.emergencyStateId = emergencyStateId
            self.cancel = cancel.boolValue
        } else {
            return nil
        }
        
        super.init(userInfo: userInfo ?? [:], identifier:  kTypeIdentifier)
    }
    
}
