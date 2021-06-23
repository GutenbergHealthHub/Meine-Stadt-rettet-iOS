//
//  ERTimestamp.swift
//  EcoRescue
//
//  Created by Christoph Erl on 19.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERLocationTracking: PFObject, PFSubclassing {
    
    @NSManaged var location: PFGeoPoint?
    @NSManaged var emergencyStateRelation: EREmergencyState?
    
    override init() {
        super.init()
    }
    
    override init(className newClassName: String) {
        super.init(className: newClassName)
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "LocationTracking"
    }
}
