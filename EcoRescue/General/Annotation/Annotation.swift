//
//  Annotation.swift
//  EcoRescue
//
//  Created by Christoph Erl on 14.11.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import MapKit

class Annotation: NSObject, MKAnnotation {
    
    var title:      String?
    var subtitle:   String?
    var coordinate: CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid
    
    // MARK: - Annotation Classes
    
    class Emergency: Annotation {
        let emergency: EREmergency
        
        init(emergency: EREmergency) {
            self.emergency = emergency
            super.init()
            
            title      = String.EMERGENCY
            coordinate = emergency.locationPoint?.coordinate ?? kCLLocationCoordinate2DInvalid
        }
    }
    
    class Defibrillator: Annotation {
        let defibrillator: ERDefibrillator
        
        init(defibrillator: ERDefibrillator) {
            self.defibrillator = defibrillator
            super.init()
            title = String.DEFIBRILLATOR
            coordinate = defibrillator.location?.coordinate ?? kCLLocationCoordinate2DInvalid
        }
    }
    
    class PlaceAnnotation: Annotation {
        let place: Place
        
        init(place: Place) {
            self.place = place
            super.init()
            title       = place.name
            subtitle    = place.vicinity
            coordinate  = place.location ?? kCLLocationCoordinate2DInvalid
        }
    }
    
    class Hospital: PlaceAnnotation {
        
    }
    
    class Firehouse: PlaceAnnotation {

    }
    
    class Doctor: PlaceAnnotation {

    }
    
    class Pharmacy: PlaceAnnotation {

    }
    
    class Dentist: PlaceAnnotation {
        
    }
    
    // MARK: - Equal
    
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? MKAnnotation {
            return p_equal(c1: coordinate, c2: object.coordinate)
        }
        return false
    }
    
    private func p_equal(c1: CLLocationCoordinate2D, c2: CLLocationCoordinate2D) -> Bool {
        let s1 = String(format: "%.11f %.11f", c1.latitude, c1.longitude)
        let s2 = String(format: "%.11f %.11f", c2.latitude, c2.longitude)
        return s1 == s2
    }
    
}
