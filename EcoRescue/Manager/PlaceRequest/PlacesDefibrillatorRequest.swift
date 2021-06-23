//
//  PlacesDefibrillatorRequest.swift
//  EcoRescue
//
//  Created by Christoph Erl on 27.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse
import CoreLocation
import MapKit

class PlacesDefibrillatorRequest: PlacesRequest {
    
    override func requestPlaces(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, completion: @escaping ([NSObject]?, Error?) -> ()) {
        //let geopointSW = PFGeoPoint(latitude: southWest.latitude, longitude: southWest.longitude)
        //let geopointNE = PFGeoPoint(latitude: northEast.latitude, longitude: northEast.longitude)
        
        let centerCoordinate = southWest.middleLocationWith(location: northEast)
        let centerGeoPoint   = PFGeoPoint(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)

        let defibrillatorQuery = ERDefibrillator.query()!
        defibrillatorQuery.whereKey("activated", equalTo: NSNumber(value: true))
        defibrillatorQuery.limit = 30
        defibrillatorQuery.whereKey("location", nearGeoPoint: centerGeoPoint)
        //defibrillatorQuery.whereKey("location", withinGeoBoxFromSouthwest: geopointSW, toNortheast: geopointNE)
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
        
        let lon1 = longitude * M_PI / 180
        let lon2 = location.longitude * M_PI / 180
        let lat1 = latitude * M_PI / 180
        let lat2 = location.latitude * M_PI / 180
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / M_PI, lon3 * 180 / M_PI)
        return center
    }
}
