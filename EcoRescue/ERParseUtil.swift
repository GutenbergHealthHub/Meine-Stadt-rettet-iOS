//
//  ERParseUtil.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

extension PFGeoPoint {
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var coordinate: CLLocationCoordinate2D {
        return location.coordinate
    }
    
    
}
