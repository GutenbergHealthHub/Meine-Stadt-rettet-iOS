//
//  ERProtocol.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERProtocol: PFObject, PFSubclassing {
    
    @NSManaged var done: NSNumber?
    
    @NSManaged var startMinutesRelAmbulance:    NSNumber?
    @NSManaged var startLaterRelAmbulance:      NSNumber?
    
    @NSManaged var startLocationValueN:      NSNumber?
    @NSManaged var startDiagnoseValue:      NSArray?
    @NSManaged var startReactionValue:      NSArray?
    @NSManaged var startOrientationValueN:   NSNumber?
    @NSManaged var startRespirationValue:   NSArray?
    
    //@NSManaged var startPupilLeft:   String?
    //@NSManaged var startPupilRight:   String?
    
    @NSManaged var age: NSNumber?
    @NSManaged var ageCategory: NSNumber?
    
    @NSManaged var sex: String?
    @NSManaged var reanimationValue: NSNumber?
    @NSManaged var schoolBuilding: NSNumber?
    @NSManaged var relationWithSport: NSNumber?
    
    //@NSManaged var measureMeasureValue:             NSArray?
    //@NSManaged var measureBreathDonationValue:      NSArray?
    @NSManaged var measureChestCompressionValueN:    NSNumber?
    @NSManaged var measureDefiValueN:                NSNumber?
    
    //@NSManaged var measureDefiPulseCount:           NSNumber?
    @NSManaged var measureDefiShockCount:           NSNumber?
    //@NSManaged var measureDefiSuccess:              NSNumber?
    //@NSManaged var measureDefiPhase:                String?
    
    @NSManaged var collapseObserved: NSNumber?
    @NSManaged var measureRespirationValue: NSNumber?
    @NSManaged var telemedicin: NSNumber?
    @NSManaged var producerDefiValue: NSNumber?
    @NSManaged var codeDefiValue: NSNumber?
    @NSManaged var publicDefi: NSNumber?
    
    @NSManaged var endStatusA:   NSArray?
    @NSManaged var endRespirationValue:   NSArray?
    @NSManaged var endComment:   String?
    
    @NSManaged var cancelComment:   String?
    
    var isDone: Bool {
        set(newValue)   { done = NSNumber(value: newValue as Bool) }
        get             { return done?.boolValue ?? false }
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Protocol"
    }
    
}
