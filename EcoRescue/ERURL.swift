//
//  ERURL.swift
//  EcoRescue
//
//  Created by Christoph Erl on 23.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

enum ERURLType {
    case none, legal, contact, faq, impressum, about, project
}

class ERURL: PFObject, PFSubclassing {
    
    @NSManaged var type: String?
    
    @NSManaged var url_eng: String?
    @NSManaged var url_de:  String?
    
    var localizedUrlString: String? {
        return url_de
    }
    
    var urlType: ERURLType {
        switch (type ?? "") {
        case "contact":     return .contact
        case "faq":         return .faq
        case "impressum":   return .impressum
        case "legal":       return .legal
        case "about":       return .about
        case "project":     return .project
        default:            return .none
            
        }
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "URLS"
    }
    
}
