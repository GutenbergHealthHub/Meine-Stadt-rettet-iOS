//
//  AppDelegate.swift
//  EcoRescueASB
//
//  Created by Birtan on 14.10.18.
//  Copyright © 2018 Birtan. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UserNotifications
import Parse

import GoogleMaps
import GooglePlaces
import GooglePlacePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, ERDataManagerDelegate {
    
    var window: UIWindow?
    var usertemp: ERUser? { return ERUser.current() }
    var isMonitoring = false
    
    // Managers
    fileprivate let dataManager             = ERDataManager.sharedManager
    fileprivate let locationManager         = CLLocationManager()
    
    // View Controllers
    private static var p_temporaryViewController: UIViewController?
    
    private lazy var containerViewController = ERContainerViewController()
    
    // MARK: - Lifecycle
    private let notificationCenter = UNUserNotificationCenter.current()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Setup APIs
        GMSPlacesClient.provideAPIKey(PlacesGMSRequest.ApiKey)
        GMSServices.provideAPIKey(PlacesGMSRequest.ApiKey)
        
        ERUser.registerSubclass()
        
        dataManager.addObserver(self)
        
        // Initialise Notification & Parse
        p_initialiseNotifications(application: application)
        
        let user: ERUser? = ERCommunicationManager.fetchUserFromLocalDatastoreSynchronously()
        
        if let user = user, user.validCode, launchOptions?[UIApplicationLaunchOptionsKey.location] != nil {
            self.startReceivingLocationChanges()
        } else {
            updateWindowIfNecessary()
        }
        
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
        // Cancel Emergency State Expired
        dataManager.cancelEmergencyStateExpired()
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
        // Set Last Time Active
        ERUserDefaultManager.userDefaultLastTimeActive.update()
        ERUserDefaultManager.userDefaultInboxCheckingDate.update()
        
        if !self.isMonitoring, let user = usertemp, user.validCode {
            self.startReceivingLocationChanges()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        updateWindowIfNecessary()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        // Fire Emergency State Expired
        //dataManager.cancelEmergencyStateExpired()
        //dataManager.fireEmergencyStateExpired()
        dataManager.cancelAllPendingNotifications()
        
        // Reload Data
        dataManager.reloadUser()
        dataManager.reloadEmergencyStates()
        dataManager.resetBadge()
        
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        dataManager.updateUserLocation()
        
        // DataManager
        dataManager.removeObserver(self)
        
        self.saveContext()
    }
    
    // MARK: private functions
    
    private func updateWindowIfNecessary() {
        
        // When Window is not set
        if window == nil {
            // User Interface V2
            UIBarButtonItem.appearance().tintColor      = UIColor.white
            UINavigationBar.appearance().tintColor      = UIColor.white
            
            if #available(iOS 11, *) {
            } else {
                UINavigationBar.appearance().isTranslucent  = false
                UIToolbar.appearance().isTranslucent        = false
            }
            
            // Window
            window = UIWindow(frame: UIScreen.main.bounds)
            
            if let user = ERUser.current(), user.validCode, CLLocationManager.authorizationStatus() == .authorizedAlways {
                self.startReceivingLocationChanges()
            }
            
            window!.rootViewController = self.containerViewController
            window!.makeKeyAndVisible()
        }
    }
    
    private func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedAlways {
            return
        }
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            return
        }
        NSLog("receive")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.startMonitoringSignificantLocationChanges()
        self.isMonitoring = true
    }
    
    //CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, let user = ERUser.current() {
            user.location = PFGeoPoint(location: location)
            user.saveEventually()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            
            manager.stopMonitoringSignificantLocationChanges()
            self.isMonitoring = false
            return
        }
    }
    
    // MARK: - Notifications
    
    private func p_initialiseNotifications(application: UIApplication) {
        
        // Local
        notificationCenter.delegate = self
        
        // Remote
        application.registerForRemoteNotifications()
    }
    
    private func p_registerForRemoteNotificationsWithDeviceToken(_ deviceToken: Data) {
        if let installation = PFInstallation.current() {
            installation.deviceToken = ""
            installation.setDeviceTokenFrom(deviceToken)
            installation.channels = ["global"]
            installation.saveInBackground()
            
        } else {
            Log.e("No installation available.")
        }
    }
    
    // MARK: - Push Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        p_registerForRemoteNotificationsWithDeviceToken(deviceToken)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("Did receive notification (didReceiveRemoteNotification) \(userInfo)")
        if application.applicationState == .inactive || application.applicationState == .background {
            ERNotificationManager.shared.handleSilentRemote(userInfo: userInfo)
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }
    
    // UNUserNotificationCenterDelegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Did receive notification (willPresent) \(notification.request.content.userInfo)")
        //ERNotificationManager.shared.handleSilentRemote(userInfo: notification.request.content.userInfo)
        completionHandler(ERNotificationManager.shared.handle(userInfo: notification.request.content.userInfo))
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "EcoRescue")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Public Variables
    
    static var topViewController: UIViewController? { return shared.window?.rootViewController?.topController }
    
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }
    
}

