
//
//  ERNotificationManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 10.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UserNotifications

protocol ERNotificationManagerDelegate: NSObjectProtocol {
    func notificationManagerDidReceiveEmergencyStateExpired(notificationManager: ERNotificationManager, notificationExpired: ERExpiredEmergencyStateNotification)
    func notificationManagerDidReceiveEmergencyState(notificationManager: ERNotificationManager, notification: EREmergencyStateNotification)
    func notificationManagerDidReceiveUpdateEmergencyState(notificationManager: ERNotificationManager)
    func notificationManagerDidReceiveUpdateUser(notificationManager: ERNotificationManager)
    
    func notificationManagerDidReceiveCancelEmergency(notificationManager: ERNotificationManager, notification: ERCancelEmergencyNotification)
    
    // Service
    func notificationManagerDidReceiveServicePauseEnded(notificationManager: ERNotificationManager, notification: EREndedServicePauseNotification)
    
    // Background - Inactive
    func notificationManagerDidReceiveEmergencyStateBackground(notificationManager: ERNotificationManager, notification: EREmergencyStateNotification)
}

// Enum

enum ERNotificationManagerType {
    case unknown, emergencyState, updateUser, updateEmergencyState
}

class ERNotificationManager: NSObject {
    
    static let shared = ERNotificationManager()
    
    var delegate: ERNotificationManagerDelegate?
    
    // Managers
    private let notificationManager  = UNUserNotificationCenter.current()
    private let communicationManager = ERCommunicationManager.sharedManager
    
    // Notifications
    private var emergencyStateExpiredIdentifiers    = [String]()
    private var emergencyStates                     = [EREmergencyState]()

    
    // MARK: - Handle Notifications
    
    func handleSilentRemote(userInfo: [AnyHashable: Any]?) {
        let notification = p_notificationFrom(userInfo: userInfo)
        if let notification = notification as? EREmergencyStateNotification {
            delegate?.notificationManagerDidReceiveEmergencyStateBackground(notificationManager: self, notification: notification)
        } else if let notification = notification as? ERCancelEmergencyNotification {
            //delegate?.notificationManagerDidReceiveCancelEmergency(notificationManager: self, notification: notification)
            removeNotificationDelivered(with: notification.emergencyStateId)
            
        } else if let _ = notification as? ERUpdateUserNotification {
            delegate?.notificationManagerDidReceiveUpdateUser(notificationManager: self)
        }
    }
    
    func handle(userInfo: [AnyHashable: Any]?) -> UNNotificationPresentationOptions {
        let notification = p_notificationFrom(userInfo: userInfo)
        
        if let notification = notification as? EREmergencyStateNotification {
            delegate?.notificationManagerDidReceiveEmergencyState(notificationManager: self, notification: notification)
            return []
        } else if let notification = notification as? ERCancelEmergencyNotification {
            delegate?.notificationManagerDidReceiveCancelEmergency(notificationManager: self, notification: notification)
            return []
        } else if let notification = notification as? ERExpiredEmergencyStateNotification {
            delegate?.notificationManagerDidReceiveEmergencyStateExpired(notificationManager: self, notificationExpired: notification)
            return []
        } else if let notification = notification as? EREndedServicePauseNotification {
            delegate?.notificationManagerDidReceiveServicePauseEnded(notificationManager: self, notification: notification)
            return []
        }
        
        return []
    }

    // MARK: - Fire & Cancel Notifications
    
    func fireEmergencyState() {
        let content = UNMutableNotificationContent()
        content.body    = "Test"
        
        let request = UNNotificationRequest(identifier: "Test", content: content, trigger: nil)
        
        notificationManager.add(request) { (error) in if let error = error { print(error) } }
    }
    
    func fireEmergencyStateExpiredFor(ergencyStates: [EREmergencyState]) {
        for ergencyStates in ergencyStates {
            p_fireEmergencyStateExpired(ergencyState: ergencyStates)
        }
    }
    
    func triggerEmergencyExpired(for state: EREmergencyState) {
        let content  = UNMutableNotificationContent()
        content.body = String.RECEIVED_EMERGENCY_IS_EXPIRED
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: state.timeIntervalUntilExpired, repeats: false)
        let request = UNNotificationRequest(identifier: "ExpiredEmergency", content: content, trigger: trigger)
        
