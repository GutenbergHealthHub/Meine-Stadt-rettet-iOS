//
//  ERUserContractBasic.swift
//  EcoRescue
//
//  Created by Christoph Erl on 03.05.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

enum ERUserContractState {
    case undefined, notSigned, signed, expired
    
    static func string(state: ERUserContractState) -> String {
        switch state {
        case .notSigned:    return String.NOT_SIGNED
        case .signed:       return String.SIGNED
        case .expired:      return String.EXPIRED
        case .undefined:    return String.UNKNOWN
        }
    }
}

class ERUserContract: PFObject, PFSubclassing {
    
    @NSManaged var contract:    ERContract?
    @NSManaged var signature:   PFFileObject?
    
    @NSManaged var signedAt:    Date?
    
    // MARK: - PFSubclassing
    
    var stateValue: ERUserContractState {
        if let contract = contract {
            if isSigned {
                return contract.valid ? .signed : .expired
            } else {
                return .expired
            }
        }
        return .undefined
    }
    
    var isSigned: Bool {
        return signature != nil
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "UserContractBasic"
    }
}
