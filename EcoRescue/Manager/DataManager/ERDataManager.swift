//
//  ERProfileManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 04.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications
import Parse

let kERDataManagerInfoTag       = "ERDataManager"

// MARK: - ERDataManagerDelegate
@objc protocol ERDataManagerDelegate: NSObjectProtocol {
    
    @objc optional func dataManagerShouldShowEmergencyState(dataManager: ERDataManager, emergencyState: EREmergencyState)
    
    @objc optional func dataManagerDidCancelEmergencyState(dataManager: ERDataManager, emergencyState: EREmergencyState)
    @objc optional func dataManagerDidExpireEmergencyState(dataManager: ERDataManager, emergencyState: EREmergencyState)
    @objc optional func dataManagerDidUpdateEmergencyStates(dataManager: ERDataManager, error: Error?)
    
    @objc optional func dataManagerDidUpdateServiceTime(dataManager: ERDataManager, date: Date)
    @objc optional func dataManagerDidContinueServiceTime(dataManager: ERDataManager)
    
    @objc optional func dataManagerDidUpdateEmergencyState(dataManager: ERDataManager, emergencyState: EREmergencyState)
    @objc optional func dataManagerDidUpdateUser(dataManager: ERDataManager)
    
    // Events
    @objc optional func dataManagerDidBeginLoadEvents(dataManager: ERDataManager)
    @objc optional func dataManagerDidEndLoadEvents(dataManager: ERDataManager, events: [EREvent]?, error: Error?)
    // News
    @objc optional func dataManagerDidBeginLoadNews(dataManager: ERDataManager)
    @objc optional func dataManagerDidEndLoadNews(dataManager: ERDataManager, news: [ERNews]?, error: Error?)
    // Courses
    @objc optional func dataManagerDidBeginLoadCourses(dataManager: ERDataManager)
    @objc optional func dataManagerDidEndLoadCourses(dataManager: ERDataManager, courses: [ERCourse]?, error: Error?)
    
    // URL
    
    @objc optional func dataManagerDidBeginLoadURLs(dataManager: ERDataManager)
    @objc optional func dataManagerDidEndLoadURLs(dataManager: ERDataManager, urls: [ERURL]?, error: Error?)
}

// MARK: - Class
class ERDataManager: NSObject, ERNotificationManagerDelegate {
    
    static let sharedManager = ERDataManager()

    var user: ERUser? { return ERUser.current() }
    
    var isEmergencyRunning: Bool { return emergencyStateManager != nil  }
    
    var runningEmergencyStates:     [EREmergencyState] { get { return runningEvaluationsArray         } }
    var finishedEmergencyStates:    [EREmergencyState] { get { return finishedExpiredEvaluationsArray } }
    
    var evaluations: [EREmergencyState]! { get { return emergencyStateArray } }
    
    fileprivate(set) var emergencyStateManager: ERDataEmergencyStateManager?  { didSet { p_setEmergencyStateManager(oldValue) } }
    
    // News & Events
    var isLoadingEvents:   Bool    { return eventsRequestCounter > 0   }
    var isLoadingNews:     Bool    { return newsRequestCounter > 0     }
    var isLoadingURLs:     Bool    { return urlsRequestCounter > 0     }
    
    private(set) var news       = [ERNews]()
    private(set) var events     = [EREvent]()
    private(set) var courses    = [ERCourse]()
    
    private(set) var urls       = [ERURLType: ERURL]()
    
    // Managers    
    let communicationManager        = ERCommunicationManager.sharedManager
    let notificationManager         = ERNotificationManager.shared
    
    // Observable
    let observable = ERObservable()
    
    fileprivate override init() {     
        super.init()
        notificationManager.delegate    = self
    }
    
    // MARK: - Observer
    
    func addObserver(_ observer: ERDataManagerDelegate) {
        observable.addObserver(observer)    }
    
    func removeObserver(_ observer: ERDataManagerDelegate) {
        observable.removeObserver(observer)
    }
    
    // MARK: - Public Methods

    func setEmergencyState(_ emergancyState: EREmergencyState) {
        if emergencyStateManager == nil {
            emergencyStateManager = ERDataEmergencyStateManager(emergencyState: emergancyState)
            
            // Update Location Manager
            ERLocationManager.shared.emergencyRunning = true
        }
    }
    
    func resetEvaluation() {
        emergencyStateManager?.delegate = nil
        emergencyStateManager?.invalidate()
        emergencyStateManager = nil
        
        // Update Location Manager
        ERLocationManager.shared.emergencyRunning = false
    }
    
