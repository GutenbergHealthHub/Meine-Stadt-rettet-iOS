//
//  ERUserDefaultItemDatabaseVersion.swift
//  EcoRescue
//
//  Created by Christoph Erl on 04.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

private let kERUserDefaultItemDatabaseVersion = "ERUserDefaultItemDatabaseVersion"

class ERUserDefaultItemDatabaseVersion: ERUserDefaultIntItem {
    
    init() {
        super.init(defaultIntValue: 0, key: kERUserDefaultItemDatabaseVersion)
    }
    
    func incrementVersion() {
        intValue = intValue + 1
    }

}
