//
//  EREndedServicePauseNotification.swift
//  EcoRescue
//
//  Created by Christoph Erl on 13.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

private let kType           = "EndedServicePause"
private let kTypeIdentifier = "EndedServicePauseIdentifier"

class EREndedServicePauseNotification: ERNotification {
    
    static let identifier = kTypeIdentifier
    
    init?(userInfo: [AnyHashable: Any]?) {
        
        if let type = userInfo?["type"] as? String, type == kType {
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