    func findEmergencyStateById(objectId: String) -> EREmergencyState? {
        for emergencyState in emergencyStateArray {
            if emergencyState.objectId == objectId { return emergencyState }
        }
        return nil
    }
    
    func findRunningEmergencyStateById(objectId: String) -> EREmergencyState? {
        for emergencyState in runningEvaluationsArray {
            if emergencyState.objectId == objectId { return emergencyState }
        }
        return nil
    }
    
    // MARK: - EmergencyStates
    var emergencyStates = [EREmergencyState]()
    
    var emergencyStateArray: [EREmergencyState] {
        return emergencyStates.sorted(by: { (state1, state2) -> Bool in
            if let date1 = state1.createdAt, let date2 = state2.createdAt {
                return date1.isGreaterThan(date2)
            } else {
                return false
            }
        })
    }
    
    var runningEvaluationsArray: [EREmergencyState] {
        let running =  emergencyStateArray.filter { (item) -> Bool in
            return !item.missionExpired && !item.missionFinished && !item.missionCallback && item.missionReachable 

        }
        return running
    }
    
    var finishedExpiredEvaluationsArray: [EREmergencyState] {
        return emergencyStateArray.filter { (item) -> Bool in
            return (item.missionExpired && item.missionAccepted) ||  item.missionFinished
        }
    }
    
    var finishedExpiredEvaluationsWithProtocolNotDoneArray: [EREmergencyState] {
        return finishedExpiredEvaluationsArray.filter { (item) -> Bool in
            return !item.protocolDone
        }
    }
    
    // MARK: - ERNotificationManagerDelegate
    
    func notificationManagerDidReceiveUpdateUser(notificationManager: ERNotificationManager) {
        p_notifyObserversDidUpdateUser()
    }
    
    func notificationManagerDidReceiveUpdateEmergencyState(notificationManager: ERNotificationManager) {
        
    }
    
    func notificationManagerDidReceiveEmergencyState(notificationManager: ERNotificationManager, notification: EREmergencyStateNotification) {
        //p_handleNotificationEmergencyState(objectId: notification.emergencyStateId)
        handleNotificationStateForeground(objectId: notification.emergencyStateId)
    }
    
    func notificationManagerDidReceiveEmergencyStateBackground(notificationManager: ERNotificationManager, notification: EREmergencyStateNotification) {
        handleNotificationStateBackground(objectId: notification.emergencyStateId)
    }
    
    func notificationManagerDidReceiveEmergencyStateExpired(notificationManager: ERNotificationManager, notificationExpired: ERExpiredEmergencyStateNotification) {
        p_handleNotificationExpiredEmergencyState(objectId: notificationExpired.emergencyStateId)
    }
    
    func notificationManagerDidReceiveServicePauseEnded(notificationManager: ERNotificationManager, notification: EREndedServicePauseNotification) {
        p_handleNotificationEndedServicePause()
    }
    
    func notificationManagerDidReceiveCancelEmergency(notificationManager: ERNotificationManager, notification: ERCancelEmergencyNotification) {
        p_handleNotificationCancelEmergencyState(objectId: notification.emergencyStateId)
    }
    
    // MARK: - Private Methods - Handle Notifications
    
    private let notificationLocationHelper = ERLocationHelper()
    private func p_handleNotificationEmergencyState(objectId: String) {
        reloadEmergencyStates { (emergencyStates, error) in
            if error != nil { return }
            
            if let emergencyState = self.findRunningEmergencyStateById(objectId: objectId) {
    
                // Present (Local) Notification to the user
                //self.notificationManager.fireEmergencyState()
                    
                // Increment Badge
                //self.updateBadge()
            }
        }
    }
    
    private func handleNotificationStateForeground(objectId: String) {
        if !self.emergencyStates.contains(where: { (state) -> Bool in state.objectId == objectId }) && self.runningEmergencyStates.count == 0 {
            self.communicationManager.findEmergencyState(id: objectId, completion: {(emergencyState, error) in
                if let state = emergencyState {
                    self.emergencyStates.append(state)
                    ResponderStateManager.shared.getState(completion: { (state) in
                        if let activeState = self.runningEmergencyStates.first {
                            if state == .active || activeState.emergencyRelation.testEmergencySendBy != nil {
                                let vc = EREmergencyCallPageViewController()
                                vc.emergencyState = activeState
                                AppDelegate.topViewController?.present(vc, animated: true, completion: nil)
                            } else {
                                let vc = ERMissedEmergencyProfileIncompleteViewController()
                                vc.emergencyState = activeState
                                AppDelegate.topViewController?.present(vc, animated: true, completion: nil)
                            }
                        }
                    })
                }
            })
        }
    }
    
