//
//  EREvent.swift
//  EcoRescue
//
//  Created by Christoph Erl on 22.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import Parse

class EREvent: ParseObject, PFSubclassing {
    
    @NSManaged var imageObject: PFFileObject?
    
    @NSManaged var from:        Date?
    @NSManaged var to:          Date?
    
    @NSManaged var title:       String?
    @NSManaged var information: String?
    @NSManaged var organizer:   String?
    
    @NSManaged var eventUrl:    String?
    @NSManaged var email:       String?
    @NSManaged var phone:       String?
    
    @NSManaged var object:      String?
    @NSManaged var street:      String?
    @NSManaged var zip:         String?
    @NSManaged var city:        String?
    
    @NSManaged var activated:   NSNumber?
    
    private(set) var image: UIImage?
    
    func getImage(completion: @escaping ((UIImage?)->())) {
        if let image = image {
            completion(image)
        } else if let imageObject = imageObject {
            imageObject.getDataInBackground(block: { (data, error) in
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
    
    var address: UCAddress {
        let result = UCAddress()
        result.object   = object
        result.street   = street
        result.zip      = zip
        result.city     = city
        return result
    }
    
    var activatedValue: Bool {
        set(newValue)   { activated = NSNumber(value: newValue as Bool) }
        get             { return activated?.boolValue ?? false }
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Event"
    }

}
