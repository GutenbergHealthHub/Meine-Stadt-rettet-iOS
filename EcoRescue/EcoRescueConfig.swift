//
//  EcoRescueConfig.swift
//  EcoRescue
//
//  Created by Christoph Erl on 24.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

class EcoRescueConfig: NSObject {
    
    static let RouteDistanceTreshold: Double = 10000
    
    static let ExpireTimeInterval: TimeInterval   = 60.0 * 3
    static let NotificationInterval: TimeInterval = 6.0
    
    static let NotificationCount = Int(ExpireTimeInterval / NotificationInterval)
    
    static let EmergencyLocationUpdate: TimeInterval = 10.0

}