    private func handleNotificationStateBackground(objectId: String) {
        communicationManager.findEmergencyStateBackground(id: objectId, completion: {(emergencyState, error) in
                if let state = emergencyState {
                    //self.updateBadge()
                    self.notificationManager.triggerEmergencyExpired(for: state)
                }
            })
    }
    
    private func p_handleNotificationExpiredEmergencyState(objectId: String) {
        if let emergencyState = findEmergencyStateById(objectId: objectId) {
            p_notifyObserversDidExpireEmergencyState(emergencyState: emergencyState)
        }
    
    }
    
    private func p_handleNotificationCancelEmergencyState(objectId: String) {
        if let emergencyState = findEmergencyStateById(objectId: objectId) {
            self.p_notifyObserversDidCancelEmergencyState(emergencyState: emergencyState)
        }
    }
    
    private func p_handleNotificationEndedServicePause() {
        p_notifyObserversDidContinueServiceTime()
    }
    
    fileprivate func p_setEmergencyStateManager(_ oldValue: ERDataEmergencyStateManager?) {
        if oldValue == emergencyStateManager { return }
    }
    
    // MARK: - Private Helper Methods
    
    fileprivate func p_isReachable(_ userLocation: CLLocation?, emergencyLocation: CLLocation?, radiusInMeter radius: Double) -> Bool {
        if let emergencyLocation = emergencyLocation {
            if let userLocation = userLocation {
                let distance = userLocation.distance(from: emergencyLocation)
                return distance < radius
            }
            return true
        }
        return false
    }

    
    private func p_fireOrCancelEmergencyPushyNotification() {
        
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Public Methods - Defibrillator
    
    class func findMyDefibrillators(completion: @escaping (([ERDefibrillator]?, Error?) -> ())) {
        //ERCommunicationManager.findMyDefibrillators(completion: completion)
    }
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Public Methods - Contract
    
    class func findContractBasic(completion: @escaping (ERContract?, Error?) ->()) {
        ERCommunicationManager.sharedManager.findContracts(state: "de", completion: completion)
    }
    
    class func findContractSubs(completion: @escaping ([ERContractSub]?, Error?) ->()) {
        ERCommunicationManager.sharedManager.findContractSubs(completion: completion)
    }
    
    class func findUserContractSubs(contract: ERContractSub, user: ERUser, completion: @escaping (ERUserContractSub?, Error?) ->()) {
        ERCommunicationManager.sharedManager.findUserContractSubs(contract: contract, user: user, completion: completion)
    }
    
    class func findUserContractSubs(user: ERUser, completion: @escaping ([ERUserContractSub]?, Error?) ->()) {
        ERCommunicationManager.sharedManager.findUserContractSubs(user: user, completion: completion)
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Public Methods - Events & News
    private var newsRequestCounter      = 0
    private var eventsRequestCounter    = 0
    private var coursesRequestCounter   = 0
    
    func findNews() {
        if newsRequestCounter == 0 {
            p_notifyObserversDidBeginLoadNews()
        }
        
        newsRequestCounter += 1
        communicationManager.findNews { (news, error) in
            self.news = news ?? []
            
            self.newsRequestCounter -= 1
            
            if self.newsRequestCounter == 0 {
                self.p_notifyObserversDidEndLoadNews(news: news, error: error)
            }
        }
    }
    
    func findEvents() {
        if eventsRequestCounter == 0 {
            p_notifyObserversDidBeginLoadEvents()
        }

        eventsRequestCounter += 1
        communicationManager.findEvents { (events, error) in
            self.events = events ?? []
            
            self.eventsRequestCounter -= 1
            if self.eventsRequestCounter == 0 {
                self.p_notifyObserversDidEndLoadEvents(events: events, error: error)
            }
        }
    }
    
    func findCourses() {
        if coursesRequestCounter == 0 {
            p_notifyObserversDidBeginLoadCourses()
        }
        
        coursesRequestCounter += 1
        communicationManager.findCourses { (courses, error) in
            self.courses = courses ?? []
            
            self.coursesRequestCounter -= 1
            if self.coursesRequestCounter == 0 {
                self.p_notifyObserversDidEndLoadCourses(courses: courses, error: error)
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Public Methods - URL
    
    private var urlsRequestCounter    = 0
    
    func findURLs() {
        if urlsRequestCounter == 0 {
            p_notifyObserversDidBeginLoadUrls()
        } else {
            return
        }
        
        urlsRequestCounter += 1
        communicationManager.findURLs { (urls, error) in
            self.urls.removeAll()
            
            if let urls = urls {
                for url in urls {
                    self.urls[url.urlType] = url
                }
            }
            
            self.urlsRequestCounter -= 1
            
            if self.urlsRequestCounter == 0 {
                self.p_notifyObserversDidEndLoadURLs(urls: urls, error: error)
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Public Methods - Notifications
    
    func fireEmergencyStateExpired() {
        notificationManager.fireEmergencyStateExpiredFor(ergencyStates: runningEmergencyStates)
    }
    
    func cancelAllPendingNotifications() {
        notificationManager.cancelAllPendingNotificationRequests()
    }
    
    func cancelEmergencyStateExpired() {
        notificationManager.cancelEmergencyStateExpired()
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Public Methods - Service Time
    
    func setServiceTimePausedUntil(newValue: Date) {
        user?.pausedUntil = newValue
        user?.saveInBackground()
        
        // Schedule Notification
        notificationManager.cancelServicePausesEnded()
        notificationManager.fireServicePausesEnded(date: newValue)
        
        // Notify Observer
        p_notifyObserversDidUpdateServiceTime(date: newValue)
    }
    
    func resetServiceTime() {
        let newDate = Date()
        user?.pausedUntil = newDate
        user?.saveEventually()
        
        notificationManager.cancelServicePausesEnded()
        
        // Notify Observer
        p_notifyObserversDidUpdateServiceTime(date: newDate)
    }

    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Observable
    
    func p_notifyObserversShouldShow(emergencyState: EREmergencyState) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerShouldShowEmergencyState?(dataManager: self, emergencyState: emergencyState)
        }
    }
    
    func p_notifyObserversDidUpdateUser() {
        self.reloadUser { (user, error) in
            if let _ = user as? ERUser {
                self.observable.notifyObservers { (observer) in
                    (observer as! ERDataManagerDelegate).dataManagerDidUpdateUser?(dataManager: self)
                }
            }
        }
    }
    
    func p_notifyObserversDidUpdateServiceTime(date: Date) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidUpdateServiceTime?(dataManager: self, date: date)
        }
    }
    
    func p_notifyObserversDidContinueServiceTime() {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidContinueServiceTime?(dataManager: self)
        }
    }
    
    func p_notifyObserversDidUpdateEmergencyStates(error: Error?) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidUpdateEmergencyStates?(dataManager: self, error: error)
        }
    }
    
    func p_notifyObserversDidUpdateEmergencyState(emergencyState: EREmergencyState) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidUpdateEmergencyState?(dataManager: self, emergencyState: emergencyState)
        }
    }
    
