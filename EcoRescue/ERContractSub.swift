//
//  ERContractSub.swift
//  EcoRescue
//
//  Created by Birtan on 25.07.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit
import Parse

class ERContractSub: PFObject, PFSubclassing {

    @NSManaged var title:       String?
    @NSManaged var subtitle:    String?
    
    @NSManaged var url:         String?
    @NSManaged var version:     String?
    
    @NSManaged var validFrom:   Date?
    @NSManaged var validUntil:  Date?
    
    var valid: Bool {
        if let validUntil = validUntil {
            return Date().compare(validUntil) == .orderedAscending
        }
        return false
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "ContractSub"
    }
    
}
