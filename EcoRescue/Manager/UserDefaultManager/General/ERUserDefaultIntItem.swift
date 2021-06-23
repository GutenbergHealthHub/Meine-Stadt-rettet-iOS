//
//  SB2UserDefaultIntItem.swift
//  Carrera Race
//
//  Created by Christoph Erl on 30.04.16.
//  Copyright © 2016 SB Konzept. All rights reserved.
//

import UIKit

class ERUserDefaultIntItem: ERUserDefaultItem {
    
    var intValue: Int          { set { p_setValue(newValue) } get { return p_getValue() } }
    
    init(defaultIntValue: Int, key: String) {
        super.init(defaultValue: NSNumber(value: defaultIntValue as Int), key: key)
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setValue(_ value: Int) {
        self.value = NSNumber(value: value as Int)
    }
    
    fileprivate func p_getValue() -> Int {
        return (self.value as! NSNumber).intValue
    }

}
