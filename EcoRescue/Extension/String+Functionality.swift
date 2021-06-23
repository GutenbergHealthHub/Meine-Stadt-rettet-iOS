//
//  String+Functionality.swift
//  EcoRescue
//
//  Created by Christoph Erl on 15.06.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import Foundation

extension String {
    
    var validEmailString: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var validPassword: Bool {
        let passwordRegEx = "^(?=.*?[A-Z])(?=.*?[0-9]).{6,}$"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return pred.evaluate(with: self)
    }
    
    var validPin: Bool {
        return characters.count == 6
    }
    
}

extension String {
    
    private static let baseLocalizationTable = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)!
    private static let currentLocalizationTable = String.createCurrentLocalizationTable()
    
    func localised() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: String.currentLocalizationTable, value: localisedBase(), comment: "")
    }
    
    func localisedBase() -> String {
        return NSLocalizedString(self, tableName: nil, bundle: String.baseLocalizationTable, value: "", comment: "")
    }
    
    // 
    private static func createCurrentLocalizationTable() -> Bundle {
        if let languageCode = Locale.current.languageCode, let currentPath = Bundle.main.path(forResource: languageCode, ofType: "lproj"), let currentBundle = Bundle(path: currentPath)  {
            return currentBundle
        }
        return baseLocalizationTable
    }

}


