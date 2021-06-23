//
//  SBUserDefaultItemProtocol.swift
//  Carrera Race
//
//  Created by Christoph Erl on 30.04.16.
//  Copyright © 2016 SB Konzept. All rights reserved.
//

import UIKit

protocol ERUserDefaultItemProtocol: NSObjectProtocol {
    func userDefaultItemDidChangeValue(_ userDefaultItem: ERUserDefaultItem)
}
