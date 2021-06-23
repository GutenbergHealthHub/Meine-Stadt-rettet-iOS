//
//  SB2UserDefaultFloatItem.swift
//  Carrera Race
//
//  Created by Christoph Erl on 30.04.16.
//  Copyright © 2016 SB Konzept. All rights reserved.
//

import UIKit

class ERUserDefaultFloatItem: ERUserDefaultItem {
    
    var floatValue: Float          { set { p_setValue(newValue) } get { return p_getValue() } }
    
    init(defaultFloatValue: Float, key: String) {
        super.init(defaultValue: NSNumber(value: defaultFloatValue as Float), key: key)
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setValue(_ value: Float) {
        self.value = NSNumber(value: value as Float)
    }
    
    fileprivate func p_getValue() -> Float {
        return (self.value as! NSNumber).floatValue
    }

}
