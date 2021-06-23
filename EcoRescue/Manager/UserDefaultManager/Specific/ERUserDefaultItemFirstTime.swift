//
//  ERUserDefaultItemFirstTime.swift
//  EcoRescue
//
//  Created by Christoph Erl on 15.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

class ERUserDefaultItemFirstTime: ERUserDefaultBoolItem {

    init() {
        super.init(defaultBoolValue: true, key: "FirstTime")
    }
    
}
