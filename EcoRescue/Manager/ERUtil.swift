//
//  STUtil.swift
//  CESteps
//
//  Created by Christoph Erl on 15.03.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import Contacts

open class ERUtil: NSObject {
    
    
    class func openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    open class func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    open class func async(_ task: @escaping () -> (AnyObject?), completition: ((AnyObject?) -> ())? = nil) {
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background).async {
            
            let object: (AnyObject?) = task()
            
            if let completion = completition {
                DispatchQueue.main.async {
                    completion(object)
                }
            }
        }
    }
    
    class func degreesToRadians(_ degrees: CGFloat) -> CGFloat {
        return degrees * CGFloat(M_PI) / 180.0
    }
    
    class func radiansToDegrees(_ radians: CGFloat) -> CGFloat {
        return radians * 180.0 / CGFloat(M_PI)
    }
    
    
    
    
    
    // MARK: - Format Address
    
    static func localizedAddressStringFor(dictionary:  [AnyHashable: Any?]) -> String {
        return CNPostalAddressFormatter.string(from: ERUtil.postalAddressFrom(dictionary: dictionary), style: .mailingAddress)
    }
    
    private static func postalAddressFrom(dictionary: [AnyHashable: Any]) -> CNMutablePostalAddress {
        let address = CNMutablePostalAddress()
        
        address.street      = dictionary["Street" as NSObject] as? String ?? ""
        address.state       = dictionary["State" as NSObject] as? String ?? ""
        address.city        = dictionary["City" as NSObject] as? String ?? ""
        address.country     = dictionary["Country" as NSObject] as? String ?? ""
        address.postalCode  = dictionary["ZIP" as NSObject] as? String ?? ""
        
        return address
    }

        
}
