//
//  MapBarItemArrowControl.swift
//  EcoRescue
//
//  Created by Christoph Erl on 03.04.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation

class ErrorLocationMapBar: Control, CLLocationManagerDelegate {
    
    private var status  = CLLocationManager.authorizationStatus() { didSet { p_setStatus(oldValue: oldValue) } }
    
    // Views
    private let label   = UILabel.bodyLabel
    
    // Manager
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        layer.borderColor = UIColor.separator.cgColor
        layer.borderWidth = 0.5
        
        let visualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        visualEffect.translatesAutoresizingMaskIntoConstraints = false
        visualEffect.clipsToBounds = true
        
        label.font          = UIFont.createFont(textStyle: .callout, weight: UIFontWeightMedium)
        label.textColor     = UIColor.theme
        label.text          = "Geben Sie Ihren Standort frei, um Ihre Position auf der Karte anzuzeigen."
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isUserInteractionEnabled = false
        
        // Add Subviews
        addSubview(visualEffect)
        addSubview(label)
        visualEffect.match().apply()
        
        // Manager
        locationManager.delegate = self
        
        // Set Status
        p_updateStatus()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didChangeTouching(isTouching: Bool) {
        super.didChangeTouching(isTouching: isTouching)
        label.alpha = isTouching ? 0.3 : 1
        
        sendActions(for: .touchUpInside)
    }
    
    // MARK: - CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
    }
    
    // MARK: - Private Methods
    
    private func p_setStatus(oldValue: CLAuthorizationStatus) {
        if oldValue == status { return }
        p_updateStatus()
    }
    
    private func p_updateStatus() {
        label.removeConstraints()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            label.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.medium).apply();
            break
        }
    }
    
}
