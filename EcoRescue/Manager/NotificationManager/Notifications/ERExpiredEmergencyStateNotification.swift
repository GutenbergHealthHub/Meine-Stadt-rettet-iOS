//
//  ERExpiredEmergencyStateNotification.swift
//  EcoRescue
//
//  Created by Christoph Erl on 13.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

private let kType = "EmergencyStateExpired"

class ERExpiredEmergencyStateNotification: ERNotification {
    
    // Variables
    let emergencyStateId: String
    
    init?(userInfo: [AnyHashable: Any]?) {        
        let emergencyStateId = userInfo?["emergencyStateId"] as? String
        let type = userInfo?["type"] as? String
        
        if let emergencyStateId = emergencyStateId, type == kType {
            self.emergencyStateId = emergencyStateId
        } else {
            return nil
        }
        
        super.init(userInfo: userInfo ?? [:], identifier: ERExpiredEmergencyStateNotification.createIdentifier(emergencyStateId: emergencyStateId))
    }
    
    init(emergencyStateId: String) {
        self.emergencyStateId = emergencyStateId
        
        let userInfo = ["type": kType, "emergencyStateId": emergencyStateId]
        
        super.init(userInfo: userInfo, identifier: ERExpiredEmergencyStateNotification.createIdentifier(emergencyStateId: emergencyStateId))
    }
    
    // Private Class Methods
    
    private class func createIdentifier(emergencyStateId: String?) -> String {
        return kType + "_" + emergencyStateId!
    }

}
