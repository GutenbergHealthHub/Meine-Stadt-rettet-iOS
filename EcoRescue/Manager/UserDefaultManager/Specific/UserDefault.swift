//
//  UserDefault.swift
//  EcoRescue
//
//  Created by Christoph Erl on 04.04.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class UserDefault: NSObject {
    
    static let isFirstTimeNotificationAuthorization   = ERUserDefaultBoolItem(defaultBoolValue: true, key: "FirstTimeNotificationAuthorization")
    static let isFirstTimeLocationAuthorization       = ERUserDefaultBoolItem(defaultBoolValue: true, key: "firstTimeLocationAuthorization")
    static let isFirstTimeIntro                       = ERUserDefaultBoolItem(defaultBoolValue: true, key: "FirstTimeIntro")
    
}
