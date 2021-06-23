//
//  ERLocationHelper.swift
//  EcoRescue
//
//  Created by Christoph Erl on 06.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation

class ERLocationHelper: NSObject, CLLocationManagerDelegate {
    
    fileprivate let locationManager = CLLocationManager()
    fileprivate var location: CLLocation?
    
    fileprivate var reading: Bool = false
    
    override init() {
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        locationManager.distanceFilter  = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        super.init()
        
        locationManager.delegate = self
    }

    func readLocation(_ completion: @escaping ((_ location: CLLocation?) -> ())) {
        //if reading
        
        location = nil
        locationManager.startUpdatingLocation()
        
        DispatchQueue.global(qos: .background).async {
            while self.location == nil {
                sleep(1);
                print("Requesting Location...")
            }
            self.locationManager.stopUpdatingLocation()
            
            DispatchQueue.main.async {
                completion(self.location)
            }
        }
    }

    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Log.e("ERBackgroundLocationManager - didFailWithError: \(error)")
    }
    
}