        notificationManager.add(request) { (error) in if let error = error { print(error) } }
        
        ERUserDefaultManager.userDefaultMissedEmergencyId.stringValue = state.objectId ?? ""
    }
    
    func removeNotificationDelivered(with emergencyId: String) {
        notificationManager.getDeliveredNotifications { notifications in
            let matching = notifications.last(where: { notify in
                let existingUserInfo = notify.request.content.userInfo
                let id = existingUserInfo["emergencyStateId"] as? String
                return id == emergencyId
            })
            if let matchExists = matching {
                UNUserNotificationCenter.current().removeDeliveredNotifications(
                    withIdentifiers: [matchExists.request.identifier]
                )
            }
        }
        ERUserDefaultManager.userDefaultMissedEmergencyId.stringValue = ""
        notificationManager.removePendingNotificationRequests(withIdentifiers: ["ExpiredEmergency"])
    }
    
    private func p_fireEmergencyStateExpired(ergencyState: EREmergencyState) {
        let notification = ERExpiredEmergencyStateNotification(emergencyStateId: ergencyState.objectId!)
        
        let content = UNMutableNotificationContent()
        content.body        = String.RECEIVED_EMERGENCY_IS_EXPIRED
        content.userInfo    = notification.userInfo
                
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: ergencyState.timeIntervalUntilExpired, repeats: false)
        let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)
        
        notificationManager.add(request) { (error) in if let error = error { print(error) } }
        
        // Add to list
        emergencyStates.append(ergencyState)
        emergencyStateExpiredIdentifiers.append(request.identifier)
    }
    
    func cancelAllPendingNotificationRequests() {
        notificationManager.removeAllPendingNotificationRequests()
    }
    
    func cancelEmergencyStateExpired() {
        notificationManager.removePendingNotificationRequests(withIdentifiers: emergencyStateExpiredIdentifiers)
        
        emergencyStates.removeAll()
        emergencyStateExpiredIdentifiers.removeAll()
    }
    
    func fireServicePausesEnded(date: Date) {
        let notification = EREndedServicePauseNotification()
        
        let content = UNMutableNotificationContent()
        content.body        = String.YOU_ARE_ON_DUTY_AGAIN
        content.userInfo    = notification.userInfo
    
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month, .year], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: EREndedServicePauseNotification.identifier, content: content, trigger: trigger)
        
        notificationManager.add(request) { (error) in if let error = error { print(error) } }
    }
    
    func cancelServicePausesEnded() {
        notificationManager.removePendingNotificationRequests(withIdentifiers: [EREndedServicePauseNotification.identifier])
    }
    
    func fireEmergencyStatePushy() {
        let notification = EREmergencyStatePushyNotification()
        
        let content = UNMutableNotificationContent()
        content.body        = String.YOU_ARE_ON_DUTY_AGAIN
        content.userInfo    = notification.userInfo
        content.sound       = UNNotificationSound(named: ERUser.current()?.sound ?? "")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: true)
        let request = UNNotificationRequest(identifier: EREmergencyStatePushyNotification.identifier, content: content, trigger: trigger)
        
        notificationManager.add(request) { (error) in if let error = error { print(error) } }
    }
    
    func cancelEmergencyStatePushy() {
        notificationManager.removePendingNotificationRequests(withIdentifiers: [EREmergencyStatePushyNotification.identifier])
    }
    
    // MARK: - Private Helper Methods
    
    private func p_notificationFrom(userInfo: [AnyHashable: Any]?) -> ERNotification? {
        print(userInfo)
        if let notification = EREmergencyStateNotification(userInfo: userInfo) {
            return notification
        } else if let notification = ERExpiredEmergencyStateNotification(userInfo: userInfo) {
            return notification
        } else if let notification = EREndedServicePauseNotification(userInfo: userInfo) {
            return notification
        } else if let notification = ERUpdateUserNotification(userInfo: userInfo) {
            return notification
        } else if let notification = ERCancelEmergencyNotification(userInfo: userInfo) {
            return notification
        }
        return nil
    }

}
