//
//  SBUserDefaultManager.swift
//  Carrera Race
//
//  Created by Christoph Erl on 30.04.16.
//  Copyright © 2016 SB Konzept. All rights reserved.
//

import UIKit

class ERUserDefaultManager: NSObject {
    
    static let userDefaultDatabaseVersion      = ERUserDefaultItemDatabaseVersion()
    static let userDefaultInboxCheckingDate    = ERUserDefaultInboxCheckingDate()
    static let userDefaultUsername             = ERUserDefaultItemUsername()
    static let userDefaultFirstTime            = ERUserDefaultItemFirstTime()
    static let userDefaultLastTimeActive       = ERUserDefaultLastTimeActive()
    static let userDefaultUsesTouchID          = ERUserDefaultItemUsesTouchID()
    
    static let userDefaultMapShowDefi           = ERUserDefaultItemMapShowDefis()
    static let userDefaultMapShowHospitals      = ERUserDefaultItemMapShowHospitals()
    static let userDefaultMapShowFirehouses     = ERUserDefaultItemMapShowFirehouses()
    static let userDefaultMapShowDoctors        = ERUserDefaultItemMapShowDoctors()
    static let userDefaultMapShowDentists       = ERUserDefaultItemMapShowDentists()
    static let userDefaultMapShowPharmacies     = ERUserDefaultItemMapShowPharmacies()
    static let userDefaultUserObjectId          = ERUserDefaultItemUserObjectId()
    static let userDefaultMissedEmergencyId     = ERUserDefaultMissedEmergencyId()

}
