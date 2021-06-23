//
//  AnnotationRequest.swift
//  EcoRescue
//
//  Created by Christoph Erl on 25.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation

class PlacesRequest: NSObject {
    
    func requestPlaces(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, location: CLLocationCoordinate2D, completion: @escaping ([NSObject]?, Error?)->()) {
        // Override
    }
    
    func requestPlaces(southWest: CLLocationCoordinate2D, northEast: CLLocationCoordinate2D, completion: @escaping ([NSObject]?, Error?)->()) {
        // Override
    }
    
    func cancel() {
        // Override
    }

}
