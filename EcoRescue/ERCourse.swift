//
//  ERCourses.swift
//  EcoRescue
//
//  Created by Birtan on 04.06.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class ERCourse: ParseObject, PFSubclassing {
    
    @NSManaged var name:        String?
    @NSManaged var street:      String?
    @NSManaged var zip:         String?
    @NSManaged var city:        String?
    @NSManaged var country:     String?
    @NSManaged var organizer:   String?
    @NSManaged var phone:       String?
    @NSManaged var email:       String?
    @NSManaged var information: String?
    @NSManaged var url:         String?
    @NSManaged var from:        Date?
    @NSManaged var to:          Date?
    
    @NSManaged var image: PFFileObject?
    
    @NSManaged var activated:   NSNumber?
    
    private(set) var courseImage: UIImage?
    
    func getImage(completion: @escaping ((UIImage?)->())) {
        if let courseImage = courseImage {
            completion(courseImage)
        } else if let image = image {
            image.getDataInBackground(block: { (data, error) in
                if let data = data {
                    self.courseImage = UIImage(data: data)
                    completion(self.courseImage)
                } else {
                    completion(nil)
                }
            })
        } else {
            completion(nil)
        }
    }
    
    static func parseClassName() -> String {
        return "Course"
    }

}
