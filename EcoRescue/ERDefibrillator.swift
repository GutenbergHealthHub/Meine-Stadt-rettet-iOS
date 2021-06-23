//
//  ERDefibrillator.swift
//  EcoRescue
//
//  Created by Christoph Erl on 26.03.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import Parse

class ERDefibrillator: PFObject, PFSubclassing {
    
    @NSManaged var location: PFGeoPoint?
    
    @NSManaged var information: String?
    
    @NSManaged var object:      String?
    @NSManaged var street:      String?
    @NSManaged var number:      String?
    @NSManaged var zip:         String?
    @NSManaged var city:        String?
    
    @NSManaged var files:       [PFFileObject]?
    
    @NSManaged var creator:     PFUser?
    
    @NSManaged var state: NSNumber?
    
    @NSManaged var producerDefiValue: NSNumber?
    @NSManaged var model: String?
    @NSManaged var type: String?
    
    @NSManaged var activated: NSNumber?
    
    override init() {
        super.init()
    }
    
    override init(className newClassName: String) {
        super.init(className: newClassName)
    }
    
    var address: UCAddress? {
        
        set {
            object  = newValue?.object
            street  = newValue?.street
            number  = newValue?.number
            zip     = newValue?.zip
            city    = newValue?.city
            
            if let coordinate = newValue?.coordinate {
                location = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
            }
            
        }
        
        get {
            var result      = UCAddress()
            result.object   = object
            result.street   = street
            result.number   = number
            result.zip      = zip
            result.city     = city
            
            if let location = location {
                result.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            }
            
            return result
        }
    }
    
    var stateValue: (String, UIColor)? {
        if let state = state {
            for item in stateTuple{
                if item.0 == Int(state) { return (item.1, item.2) }
            }
        }
        return nil
    }
    
    var stateTuple: [(Int, String, UIColor)] {
        var p_stateTuple = [(Int, String, UIColor)]()
        p_stateTuple.append((1, String.DEFIBRILLATOR_IN_REVIEW, UIColor.colorDarkYellow))
        p_stateTuple.append((2, String.REJECTED, UIColor.colorRed))
        p_stateTuple.append((3, String.AVAILABLE, UIColor.colorDarkGreen))
        p_stateTuple.append((4, String.VERIFIED_BY_ASB, UIColor.colorBlue))
        return p_stateTuple
    }
    
    var producerValue: (Int, String)? {
        if let prod = producerDefiValue {
            for item in ERDefibrillator.producerTuple{
                if item.0 == Int(prod) { return item }
            }
        }
        return nil
    }
    
    
    static var producerTuple: [(Int, String)] {
        var p_producerTuple = [(Int, String)]()
        p_producerTuple.append((1, String.LAERDAL_PHILLIPS_HP))
        p_producerTuple.append((2, String.SCHILLER_BRUKER))
        p_producerTuple.append((3, String.GS_ELEKTROMEDIZINISCHE_GERAETE))
        p_producerTuple.append((4, String.MEDTRONIC_PHYSIO_CONTROL))
        p_producerTuple.append((5, String.MARQUETTE))
        p_producerTuple.append((6, String.ZOLL))
        p_producerTuple.append((7, String.PRIMEDIC))
        p_producerTuple.append((8, String.DRAEGER))
        p_producerTuple.append((9, String.WEINMANN))
        p_producerTuple.append((10, String.WELCH_ALLYN))
        p_producerTuple.append((11, String.GE))
        p_producerTuple.append((12, String.DEFIBTECH))
        p_producerTuple.append((13, String.CU_MEDICAL_SYSTEMS))
        p_producerTuple.append((14, String.HEARTSINE))
        return p_producerTuple
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Defibrillator"
    }
    
}
