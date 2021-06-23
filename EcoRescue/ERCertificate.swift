//
//  Certificate.swift
//  EcoRescue
//
//  Created by Christoph Erl on 26.04.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

enum ERCertificateType: Int {
    case other = 0, firstResponder = 1
    
    static var types: [ERCertificateType] {
        return [.firstResponder, .other]
    }
    
    // MARK: - Static Methods
    
    static func stringWith(type: ERCertificateType) -> String {
        switch type {
        case .firstResponder:   return String.FIRST_RESPONDER_CERTIFICATION
        case .other:            return String.OTHER_DOCUMENT
        }
    }
}

enum ERCertificateState: Int {
    case create = 0, review = 1, verified = 2, denied = 3
    
    static func infoStringWith(state: ERCertificateState) -> String? {
        switch state {
        case .create:       return nil
        case .review:       return String.DOCUMENT_REVIEW_INFO
        case .verified:     return nil
        case .denied:       return String.DOCUMENT_REJECTED_INFO
        }
    }
    
    static func stringWith(state: ERCertificateState) -> String? {
        switch state {
        case .create:       return String.NOT_UPLOADED
        case .review:       return String.IN_REVIEW
        case .verified:     return String.VERIFIED
        case .denied:       return String.REJECTED
        }
    }
    
}

class ERCertificate: PFObject, PFSubclassing {
    
    @NSManaged var title:   String?
    @NSManaged var file:    PFFileObject?
    
    @NSManaged var state:      NSNumber?
    @NSManaged var stateText:  String?
    
    @NSManaged var type:      NSNumber?
    
    var stateValue: ERCertificateState {
        set(newValue)   { state = newValue.rawValue as NSNumber }
        get             { if let state = state { return ERCertificateState(rawValue: Int(state)) ??  .create } else { return .create } }
    }
    
    var typeValue: ERCertificateType {
        set(newValue)   { type = newValue.rawValue as NSNumber }
        get             { if let type = type { return ERCertificateType(rawValue: Int(type)) ??  .other } else { return .other } }
    }
    
    var verified: Bool {
        return stateValue == .verified
    }
    
    // MARK: - String
    
    var typeString: String {
        return ERCertificateType.stringWith(type: typeValue)
    }
    
    var infoStateString: String? {
        return ERCertificateState.infoStringWith(state: stateValue)
    }
    
    var stateString: String? {
        return ERCertificateState.stringWith(state: stateValue)
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Certificate"
    }
    
}
