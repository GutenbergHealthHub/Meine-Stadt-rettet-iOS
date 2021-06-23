//
//  AuthorizationManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 19.03.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

import CoreLocation
import UserNotifications

enum ResponderState {
    case inactive, active, paused, notComplete
}

class ResponderStateManager: NSObject {
    
    static let shared = ResponderStateManager()
    
    private override init() {}
    
    // MARK: - Single Items
    
    func isNotificationAuthorized(completion: @escaping (Bool) -> ()) {
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { (settings) in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        })
    }
    
    var isLocationServicesEnabled: Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
    var isLocationAccessAuthorized: Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways
    }
    
    var isPhoneNumberValid: Bool {
        if let user = ERUser.current() {
            return user.phoneNumber != nil && user.phoneCode != nil
        }
        return false
    }
    
    var isPinCodeValid: Bool {
        if let user = ERUser.current() {
            return !String.isEmpty(string: user.code)
        }
        return false
    }
    
    var isBirthdateValid: Bool {
        if let user = ERUser.current() {
            return user.birthdate != nil
        }
        return false
    }
    
    var isAddressValid: Bool {
        if let user = ERUser.current() {
            return !String.isEmpty(string: user.thoroughfare) && !String.isEmpty(string: user.subThoroughfare) && !String.isEmpty(string: user.city) && !String.isEmpty(string: user.zip)
        }
        return false
    }
    
    var isProfessionValid: Bool {
        if let user = ERUser.current() {
            return !String.isEmpty(string: user.profession)
        }
        return false
    }
    
    var isUserContractBasicValid: Bool {
        if let user = ERUser.current(), let userContractBasic = user.userContractBasic, let contractBasic = userContractBasic.contract {
            return contractBasic.valid && userContractBasic.stateValue == .signed
        }
        return false
    }
    
    var isCertificateFRValid: Bool {
        if let user = ERUser.current(), let certificateFR = user.certificateFR {
            return certificateFR.verified
        }
        return false
    }
    
    var isServiceActive: Bool {
        guard let user = ERUser.current() else {
            return false
        }
        
        if !isLocationServicesEnabled || !ERConnectionManager.isInternetAvailable() {
            return false
        }
        
        if let dutyOff = user.dutyOff {
            if !dutyOff.boolValue {
                if let _ = user.dutyDays {
                    return !Date().isOnSameDay(days: user.dutyDays as! [Int])
                } else if let to = user.dutyTo, let from = user.dutyFrom {
                    return !Date().isTimeBetween(from: from, to: to)
                }
                return true
            }
            return false
        }
        
        if let pausedUntil = user.pausedUntil {
            return Date().isGreaterThan(pausedUntil)
        }
        
        return false
    }
    
    // MARK: - Grouped Items
    
    func getState(completion: @escaping (ResponderState) -> ()) {
        isRequirementFulfilled { (fulfilled) in
            if fulfilled {
                completion(self.isServiceActive ? .active : .inactive)
            } else {
                return completion(.notComplete)
            }
        }
    }
    
    func isAuthorizationFulfilled(completion: @escaping (Bool) -> ()) {
        isNotificationAuthorized { (notificationAuthorized) in
            completion(notificationAuthorized && self.isLocationAccessAuthorized)
        }
    }
    
    func isRequirementFulfilled(completion: @escaping (Bool) -> ()) {
        isAuthorizationFulfilled { (authorizationFulfilled) in
            completion(authorizationFulfilled && self.isCertificateFRValid && self.isUserContractBasicValid && self.isPersonalSettingsValid)
        }
    }
    
    var isPersonalSettingsValid: Bool {
        return isPhoneNumberValid && isPinCodeValid && isAddressValid && isBirthdateValid && isProfessionValid
    }
    
    func getNumberOfNotFulfilledRequirements(completion: @escaping (Int) -> ()) {
        var result = 0
        isNotificationAuthorized { (notificationAuthorized) in
            result += notificationAuthorized            ? 0 : 1
            result += self.isUserContractBasicValid     ? 0 : 1
            result += self.isCertificateFRValid         ? 0 : 1
            result += self.isLocationAccessAuthorized   ? 0 : 1
            result += self.isAddressValid               ? 0 : 1
            result += self.isPinCodeValid               ? 0 : 1
            result += self.isBirthdateValid             ? 0 : 1
            result += self.isProfessionValid            ? 0 : 1
            result += self.isBirthdateValid             ? 0 : 1
            completion(result)
        }
    }
    
    // MARK: - UI
    
    class func getColor(responderState: ResponderState) -> UIColor {
        switch responderState {
            case .active:   return UIColor.positive
            case .inactive: return UIColor.neutral
            case .paused:   return UIColor.neutral
            case .notComplete: return UIColor.negativ
        }
    }
    
}
