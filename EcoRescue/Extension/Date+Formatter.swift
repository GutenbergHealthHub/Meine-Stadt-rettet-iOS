//
//  NSDate+Formatter.swift
//  EcoRescue
//
//  Created by Christoph Erl on 30.06.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import Foundation

extension Date {
    
    var formattedString: String? {
        let today = Date()
        let dateFormatter = DateFormatter()
        
        if Date.daysBetween(date1: self, date2: today) == 0 {
            dateFormatter.dateFormat = "ddMMyyyy"
            return dateFormatter.string(from: self)
            
        } else if Date.daysBetween(date1: self, date2: today) == 1 {
            dateFormatter.dateFormat = "ddMMyyyy"
            return dateFormatter.string(from: self)
            
        }
        
        dateFormatter.dateFormat = "ddMMyyyy"
        return dateFormatter.string(from: self)
    }
    
}
