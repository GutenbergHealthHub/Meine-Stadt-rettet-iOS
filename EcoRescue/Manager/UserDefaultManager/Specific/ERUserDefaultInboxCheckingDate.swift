//
//  ERUserDefaultInactivAtDate.swift
//  EcoRescue
//
//  Created by Christoph Erl on 13.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

class ERUserDefaultInboxCheckingDate: ERUserDefaultDateItem {
    
    init() {
        super.init(defaultDateValue: Date(), key: "ERUserDefaultInboxCheckingDate")
    }
    
    func update() {
        dateValue = Date()
    }

}
