//
//  EREmergency.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import Parse

class EREmergency: PFObject, PFSubclassing {
    
    @NSManaged var locationPoint:       PFGeoPoint?
    @NSManaged var informationString:   String?
    
    @NSManaged var patientName:         String?
    @NSManaged var emergencyNumberDC:   String?
    @NSManaged var indicatorName:       String?
    
    @NSManaged var state:               NSNumber?
    @NSManaged var status:              NSNumber?
    @NSManaged var keyword:             String?
    
    @NSManaged var objectName:          String?
    @NSManaged var city:                String?
    @NSManaged var streetName:          String?
    @NSManaged var streetNumber:        String?
    @NSManaged var zip:                 String?
    @NSManaged var country:             String?
    
    @NSManaged var configurationRelation:   ERConfiguration?
    @NSManaged var testEmergencySendBy:     PFInstallation?
    
    @NSManaged var controlCenterRelation:   ERControlCenter?
    
    override init() {
        super.init()
    }
    
    override init(className newClassName: String) {
        super.init(className: newClassName)
    }
    
    // MARK: - Attributes    
    var expired: Bool {
        return 0 > timeIntervalUntilExpired
    }
    
    var timeIntervalUntilExpired: TimeInterval {
        if let createdAt = createdAt {
            return createdAt.addingTimeInterval(EcoRescueConfig.ExpireTimeInterval).timeIntervalSinceNow
        }
        return 0
    }
    
    var address: UCAddress {
        let result = UCAddress()
        result.object   = objectName
        result.street   = streetName
        result.number   = streetNumber
        result.zip      = zip
        result.city     = city
        result.country  = country
        return result
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Emergency"
    }

}
