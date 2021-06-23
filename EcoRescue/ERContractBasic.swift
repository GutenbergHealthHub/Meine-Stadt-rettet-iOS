//
//  ERContractBasic.swift
//  EcoRescue
//
//  Created by Christoph Erl on 06.03.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERContract: PFObject, PFSubclassing {
    
    @NSManaged var state:       String?
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
        return "ContractBasic"
    }
    
}
