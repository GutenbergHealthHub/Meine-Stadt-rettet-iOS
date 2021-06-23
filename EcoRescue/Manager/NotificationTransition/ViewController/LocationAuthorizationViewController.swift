//
//  LocationRequestAuthorizationViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 24.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation

class LocationAuthorizationViewController: AuthorizationViewController, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        authorizationTitle          = String.PERMISSION_LOCATION
        authorizationDescription    = String.PERMISSION_LOCATION_DESCRIPTION
        authorizationIcon           = Icon(type: IconType.icon_location_arrow_selected).toImage()
        authorizationTintColor      = UIColor.cBlue
        
        // Location Manager
        locationManager.delegate = self
        
        // Authorization
        p_setAuthorization()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        p_updateAuthorization()
    }
    
    // MARK: - Properties
    
    private var authorization: CLAuthorizationStatus = .notDetermined {
        didSet { p_setAuthorization(oldValue: oldValue) }
    }
    
    private func p_setAuthorization(oldValue: CLAuthorizationStatus) {
        if oldValue == authorization { return }
        p_setAuthorization()
    }
    
    private func p_setAuthorization() {
        
        switch authorization {
            
        case .authorizedAlways:
            p_setOk()
            break
            
        case .authorizedWhenInUse:
            switch accessLevel {
            case .firstResponder:
                p_setNotOk(information: LocationAuthorizationViewController.stringForAuthorizationStatusAlways());
                break
            case .guest:
                p_setOk()
                break
            }
            
        case .denied, .restricted:
            switch accessLevel {
            case .firstResponder:
                p_setNotOk(information: LocationAuthorizationViewController.stringForAuthorizationStatusAlways());
                break
            case .guest:
                p_setNotOk(information: LocationAuthorizationViewController.stringForAuthorizationStatusWhenInUse());
                break
            }
            
        case .notDetermined:
            authorizationButtonTitle        = String.ALLOW
            authorizationButtonIcon         = nil
            authorizationButtonTintColor    = UIColor.theme
            authorizationButtonShape        = .rounded
            authorizationButtonFilled       = true
            
            authorizationInformation        = nil
            authorizationInformationColor   = UIColor.colorSecondary
            break
        }
    
    }
    
    private func p_setOk() {
        authorizationButtonTitle        = nil
        authorizationButtonIcon         = Icon(type: .checkmark).toImage()
        authorizationButtonTintColor    = UIColor.positive
        authorizationButtonShape        = .circle
        authorizationButtonFilled       = false
        
        authorizationInformation        = nil
        authorizationInformationColor   = UIColor.colorSecondary
    }
    
    private func p_setNotOk(information: String?) {
        authorizationButtonTitle        = String.OPEN_CONFIGURATION
        authorizationButtonIcon         = nil
        authorizationButtonTintColor    = UIColor.theme
        authorizationButtonShape        = .rounded
        authorizationButtonFilled       = true
        
        authorizationInformation        = information
        authorizationInformationColor   = UIColor.colorTextSecondary
    }
    
    private func p_updateAuthorization() {
        authorization = CLLocationManager.authorizationStatus()
    }
    
    private func p_openLocationSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        p_updateAuthorization()
    }
    
    // MARK: - Override
    
    override func didTapAuthorize(sender: Any) {
        switch authorization {
            
        case .authorizedAlways:
            dismiss(animated: true, completion: nil)
            break
            
        case .authorizedWhenInUse:
            switch accessLevel {
            case .firstResponder:
                p_openLocationSettings()
                break
            case .guest:
                dismiss(animated: true, completion: nil)
                break
            }
            break
            
        case .denied, .restricted:
            p_openLocationSettings()
            break
            
        case .notDetermined:
            
            switch accessLevel {
                case .firstResponder:
                    locationManager.requestAlwaysAuthorization()
                    break
                case .guest:
                    locationManager.requestWhenInUseAuthorization()
                    break
            }
            break
        }
    }
    
    override func sections() -> [FixedTableViewSection] {
        
        let title2      = String.MAP
        let subtitle2   = String.PERMISSION_SEE_YOUR_LOCATION_IN_MAP
        let cell2       = AuthorizationViewController.createTableViewCell(title: title2, subtitle: subtitle2)
        
        let title3      = String.MORE
        let subtitle3   = String.PERMISSION_GET_IMPROVED_EXPERIENCE
        let cell3       = AuthorizationViewController.createTableViewCell(title: title3, subtitle: subtitle3)
        
        let section = FixedTableViewSection()
        
        switch accessLevel {
        case .firstResponder:
            let title1      = String.ALARM
            let subtitle1   = String.PERMISSION_GET_ERMERGENCY_MISSION
            let cell1       = AuthorizationViewController.createTableViewCell(title: title1, subtitle: subtitle1)
            
            section.tableViewCells = [ (cell1, nil), (cell2, nil), (cell3, nil) ]
            break
            
        case .guest:
            section.tableViewCells = [ (cell2, nil), (cell3, nil) ]
            break
        }
        
        var _sections = super.sections()
        _sections.append(section)
        return _sections
    }
    
    // MARK: - Private Class Methods
    
    private class func stringFromCurrentAuthorizationStatus() -> String {
        return stringFrom(authorizationStatus: CLLocationManager.authorizationStatus())
    }
    
    private class func stringFrom(authorizationStatus: CLAuthorizationStatus) -> String {
        switch authorizationStatus {
            case .authorizedAlways:                     return String.PERMISSION_LOCATION_ALWAYS
            case .authorizedWhenInUse:                  return String.PERMISSION_LOCATION_WHEN_IN_USE
            case .denied, .restricted, .notDetermined:  return String.PERMISSION_LOCATION_NEVER
        }
    }
    
    private class func stringForAuthorizationStatusAlways() -> String {
          return String(format: String.PERMISSION_LOCATION_NEED_ACCESS_ALWAYS, stringFromCurrentAuthorizationStatus(), stringFrom(authorizationStatus: .authorizedAlways))
    }
    
    private class func stringForAuthorizationStatusWhenInUse() -> String {
        return String(format: String.PERMISSION_LOCATION_NEED_ACCESS, stringFromCurrentAuthorizationStatus(), stringFrom(authorizationStatus: .authorizedWhenInUse), stringFrom(authorizationStatus: .authorizedAlways))
    }
    
}