    func p_notifyObserversDidExpireEmergencyState(emergencyState: EREmergencyState) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidExpireEmergencyState?(dataManager: self, emergencyState: emergencyState)
        }
    }
    
    func p_notifyObserversDidCancelEmergencyState(emergencyState: EREmergencyState) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidCancelEmergencyState?(dataManager: self, emergencyState: emergencyState)
        }
    }
    
    func p_notifyObserversDidBeginLoadNews() {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidBeginLoadNews?(dataManager: self)
        }
    }
    
    func p_notifyObserversDidEndLoadNews(news: [ERNews]?, error: Error?) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidEndLoadNews?(dataManager: self, news: news, error: error)
        }
    }
    
    func p_notifyObserversDidBeginLoadEvents() {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidBeginLoadEvents?(dataManager: self)
        }
    }
    
    func p_notifyObserversDidEndLoadEvents(events: [EREvent]?, error: Error?) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidEndLoadEvents?(dataManager: self, events: events, error: error)
        }
    }
    
    func p_notifyObserversDidBeginLoadCourses() {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidBeginLoadCourses?(dataManager: self)
        }
    }
    
    func p_notifyObserversDidEndLoadCourses(courses: [ERCourse]?, error: Error?) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidEndLoadCourses?(dataManager: self, courses: courses, error: error)
        }
    }
    
    func p_notifyObserversDidBeginLoadUrls() {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidBeginLoadURLs?(dataManager: self)
        }
    }
    
    func p_notifyObserversDidEndLoadURLs(urls: [ERURL]?, error: Error?) {
        observable.notifyObservers { (observer) in
            (observer as! ERDataManagerDelegate).dataManagerDidEndLoadURLs?(dataManager: self, urls: urls, error: error)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: Network Manager
    
    func reloadUser(completion: ((ERUser?, Error?)->())? = nil) {
        ERCommunicationManager.reloadUser { (user, error) in
            completion?(user, error)
        }
    }
    
    let locationHelper = ERLocationHelper()
    func reloadEmergencyStates(completion: (([EREmergencyState]?, Error?) -> ())? = nil) {
        if user == nil { return } // Return when user not logged in
        
        locationHelper.readLocation { (location) in
            if let location = location {
                self.user?.location = PFGeoPoint(location: location)
                self.user?.saveEventually()
                
                self.communicationManager.findAllEmergencyStates { (states, error) in
                    let emergencyStates = states ?? []
                    
                    // Update Emergency State Array
                    self.emergencyStates = emergencyStates
                    
                    // Remove old & set new Expire Notification
                    //self.notificationManager.cancelEmergencyStateExpired()
                    //self.notificationManager.fireEmergencyStateExpiredFor(ergencyStates: runningEmergencyStates)
                    
                    // Notify Changes
                    completion?(emergencyStates, error)
                    self.p_notifyObserversDidUpdateEmergencyStates(error: error)
                }
            }
        }
    }
    
    func reloadMissedEmergencyState(objectId: String, completion: @escaping (EREmergencyState?, Error?) -> ()) {
        let state = findEmergencyStateById(objectId: objectId)
        if let state = state {
            completion(state, nil)
        } else {
            communicationManager.findEmergencyState(id: objectId) { (state, error) in
                if let state = state {
                    completion(state, nil)
                }
            }
        }
    }
    
    static func loginUser(_ username: String, password: String, completion: @escaping ((_ user: ERUser?, _ error: Error?) -> ()))  {
        ERCommunicationManager.loginUser(username: username, password: password, completion: completion)
    }
    
    static func resetPassword(_ username: String, completion: @escaping ((_ success: Bool, _ error: Error?) -> () ) ) {
        ERCommunicationManager.resetPassword(username: username, completion: completion)
    }
    
    func deleteAccount(_ username: String, completion: @escaping (Bool, Error?)->()) {
        communicationManager.deleteUserAccount(username: username, completion: completion)
    }
        
    func logoutUser(completion: ((Error?) -> ())? = nil)  {
        communicationManager.logout(completion: completion)
        self.emergencyStates.removeAll()
    }
    
    func updateUserLocation(completion: ((Bool, Error?) -> ())? = nil) {
        communicationManager.updateUserLocation(completion: completion)
    }
    
    func updateUserLocation(location: CLLocation) {
        communicationManager.updateUserLocation(location)
    }
    
    func sendTestEmergency(_ username: String, completion: @escaping (Bool, Error?)->()) {
        communicationManager.sendTestEmergency(username: username, completion: completion)
    }
    
    func updateBadge() {
        //let badge = self.runningEmergencyStates.count
        let badge = 1
        communicationManager.setBadge(badge: badge)
    }
    
    func resetBadge() {
        communicationManager.resetBadge()
    }
    
    func badge() -> Int {
        return communicationManager.badge()
    }
    
    func reloadEmergencyState(emergencyState: EREmergencyState, block: @escaping (EREmergencyState?, Error?) -> ()) {
        reloadEmergencyStates { (state, error) in
            if let objectId = emergencyState.objectId, let updatedObject = self.findEmergencyStateById(objectId: objectId) {
                block(updatedObject, nil)
            } else {
                block(nil, error)
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    // MARK: - Statistics
    
    var countFinishedEmergencies: Int {
        var count = 0
        for evaluation in emergencyStateArray {
            if evaluation.stateValue == .finished { count += 1 }
        }
        return count
    }
    
    var countCancelledEmergencies: Int {
        var count = 0
        for evaluation in emergencyStateArray {
            if evaluation.stateValue == .cancelled { count += 1 }
        }
        return count
    }
    
    var countOpenEmergencies: Int {
        var count = 0
        for evaluation in emergencyStateArray {
            if evaluation.stateValue == .accepted { count += 1 }
        }
        return count
    }
    
    var countAcceptedEmergencies: Int {
        var count = 0
        for evaluation in emergencyStateArray {
            if evaluation.missionFinished { count += 1 }
        }
        return count
    }
    
    var countMissedEmergencies: Int {
        return missedEmergencyStates.count
    }
    
    var missedEmergencyStates: [EREmergencyState] {
        let inactivAtDate = ERUserDefaultManager.userDefaultInboxCheckingDate.dateValue
        
        let emergencies = emergencyStateArray.filter { (state) -> Bool in
            return (state.createdAt ?? Date()).isGreaterThan(inactivAtDate) && !state.missionAccepted && (state.missionExpired || !state.missionReachable)
        }
        
        return emergencies
    }
    
}
