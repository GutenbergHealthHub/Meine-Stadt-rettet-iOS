//
//  ERDataEvaluationManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 24.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

protocol ERDataEmergencyStateManagerDelegate {
    func dataEmergencyStateManagerShouldUpdateLocation(_ dataEmergencyStateManager: ERDataEmergencyStateManager)
}

class ERDataEmergencyStateManager: NSObject, CLLocationManagerDelegate {
    
    var delegate: ERDataEmergencyStateManagerDelegate?

    var state: EREmergencyStateState { set { p_setState(newValue) } get { return emergencyState.stateValue } }
    
    fileprivate var timer:      Timer?
    fileprivate var location:   CLLocation? { didSet { p_setLocation(oldValue) } }
    
    // Managers
    fileprivate let communicationManager    = ERCommunicationManager.sharedManager
    fileprivate var locationManager:        CLLocationManager?
    
    // Model
    let emergencyState: EREmergencyState
    
    init(emergencyState: EREmergencyState) {
        self.emergencyState = emergencyState
    
        super.init()
        p_updateStatus()
    }
    
    deinit {
        print("ERDataEvaluationManager deinit")
    }
    
    // MARK: - Public Methods
    
    func invalidate() {
        p_stopTimer()
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setState(_ newValue: EREmergencyStateState) {
        if newValue == state { return }
        
        emergencyState.stateValue = newValue
        emergencyState.saveInBackground()
        
        p_updateStatus()
    }
    
    fileprivate func p_updateStatus() {
        switch state {
            
        case .accepted, .arrived:
            p_startTimer()
            break
            
        case .cancelled:
            p_stopTimer()
            break
            
        case .finished:
            p_stopTimer()
            break
            
        case .requested, .received, .ready, .callback:
            p_stopTimer()
            break
        }
    }
    
    // MARK: - Timer
    
    fileprivate func p_startTimer() {
        p_stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: kUpdateInterval, target: self, selector: #selector(ERDataEmergencyStateManager.p_timerTask), userInfo: nil, repeats: true)
        p_timerTask()
        
        // Init Location Manager
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            
            locationManager!.allowsBackgroundLocationUpdates = true
            locationManager!.delegate = self
            
            locationManager!.startUpdatingLocation()
        }
    }
    
    fileprivate func p_stopTimer() {
        timer?.invalidate()
        timer = nil
        
        if let locationManager = locationManager {
            locationManager.stopUpdatingLocation()
        }
    }
    
    func p_timerTask() {
        p_updateLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    fileprivate let kUpdateInterval     = 30.0
    fileprivate let kArrivalDistance    = 25.0
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    fileprivate func p_updateLocation() {
        if let location = location {
            // User Location
            communicationManager.updateUserLocation(location)
            
            // Timestamp
            let timestamp = ERLocationTracking()
            timestamp.location = PFGeoPoint(location: location)
            timestamp.emergencyStateRelation = emergencyState
            timestamp.saveInBackground()
            
            // Arrival Time
            if emergencyState.stateValue == .accepted {
                if let emergencyLocation = emergencyState.emergencyRelation.locationPoint?.location {
                    if abs(emergencyLocation.distance(from: location)) < kArrivalDistance {
                        emergencyState.stateValue = .arrived
                        emergencyState.arrivedAt = Date()
                    }
                }
                emergencyState.saveInBackground()
            }
        }
    }
    
    fileprivate func p_setLocation(_ oldValue: CLLocation?) {
        if location == oldValue { return }
        
        if oldValue == nil && location != nil { // First Time
            p_updateLocation()
        }
    }
    
}
