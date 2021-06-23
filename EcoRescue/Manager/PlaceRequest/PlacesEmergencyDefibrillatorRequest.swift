//
//  PlacesEmergencyDefibrillatorRequest.swift
//  EcoRescue
//
//  Created by Birtan on 16.05.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class PlacesEmergencyDefibrillatorRequest: PlacesRequest {
    
    override func requestPlaces(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, location: CLLocationCoordinate2D, completion: @escaping ([NSObject]?, Error?) -> ()) {
        //let geopointSW = PFGeoPoint(latitude: southWest.latitude, longitude: southWest.longitude)
        //let geopointNE = PFGeoPoint(latitude: northEast.latitude, longitude: northEast.longitude)
        
        //let centerCoordinate = southWest.middleLocationWith(location: northEast)
        let centerGeoPoint   = PFGeoPoint(latitude: location.latitude, longitude: location.longitude)
        
        let defibrillatorQuery = ERDefibrillator.query()!
        defibrillatorQuery.whereKey("activated", equalTo: NSNumber(value: true))
        defibrillatorQuery.whereKey("location", nearGeoPoint: centerGeoPoint, withinKilometers: 5)
        defibrillatorQuery.findObjectsInBackground { (objects, error) in
            
            if let defibrillators = objects as? [ERDefibrillator] {
                completion(defibrillators, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    override func cancel() {
        
    }
}

private extension CLLocationCoordinate2D {
    // MARK: CLLocationCoordinate2D+MidPoint
    func middleLocationWith(location:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let lon1 = longitude * .pi / 180
        let lon2 = location.longitude * .pi / 180
        let lat1 = latitude * .pi / 180
        let lat2 = location.latitude * .pi / 180
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / .pi, lon3 * 180 / .pi)
        return center
    }
}
