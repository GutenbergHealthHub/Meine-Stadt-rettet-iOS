//
//  NotificationAuthorizationViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 25.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationAuthorizationViewController: AuthorizationViewController {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        authorizationTitle          = String.PERMISSION_NOTIFICATION
        authorizationDescription    = String.PERMISSION_NOTIFICATION_DESCRIPTION
        authorizationIcon           = UIImage(named: "notification")
        authorizationTintColor      = UIColor.red
        
        // Authorization
        p_setAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        p_updateAuthorization()
    }
    
    // MARK: - Properties
    
    private var authorization: UNAuthorizationStatus = .notDetermined {
        didSet { p_setAuthorization(oldValue: oldValue) }
    }
    
    private func p_setAuthorization(oldValue: UNAuthorizationStatus) {
        if oldValue == authorization { return }
        p_setAuthorization()
    }
    
    private func p_setAuthorization() {
        switch authorization {
            
        case .authorized:
            authorizationButtonTitle        = nil
            authorizationButtonIcon         = Icon(type: .checkmark).toImage()
            authorizationButtonTintColor    = UIColor.positive
            authorizationButtonShape        = .circle
            authorizationButtonFilled       = false
            
            authorizationInformation        = nil
            authorizationInformationColor   = UIColor.colorTextSecondary
            break
            
        case .denied:
            authorizationButtonTitle        = String.OPEN_CONFIGURATION
            authorizationButtonIcon         = nil
            authorizationButtonTintColor    = UIColor.theme
            authorizationButtonShape        = .rounded
            authorizationButtonFilled       = true
            
            authorizationInformation        = String.PERMISSION_NOTIFICATION_NOT_ALLOWED
            authorizationInformationColor   = UIColor.colorTextSecondary
            break
            
        case .notDetermined:
            authorizationButtonTitle        = String.ALLOW
            authorizationButtonIcon         = nil
            authorizationButtonTintColor    = UIColor.theme
            authorizationButtonShape        = .rounded
            authorizationButtonFilled       = true

            authorizationInformation        = nil
            authorizationInformationColor   = UIColor.colorTextSecondary
            break
            
        case .provisional:
            break
        }
    }
    
    private func p_updateAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                self.authorization = settings.authorizationStatus
            }
        }
    }
    
    private func p_openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Override
    
    override func didTapAuthorize(sender: Any) {
        switch authorization {
            
        case .authorized:
            dismiss(animated: true, completion: nil)
            break
            
        case .denied:
            p_openSettings()
            break
            
        case .notDetermined:
            if #available(iOS 12.0, *) {
                notificationCenter.requestAuthorization(options:  [.alert, .badge, .sound, .criticalAlert]) { (success, error) in
                    self.p_updateAuthorization()
                }
            } else {
                // Fallback on earlier versions
                notificationCenter.requestAuthorization(options:  [.alert, .badge, .sound]) { (success, error) in
                    self.p_updateAuthorization()
                }
            }
            break
            
        case .provisional:
            break
        }
    }
    
    override func sections() -> [FixedTableViewSection] {

        let title2      = String.NEWS
        let subtitle2   = String.PERMISSION_STAY_INFORMED
        let cell2       = AuthorizationViewController.createTableViewCell(title: title2, subtitle: subtitle2)

        let section = FixedTableViewSection()
        switch accessLevel {
            
        case .firstResponder:
            let title1      = String.ALARM
            let subtitle1   = String.PERMISSION_GET_ERMERGENCY_MISSION
            let cell1       = AuthorizationViewController.createTableViewCell(title: title1, subtitle: subtitle1)
            
            section.tableViewCells = [ (cell1, nil), (cell2, nil) ]
            break
            
        case .guest:
            section.tableViewCells = [ (cell2, nil) ]
            break
        }

        var _sections = super.sections()
        _sections.append(section)
        return _sections
    }

}
