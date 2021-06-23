//
//  ERNotification.swift
//  EcoRescue
//
//  Created by Christoph Erl on 11.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class ERNotification: NSObject {
    
    let identifier: String
    let userInfo:   [AnyHashable: Any]
    
    init(userInfo: [AnyHashable: Any], identifier: String) {
        self.userInfo   = userInfo
        self.identifier = identifier
    }
    
}
