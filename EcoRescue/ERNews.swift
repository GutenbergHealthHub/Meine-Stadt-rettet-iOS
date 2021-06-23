//
//  ERNews.swift
//  EcoRescue
//
//  Created by Christoph Erl on 22.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERNews: ParseObject, PFSubclassing {
    
    @NSManaged var imageObject: PFFileObject?
    
    @NSManaged var title:       String?
    @NSManaged var subtitle:    String?
    @NSManaged var newsUrl:     String?
    
    @NSManaged var newsType:    String?
    @NSManaged var abstract:    String?
    
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
    
    var activatedValue: Bool {
        set(newValue)   { activated = NSNumber(value: newValue as Bool) }
        get             { return activated?.boolValue ?? false }
    }
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "News"
    }
    
    
    
}

