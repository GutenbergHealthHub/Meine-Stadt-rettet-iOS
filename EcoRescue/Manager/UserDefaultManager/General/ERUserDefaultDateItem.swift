//
//  ERUserDefaultDateItem.swift
//  EcoRescue
//
//  Created by Christoph Erl on 04.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

class ERUserDefaultDateItem: ERUserDefaultItem {

    var dateValue: Date          { set { p_setValue(newValue: newValue) } get { return p_getValue() } }
    
    init(defaultDateValue: Date, key: String) {
        super.init(defaultValue: defaultDateValue as NSDate, key: key)
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setValue(newValue: Date) {
        self.value = newValue as NSDate
    }
    
    fileprivate func p_getValue() -> Date {
        return (self.value as! NSDate) as Date
    }
    
}
