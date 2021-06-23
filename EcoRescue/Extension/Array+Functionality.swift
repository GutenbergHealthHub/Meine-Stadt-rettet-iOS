//
//  Array+Functionality.swift
//  UCKit
//
//  Created by Christoph Erl on 11.07.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import Foundation

extension Array {
    
    func get(at: Int) -> Element? {
        if 0 <= at && at < count {
            return self[at]
        }
        return nil
    }
    
}
