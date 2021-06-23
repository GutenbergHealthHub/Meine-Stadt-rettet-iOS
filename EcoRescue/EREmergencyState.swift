//
//  EREmergencyState.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

enum EREmergencyStateState: Int {
    case    requested   = 0,
    received    = 1,
    ready       = 2,
    accepted    = 3,
    arrived     = 4,
    cancelled   = 5,
    finished    = 6,
    callback    = 7
}

enum EREmergencyTaskState: Int {
    case firstResponder = 0,
    getAED = 1,
    voluntary = 2
}

let kEREmergencyStateLocationTracking = "locationTracking"

class EREmergencyState: PFObject, PFSubclassing {
    
    @NSManaged var state:   NSNumber
    @NSManaged var visible: NSNumber
    
    @NSManaged var acceptedAt:          Date?
    @NSManaged var endedAt:             Date?
    @NSManaged var arrivedAt:           Date?
    
    @NSManaged var maxRadius:           NSNumber?
    @NSManaged var emergencyTask:       NSNumber?
    
    @NSManaged var emergencyRelation:   EREmergency!
    @NSManaged var userRelation:        ERUser
    @NSManaged var protocolRelation:    ERProtocol?
    
    var missionExpired: Bool {
        return emergencyRelation != nil && emergencyRelation!.expired
    }
    
    var timeIntervalUntilExpired: TimeInterval {
        return emergencyRelation.timeIntervalUntilExpired
    }
    
    var missionAccepted: Bool {
        let state = stateValue
        return state == .accepted || state == .arrived || missionFinished
    }
    
    var missionFinished: Bool {
        let state = stateValue
        return state == .cancelled || state == .finished
    }
    
    var missionCallback: Bool {
        return stateValue == .callback
    }
    
    var missionReachable: Bool {
        if let uLoc = ERUser.current()?.location, let eLoc = emergencyRelation.locationPoint, let config = emergencyRelation.configurationRelation {
            return uLoc.distanceInKilometers(to: eLoc) * 1000 < config.distanceValue ?? 3
        }
        return true
    }
    
    var missionFinishedWithSuccess: Bool {
        let state = stateValue
        return state == .finished
    }
    
    var missionFinishedWithFailure: Bool {
        let state = stateValue
        return state == .cancelled
    }
    
    var stateValue: EREmergencyStateState {
        set(newValue)   { p_setStateValue(newValue: newValue) }
        get             { return EREmergencyStateState(rawValue: state.intValue)! }
    }
    
    var stateColor: UIColor {
        
        switch stateValue {
        case .requested, .received, .ready: return UIColor.coloriOS
        case .accepted, .arrived:           return UIColor.neutral
        case .cancelled:                    return UIColor.negativ
        case .finished:                     return UIColor.positive
        case .callback:                     return UIColor.negativ
        }
    }
    
    var stateDescription: String? {
        
        switch stateValue {
        case .requested, .received, .ready: return String.SERVICE_REQUESTED
        case .accepted, .arrived:           return String.YOU_ACCEPTED
        case .cancelled:                    return String.YOU_CANCELLED
        case .finished:                     return String.YOU_FINISHED
        case .callback:                     return String.EMERGENCY_UNIT_CANCELLED_THE_MISSION
        }
    }
    
    var stateDescriptionShort: String? {
        
        switch stateValue {
        case .requested, .received, .ready: return String.SERVICE_REQUESTED
        case .accepted, .arrived:           return String.ACCEPTED
        case .cancelled:                    return String.CANCELLED
        case .finished:                     return String.FINISHED
        case .callback:                     return String.CANCELLED
        }
    }
    
    var emergencyTaskValue: EREmergencyTaskState {
        
        if let emergencyTask = emergencyTask {
            return EREmergencyTaskState(rawValue: Int(emergencyTask))!
        } else {
            return EREmergencyTaskState.firstResponder
        }
    }
    
    var emergencyTaskDescription: String {
        switch emergencyTaskValue {
        case .firstResponder:
            return String.FIRST_RESPONDER_TASK_INFO
        case .getAED:
            return String.GET_AED_TASK_INFO
        case .voluntary:
            return ""
        }
    }
    
    var protocolDone: Bool {
        return protocolRelation?.isDone ?? false
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "EmergencyState"
    }
    
    // MARK: - Private Method
    
    private func p_setStateValue(newValue: EREmergencyStateState) {
        if newValue == .cancelled || newValue == .finished {
            endedAt = Date()
        } else {
            endedAt = nil
        }
        
        if newValue == .accepted {
            acceptedAt = Date()
        }
        
        state = NSNumber(value: newValue.rawValue)
    }
    
}
