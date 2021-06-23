//
//  SBUserDefaultItem.swift
//  Carrera Race
//
//  Created by Christoph Erl on 30.04.16.
//  Copyright © 2016 SB Konzept. All rights reserved.
//

import UIKit

class ERUserDefaultItem: NSObject {
    
    typealias Element = NSObject
    
    var value: Element          { set { p_setValue(newValue) } get { return p_getValue() } }
    let defaultValue: Element
    
    var tag: Int
    let key: String
    
    // Manager
    fileprivate let observable: ERObservable
    fileprivate let userDefaults: UserDefaults

    init(defaultValue: Element, key: String) {
        self.defaultValue   = defaultValue
        self.key            = key
        
        self.tag            = 0
        self.userDefaults   = UserDefaults.standard
        self.observable     = ERObservable()
        
        super.init()
    }
    
    // MARK: - Observer
    
    func addObserver(_ observer: ERUserDefaultItemProtocol) {
        observable.addObserver(observer)
    }
    
    func removeObserver(_ observer: ERUserDefaultItemProtocol) {
        observable.removeObserver(observer)
    }
    
    func reset() {
        self.value = defaultValue
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setValue(_ value: Element) {
        userDefaults.set(value, forKey: key)
        
        // Delegate
        p_notifyObservers()
    }
    
    fileprivate func p_getValue() -> Element {
        if let value = userDefaults.object(forKey: key) as? Element {
            return value
        }
        Log.i("ERUserDefaultItem - Stored property not found, using default value instead.")
        return defaultValue
    }
    
    // MARK: - Private Methods - Observable
    
    fileprivate func p_notifyObservers() {
        observable.notifyObservers { (observer) -> () in
            (observer as! ERUserDefaultItemProtocol).userDefaultItemDidChangeValue(self)
        }
    }
    
}
