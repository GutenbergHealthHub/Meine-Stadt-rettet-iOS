//
//  NSManagedObjectExtension.swift
//  EcoRescue
//
//  Created by Birtan on 07.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import CoreData

extension NSManagedObject {
    func toDict() -> [String:Any] {
        let keys = Array(entity.attributesByName.keys)
        return dictionaryWithValues(forKeys:keys)
    }
}
