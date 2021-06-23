//
//  SB2UserDefaultBoolItem.swift
//  Carrera Race
//
//  Created by Christoph Erl on 30.04.16.
//  Copyright © 2016 SB Konzept. All rights reserved.
//

import UIKit

class ERUserDefaultBoolItem: ERUserDefaultItem {
    
    var boolValue: Bool          { set { p_setValue(newValue) } get { return p_getValue() } }

    init(defaultBoolValue: Bool, key: String) {
        super.init(defaultValue: NSNumber(value: defaultBoolValue as Bool), key: key)
    }
    
    // MARK: - Public Methods
    
    func toggle() {
        let newValue = !boolValue
        self.boolValue = newValue
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setValue(_ value: Bool) {
        self.value = NSNumber(value: value as Bool)
    }
    
    fileprivate func p_getValue() -> Bool {
        return (self.value as! NSNumber).boolValue
    }
    
}
