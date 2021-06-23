//
//  ERCommunicationManager+EmergencyState.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import Foundation



enum ERCommunicationManagerErrorCodes: Int {
    case    userNotFound = 0,
            organizationNotFound = 1
}

let kERCommunicationManagerErrorDomain = "de.ecoRescue.ERCommunicationManager"

extension ERCommunicationManager {
    
    
    func findAllEmergencyStates(completion: (([EREmergencyState]?, Error?) -> ())? = nil) {
        
        if let user = ERUser.current() {
            
            let predicate = NSPredicate(format: "(state > 2 AND state < 7) OR (createdAt >= %@)", Date().minusMinutes(5) as NSDate)
            
            let query = EREmergencyState.query(with: predicate)!
            query.whereKey("userRelation", equalTo: user)
            query.includeKey("emergencyRelation")
            query.includeKey("emergencyRelation.controlCenterRelation")
            query.includeKey("emergencyRelation.configurationRelation")
            query.includeKey("protocolRelation")
            query.order(byDescending: "createdAt")
            
            query.findObjectsInBackground(block: { (objects, error) in
                if let objects = objects as? [EREmergencyState] {
                    completion?(objects, nil)
                }
            })
            
        } else {
            completion?(nil, ERCommunicationManagerError.userNotFound)
        }
    }
    
    func findEmergencyState(id: String, completion: ((EREmergencyState?, Error?) -> ())? = nil) {
        
        if let user = ERUser.current() {
            
            let query = EREmergencyState.query()!
            query.whereKey("userRelation", equalTo: user)
            query.whereKey("objectId", equalTo: id)
            query.includeKey("emergencyRelation")
            query.includeKey("emergencyRelation.configurationRelation")
            query.includeKey("protocolRelation")
            
            query.getFirstObjectInBackground(block: { (object, error) in
                if let object = object as? EREmergencyState {
                    // Set Received
                    if object.stateValue == .requested {
                        object.stateValue = .received;
                        object.saveInBackground()
                    }
                    completion?(object, nil)
                }
            })
        } else {
            completion?(nil, ERCommunicationManagerError.userNotFound)
        }
    }
    
    func findEmergencyStateBackground(id: String, completion: @escaping ((EREmergencyState?, Error?) -> ()))  {
        
        if let user = ERUser.current() {
            let query = EREmergencyState.query()!
            query.whereKey("userRelation", equalTo: user)
            query.whereKey("objectId", equalTo: id)
            query.includeKey("emergencyRelation")
            query.includeKey("emergencyRelation.configurationRelation")
            query.includeKey("protocolRelation")
            //query.order(byDescending: "createdAt")
            
            do {
                let object = try query.getFirstObject()
                if let object = object as? EREmergencyState {
                    if object.stateValue == .requested {
                        object.stateValue = .received;
                        try object.save()
                        completion(object, nil)
                    }
                    
                }
            } catch  {
                print(error)
            }
            
        } else {
            print(ERCommunicationManagerError.userNotFound)
        }
    }
    
}
