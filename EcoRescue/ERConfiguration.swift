//
//  ERConfiguration.swift
//  EcoRescue
//
//  Created by Christoph Erl on 19.01.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERConfiguration: PFObject, PFSubclassing {
    
    @NSManaged var distance: NSNumber?
    
    var distanceValue: Double? {
        set {
            if let newValue = newValue {
                distance = NSNumber(value: newValue)
            } else {
                distance = nil
            }
            
        }
        get {
            return distance?.doubleValue
        }
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Configuration"
    }
    
}
