//
//  Log.swift
//  EcoRescue
//
//  Created by Christoph Erl on 07.07.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

class Log: NSObject {
    
    class func i(_ message: String) {
        print("[INFO]" + " " + message)
    }
    
    class func e(_ message: String) {
        print("[ERROR]" + " " + message)
    }

}

