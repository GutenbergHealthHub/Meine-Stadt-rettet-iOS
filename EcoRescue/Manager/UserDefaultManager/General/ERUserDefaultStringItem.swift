//
//  CEUserDefaultStringItem.swift
//  iHungry
//
//  Created by Christoph Erl on 26.05.16.
//  Copyright © 2016 FutureBusinessLabs. All rights reserved.
//

import UIKit

class ERUserDefaultStringItem: ERUserDefaultItem {
    
    var stringValue: String          { set { p_setValue(newValue) } get { return p_getValue() } }
    
    init(defaultStringValue: String, key: String) {
        super.init(defaultValue: defaultStringValue as ERUserDefaultItem.Element, key: key)
    }
    
    // MARK: - Public Methods
    
    // MARK: - Private Methods
    
    fileprivate func p_setValue(_ value: String) {
        self.value = NSString(string: value)
    }
    
    fileprivate func p_getValue() -> String {
        return self.value as! String
    }

}
