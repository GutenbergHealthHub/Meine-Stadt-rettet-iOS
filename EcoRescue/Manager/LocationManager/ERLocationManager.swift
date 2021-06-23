//
//  ERBackgroundLocationManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 06.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation

class ERLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = ERLocationManager()
    
    var emergencyRunning: Bool = false { didSet { p_setEmergencyRunning(oldValue: oldValue) } }
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var timer: Timer?
    
    fileprivate var location: CLLocation?
    
    fileprivate let communicationManager = ERCommunicationManager.sharedManager
    
    override init() {
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.delegate = self
        
        //p_setEmergencyRunning()
    }
    
    // MARK: - Public Methods

    func startUpdatingLocation() {
        startTimer()
    }
    
    func stopUpdatingLocation() {
        stopTimer()
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    fileprivate let kUpdateAfterTimeout = 60.0 * 30
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.e("ERBackgroundLocationManager - didFailWithError: \(error)")
    }
    
    // MARK: - Timer
    
    fileprivate func startTimer() {
        stopTimer()
        
        timer = Timer.scheduledTimer(timeInterval: kUpdateAfterTimeout, target: self, selector: #selector(timerTask), userInfo: nil, repeats: true)
        
        locationManager.startUpdatingLocation()
        
        timerTask()
    }
    
    fileprivate func stopTimer() {
        locationManager.stopUpdatingLocation()
        
        timer?.invalidate()
        timer = nil
    }
    
    func timerTask() {
        if let location = location { communicationManager.updateUserLocation(location) }
    }
    
    // MARK: - Private Methods 
    
    private func p_setEmergencyRunning(oldValue: Bool) {
        if oldValue == emergencyRunning { return }
        p_setEmergencyRunning()
    }
    
    private func p_setEmergencyRunning() {
        // Stop Updating Location
        locationManager.stopUpdatingLocation()
        /*
        // Set Accurray & Restart Updating Location
        if !emergencyRunning {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
 */
    }
    
}
