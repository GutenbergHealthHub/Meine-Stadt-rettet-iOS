//
//  CEObserver.swift
//  CEBasic
//
//  Created by Christoph Erl on 02.03.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

open class ERObservable: NSObject {
    
    fileprivate(set) var observers: NSMutableArray
    
    public override init() {
        observers = NSMutableArray()
        
        super.init()
    }
    
    open func addObserver(_ observer: AnyObject) {
        if !observers.contains(observer) {
            observers.add(observer)
        }
    }
    
    open func removeObserver(_ observer: AnyObject) {
        observers.remove(observer)
    }
    
    open func notifyObservers(_ notification: (_ observer: AnyObject)->()) {
        for observer in observers {
            notification(observer as AnyObject)
        }
    }
    
    open var observersCount: Int {
        return observers.count
    }

}
