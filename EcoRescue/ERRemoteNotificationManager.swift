//
//  ERRemoteNotificationManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 11.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

protocol ERRemoteNotificationManagerDelegate {
    func remoteNotificationManager(remoteNotificationManager: ERRemoteNotificationManager, didReceiveEmergencyState emergencyStateInformation: [NSObject: AnyObject], configInfo: [NSObject: AnyObject])
    func remoteNotificationManager(remoteNotificationManager: ERRemoteNotificationManager, didReceiveEvent eventInformation: [NSObject: AnyObject])
}

class ERRemoteNotificationManager: NSObject {
    
    var delegate: ERRemoteNotificationManagerDelegate?
    
    static let sharedManager = ERRemoteNotificationManager()
    
    // MARK: - Initialise
    
    override init() {
        super.init()
    }

    func handlePush(push: [NSObject : AnyObject]) {
        p_handleEmergencyPush(push)
    }
    
    // MARK: - Private Methods
    
    private func p_handleEmergencyPush(push: [NSObject : AnyObject]) {
        if let stateInfo = push["emergencyState"] as? [NSObject : AnyObject], let configInfo = push["config"] as? [NSObject : AnyObject] {
            delegate?.remoteNotificationManager(self, didReceiveEmergencyState: stateInfo, configInfo: configInfo)
        } else if let eventInfo = push["event"] as? [NSObject : AnyObject] {
            delegate?.remoteNotificationManager(self, didReceiveEvent: eventInfo)
        }
    }
    
}
