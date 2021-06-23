//
//  Production.swift
//  EcoRescue
//
//  Created by Christoph Erl on 24.04.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

enum EnvironmentMode {
    case development, production
}

class Environment: NSObject {
    
    static var mode = EnvironmentMode.development { didSet { p_setMode(oldValue: oldValue) } }
    
    // MARK: - Computed Variables
    
    static var baseURLString: String {
        switch mode {
        case .development:  return ""
        case .production:   return ""
        }
    }
    
    static var applicationIdString: String {
        switch mode {
        case .development:  return ""
        case .production:   return ""
        }
    }
    
    static var clientKeyString: String {
        switch mode {
        case .development:  return ""
        case .production:   return ""
        }
    }
    
    // MARK: - Private Methods
    
    private static func p_setMode(oldValue: EnvironmentMode) {
        if mode == oldValue { return }
        
    }
    
    let kERCommunicationApplicationIDString     = ""
    let kERCommunicationClientKeyString         = ""
    
}
