//
//  ERUserDefaultLastTimeActive.swift
//  EcoRescue
//
//  Created by Christoph Erl on 29.10.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

class ERUserDefaultLastTimeActive: ERUserDefaultDateItem {
    
    let kERTimeIntervalUntilPinCodeRequest: TimeInterval = 0.01 * 60
    
    init() {
        super.init(defaultDateValue: Date(), key: "LastTimeActive")
    }
    
    func update() {
        print(dateValue)
        dateValue = Date()
    }
    
    func pinCodeRequestNeeded() -> Bool {
        return NSDate().timeIntervalSince(dateValue) > kERTimeIntervalUntilPinCodeRequest
    }
    
}

