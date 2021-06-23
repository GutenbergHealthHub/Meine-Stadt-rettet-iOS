//
//  ERUserContractSub.swift
//  EcoRescue
//
//  Created by Birtan on 26.07.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit
import Parse

class ERUserContractSub: PFObject, PFSubclassing {
    
    @NSManaged var contract:    ERContractSub?
    @NSManaged var signature:   PFFileObject?
    @NSManaged var user:        ERUser?
    
    @NSManaged var signedAt:    Date?
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "UserContract"
    }
}
