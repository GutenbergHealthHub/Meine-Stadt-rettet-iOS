//
//  ERCommunicationManager+User.swift
//  EcoRescue
//
//  Created by Christoph Erl on 30.06.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import Foundation
import Parse

extension ERCommunicationManager {
    
    // MARK: - Public Methods
    
    static func fetchUserFromLocalDatastoreSynchronously() -> ERUser? {
        return p_fetchUserFromLocalDatastoreSynchronously()
    }
    
    static func fetchUserFromLocalDatastore(completion: @escaping (ERUser?, Error?)->()) {
        p_fetchUserFromLocalDatastore(completion: completion)
    }
    
    static func reloadUser(completion: @escaping (ERUser?, Error?)->()) {
        p_fetchUser(completion: completion)
    }
    
    // MARK: - Users
    
    class func loginUser(username: String, password: String, completion: @escaping ((_ user: ERUser?, _ error: Error?) -> ())) {
        PFObject.unpinAllObjectsInBackground()
        
        ERUser.logInWithUsername(inBackground: username.lowercased(), password: password) { (user, error) in
            
            
            if let user = user as? ERUser, let installation = ERInstallation.current() {
                
                if user.emailVerifiedValue {
                    
                    ERUserDefaultManager.userDefaultUserObjectId.stringValue = user.objectId ?? ""
                    ERUser.setCurrent(user: user)
                    
                    p_fetchUser(completion: { (user, error) in
                        user?.pinInBackground()
                        completion(user, error)
                        
                        installation.userRelation = user
                        installation.saveEventually()
                    })
                    
                } else {
                    ERUser.setCurrent(user: nil)
                    completion(nil, ERCommunicationManagerError.emailNotVerified)
                }
                
            } else {
                ERUser.setCurrent(user: nil)
                completion(nil, error)
                
            }
        }
    }
    
    class func resetPassword(username: String, completion: @escaping ((_ success: Bool, _ error: Error?) -> ())) {
        PFObject.unpinAllObjectsInBackground()
        
        PFUser.requestPasswordResetForEmail(inBackground: username.lowercased()) { (success, error)
            in
            
            completion(success, error)
        }

    }
    
    private static func p_fetchUserFromLocalDatastoreSynchronously() -> ERUser? {
        
        if let _ = PFUser.current() {
            
            do {
                let user = try p_createUserQuery(local: true).getObjectWithId(ERUserDefaultManager.userDefaultUserObjectId.stringValue) as? ERUser
                ERUser.setCurrent(user: user)
                print("Username")
                print(user?.email)
                return user
            } catch {
            return nil
            }
        } else {
            return nil
        }
    }
    
    
    private static func p_fetchUserFromLocalDatastore(completion: @escaping (ERUser?, Error?)->()) {
        let objectId = ERUserDefaultManager.userDefaultUserObjectId.stringValue
        
        p_createUserQuery(local: true).getObjectInBackground(withId: objectId) { (object, error) in
            if let loadedUser = object as? ERUser {
                ERUser.setCurrent(user: loadedUser)
                completion(loadedUser, nil)
                
            } else {
                completion(nil, error)
            }
        }
    }
    
    private static func p_fetchUser(completion: @escaping (ERUser?, Error?)->()) {
        let objectId = ERUserDefaultManager.userDefaultUserObjectId.stringValue
        
        p_createUserQuery().getObjectInBackground(withId: objectId) { (object, error) in
            if let loadedUser = object as? ERUser {
                ERUser.setCurrent(user: loadedUser)
                completion(loadedUser, nil)
                
            } else {
                completion(nil, error)
            }
        }
    }
    
    private static func p_createUserQuery(local: Bool = false) -> PFQuery<PFObject> {
        let query = ERUser.query()!
        query.includeKey("userContractBasic")
        query.includeKey("userContractBasic.contract")
        query.includeKey("certificateFR")
        query.includeKey("certificates")
        if local { query.fromLocalDatastore() }
        return query
    }
    
    // MARK: - LOGOUT
    
    func logout(completion: ((Error?) -> ())? = nil) {
        ERUserDefaultManager.userDefaultUserObjectId.stringValue = ""
        
        PFObject.unpinAllObjectsInBackground()
        
        ERInstallation.current()?.setObject(NSNull(), forKey: "userRelation")
        ERInstallation.current()?.saveEventually()
        
        ERUser.setCurrent(user: nil)
        
        ERUser.logOutInBackground { (error) in
            completion?(error)
        }
    }
    
    func updateUserLocation(completion: ((Bool, Error?) -> ())? = nil) {
        PFGeoPoint.geoPointForCurrentLocation { (point, error) in
            
            if let point = point {
                ERUser.current()?.location = point
                ERUser.current()?.saveEventually()
                completion?(true, nil)
                
            } else {
                completion?(false, error)
            }
        }
    }
    
    func updateUserLocation(_ location: CLLocation) {
        if let user = ERUser.current() {
            
            user.location = PFGeoPoint(location: location)
            user.saveEventually()
        }
    }
    
    // MARK: - Cloud Functions
    
    func deleteUserAccount(username: String, completion: @escaping (Bool, Error?)->()) {
        PFObject.unpinAllObjectsInBackground()
        
        PFCloud.callFunction(inBackground: "deleteUser", withParameters: ["userId" : username]) { (object, error) in
            if error != nil {
                completion(false, error)
            }
            ERUser.logOutInBackground { (error) in
                completion(true, error)
            }
        }
    }
    
    func sendTestEmergency(username: String, completion: @escaping (Bool, Error?)->()) {
        PFCloud.callFunction(inBackground: "createTestAlarm", withParameters: ["userId" : username]) { (object, error) in
            if error != nil {
                completion(false, error)
            }
            completion(true, error)
        }
    }

}
