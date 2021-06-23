//
//  Place.swift
//  EcoRescue
//
//  Created by Christoph Erl on 25.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation

enum PlaceType: String {
    case fireStation    = "fire_station"
    case hospital       = "hospital"
    case doctor         = "doctor"
    case dentist        = "dentist"
    case pharmacy       = "pharmacy"
}

class Place: NSObject {
    
    private(set) var id:                String?
    private(set) var name:              String?
    private(set) var vicinity:          String?
    private(set) var formattedAddress:  String?
    private(set) var website:           String?
    private(set) var phone:             String?
    private(set) var location:          CLLocationCoordinate2D?
    private(set) var type:              PlaceType = .fireStation
    
    override init() { super.init() }
    
    convenience init(dictionary: Dictionary<String, Any>, type: PlaceType) {
        self.init()
        
        self.id         = dictionary["place_id"]    as? String
        self.name       = dictionary["name"]        as? String
        self.vicinity   = dictionary["vicinity"]    as? String
        self.website    = dictionary["website"]     as? String
        self.phone      = dictionary["phone"]       as? String
        self.type       = type
        
        // Location
        if let geometry = dictionary["geometry"] as? Dictionary<String, Any>, let location = geometry["location"] as? Dictionary<String, Any>,
            let lat = location["lat"] as? Double, let lon = location["lng"] as? Double {
            self.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        } else {
            self.location = kCLLocationCoordinate2DInvalid
        }
    }
    
    convenience init(place: GMSPlace, type: PlaceType) {
        self.init()
        
        self.id                 = place.placeID
        self.name               = place.name
        self.formattedAddress   = place.formattedAddress
        self.website            = place.website?.absoluteString
        self.phone              = place.phoneNumber
        self.location           = place.coordinate
        self.type               = type
    }
    
    convenience init(dictionary: Dictionary<String, Any>, type: PlaceType, latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        self.init()
        
        self.id         = dictionary["id"]    as? String
        self.name       = dictionary["name"]        as? String
        self.vicinity   = dictionary["vicinity"]    as? String
        self.website    = dictionary["website"]     as? String
        self.phone      = dictionary["phone"]       as? String
        self.type       = type
        
        // Location
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)

    }
    
}
