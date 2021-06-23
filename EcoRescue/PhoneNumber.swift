//
//  PhoneNumber.swift
//  EcoRescue
//
//  Created by Christoph Erl on 08.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

class PhoneNumber: PFObject {
    
    var code:    String?
    var number:  String?
    
    /*
    override init() {}
    
    // MARK: - NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        self.code   = aDecoder.decodeObject(forKey: "code") as? String
        self.number = aDecoder.decodeObject(forKey: "number") as? String
        
        /*
        return [
            "code": ,
            "number": aDecoder.decodeObject(forKey: "number")
        ]
 */
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(code, forKey: "code")
        aCoder.encode(number, forKey: "number")
    }
 */
    
}
