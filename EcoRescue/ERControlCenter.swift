//
//  ERControlCenter.swift
//  EcoRescue
//
//  Created by Christoph Erl on 05.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERControlCenter: PFObject, PFSubclassing {
    
    @NSManaged var name:    String?
    @NSManaged var address: String?
    @NSManaged var zip:     String?
    @NSManaged var city:    String?
    
    @NSManaged var phoneNumber:     String?
    @NSManaged var faxNumber:       String?
    
    @NSManaged var logo:            PFFileObject?
    
    var formattedStreet:    String? { return getFormattedStreet()  }
    var formattedCity:      String? { return getFormattedCity()   }
    
    private(set) var image: UIImage?
    
    fileprivate func getFormattedCity() -> String?  {
        let cityString  = city ?? ""
        let zipString   = zip ?? ""
        
        return zipString + " " + cityString
    }
    
    fileprivate func getFormattedStreet() -> String? {
        return address
    }
    
    func getImage(completion: @escaping ((UIImage?)->())) {
        if let image = image {
            completion(image)
        } else if let logo = logo {
            logo.getDataInBackground(block: { (data, error) in
                if let data = data {
                    self.image = UIImage(data: data)
                    completion(self.image)
                } else {
                    completion(nil)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "ControlCenter"
    }

}
