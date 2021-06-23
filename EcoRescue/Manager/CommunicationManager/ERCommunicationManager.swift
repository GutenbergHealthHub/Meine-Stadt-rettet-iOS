//
//  ERCommunicationManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import Parse

enum ERCommunicationManagerError: Error {
    case userNotFound
    case objectNotFound
    
    case emailNotVerified
    case certificateNotFound
    case signatureNotFound
    
}

let kPinIdentifierEmergencyState = "EmergencyState"



class ERCommunicationManager: NSObject {
    
    static let sharedManager = ERCommunicationManager()
    
    private override init() {
        super.init()
        p_initialise()
    }
        
    // MARK: - Public Methods
    
    private func p_initialise() {
        Environment.mode = .production //.production //.development
        
        Parse.initialize(with: ParseClientConfiguration { config in
            config.applicationId            = Environment.applicationIdString
            config.server                   = Environment.baseURLString
            config.clientKey                = Environment.clientKeyString
            config.isLocalDatastoreEnabled  = true
        })
    }

    // MARK: Public Methods - ERParseFrameworkManager
    
    func registerForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        if let installation = PFInstallation.current() {
            installation.setDeviceTokenFrom(deviceToken)
            installation.channels = ["global"]
            installation.saveInBackground()
        } else {
            Log.e("No installation available.")
        }
    }
    
    func resetBadge() {
        if let installation = ERInstallation.current() {
            installation.badge = 0
            installation.saveEventually()
        }
    }
    
    func setBadge(badge: Int) {
        if let installation = ERInstallation.current() {
            installation.badge = badge
            installation.saveEventually()
        }
    }
    
    /*
    func incrementBadge() {
        if let installation = ERInstallation.current() {
            installation.badge += 1
            installation.saveEventually()
        }
    }
    
    func decrementBadge() {
        if let installation = ERInstallation.current() {
            installation.badge -= 1
            installation.saveEventually()
        }
    }
    */
    func badge() -> Int {
        return PFInstallation.current()?.badge ?? 0
    }
    
    // MARK: - Url
    
    func findURLs(completion: @escaping ([ERURL]?, Error?) ->()) {
        let query = ERURL.query()!
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
            } else if let urls = objects as? [ERURL] {
                completion(urls, nil)
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    // MARK: - Contracts
    
    func findContracts(state: String, completion: @escaping ((ERContract?, Error?)->())) {
        let query = ERContract.query()!
        query.whereKey("state", equalTo: state)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
            } else if let contract = objects?.first as? ERContract {
                completion(contract, error)
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    func findContractSubs(completion: @escaping (([ERContractSub]?, Error?)->())) {
        let query = ERContractSub.query()!
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
            } else if let contracts = objects as? [ERContractSub] {
                completion(contracts.filter { $0.valid }, error)
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    func findUserContractSubs(contract: ERContractSub, user: ERUser, completion: @escaping ((ERUserContractSub?, Error?)->())) {
        let query = ERUserContractSub.query()!
        query.whereKey("contract", equalTo: contract)
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
            } else if let userContractSub = objects?.first as? ERUserContractSub {
                completion(userContractSub, error)
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    func findUserContractSubs(user: ERUser, completion: @escaping (([ERUserContractSub]?, Error?)->())) {
        let query = ERUserContractSub.query()!
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
            } else if let userContractSub = objects as? [ERUserContractSub]{
                completion(userContractSub, error)
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    // MARK: - Events, News & Courses
    
    func findNews(completion: @escaping (([ERNews]?, Error?) -> ())) {
        let query = ERNews.query()!
        query.whereKey("activated", equalTo: NSNumber(value: true))
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
                
            } else if let objects = objects as? [ERNews] {
                completion(objects, nil)
            
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    func findEvents(completion: @escaping (([EREvent]?, Error?) -> ())) {
        let query = EREvent.query()!
        query.whereKey("activated", equalTo: NSNumber(value: true))
        query.whereKey("to", greaterThanOrEqualTo: Date())
        query.addDescendingOrder("from")
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
                
            } else if let objects = objects as? [EREvent] {
                completion(objects, nil)
                
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    func findCourses(completion: @escaping (([ERCourse]?, Error?) -> ())) {
        let query = ERCourse.query()!
        query.whereKey("activated", equalTo: NSNumber(value: true))
        query.whereKey("to", greaterThanOrEqualTo: Date())
        query.addDescendingOrder("from")
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
                
            } else if let objects = objects as? [ERCourse] {
                completion(objects, nil)
                
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    // MARK: - Defibrillatoren
    
    func findDefibrillators(completion: @escaping (([ERDefibrillator]?, Error?) -> ())) {
        let query = ERDefibrillator.query()!
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
                
            } else if let objects = objects as? [ERDefibrillator] {
                completion(objects, nil)
                
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    func findUserDefibrillators(completion: @escaping (([ERDefibrillator]?, Error?) -> ())) {
        let query = ERDefibrillator.query()!
        query.whereKey("creator", equalTo: ERUser.current()!)
        query.findObjectsInBackground { (objects, error) in
            if let error = error {
                completion(nil, error)
                
            } else if let objects = objects as? [ERDefibrillator] {
                completion(objects, nil)
                
            } else {
                completion(nil, SystemError.noResult)
            }
        }
    }
    
    func save(defibrillator: ERDefibrillator, completion: ((Bool, Error?) -> ())? = nil, progressBlock: ((PFFileObject, Int) -> ())? = nil) {
        p_save(files: defibrillator.files, completion: { (success, error) in
            
            if success {
                
                defibrillator.saveInBackground(block: { (success, error) in
                    completion?(success, error)
                })
                
            } else {
                completion?(success, error)
            }
            
        }) { (file, progress) in
            
        }
    }
    
    private func p_save(files: [PFFileObject]?, completion: ((Bool, Error?) -> ())? = nil, progressBlock: ((PFFileObject, Int) -> ())? = nil) {
        if let files = files, files.count > 0 {
            var map             = [PFFileObject: (Bool, Error?)]()
            var done            = false
            
            for file in files {
                
                file.saveInBackground({ (success, error) in
                    
                    map[file] = (success, error)
                    
                    if !success && !done {
                        done = true
                        completion?(success, error)
                    }
                    
                    
                    if map.keys.count == files.count && !done {
                        done = true
                        completion?(true, nil)
                    }
                    
                }, progressBlock: { (progress) in
                    //progressBlock?(file, progress)
                })
            }
            
        } else {
            completion?(true, nil)
        }
    }
    
}
