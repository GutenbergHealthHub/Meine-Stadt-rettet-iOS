//
//  EREmergencyCallPinV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 02.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import LocalAuthentication

class EREmergencyCallPinV2ViewController: EREmergencyCallStepViewController, ERPinViewV2Delegate {
    
    private let pinView = ERPinViewV2(type: .emergency)
    
    private let touchIDButton = UIButton.button()
    
    private let touchIDLabel = UILabel.type2LightLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.colorPrimaryBlue
        
        // containerView
        let containerView = UIView.view()
        view.addSubview(containerView)
        containerView.match(constant: UIViewPadding.big + statusBarHeight).apply()
        
        // containerView - logoImageView
        let logoImageView = UIImageView.imageView()
        containerView.addSubview(logoImageView)
        logoImageView.top(constant: UIViewPadding.big).centerX().height(constant: 50).widthEqualsHeight().apply()
        logoImageView.image = UIImage.iconLogoV2()
        logoImageView.contentMode = .scaleAspectFit
        
        // containerView - separatorView1 - separatorView2
        let separatorView1 = UIView.seperatorView()
        containerView.addSubview(separatorView1)
        separatorView1.centerY(to: logoImageView).left().left(of: logoImageView, constant: UIViewPadding.big).height(constant: 1).apply()
        separatorView1.backgroundColor = UIColor.white
        
        let separatorView2 = UIView.seperatorView()
        containerView.addSubview(separatorView2)
        separatorView2.centerY(to: logoImageView).right().right(of: logoImageView, constant: UIViewPadding.big).height(constant: 1).apply()
        separatorView2.backgroundColor = UIColor.white
        
        // Container view - titleLabel
        let titleLabel = UILabel.type1Label()
        containerView.addSubview(titleLabel)
        titleLabel.leftright().bottom(of: logoImageView, constant: UIViewPadding.large + UIViewPadding.medium).apply()
        titleLabel.text = String.INSERT_YOUR_PIN_TO_ACCEPT_EMERGENCY_CALL
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        // Container view - pinView
        containerView.addSubview(pinView)
        pinView.bottom(of: titleLabel, constant: UIViewPadding.large + UIViewPadding.big).centerX().width(constant: 230).apply()
        pinView.delegate = self
        
        // Container view - touchIDButton
        containerView.addSubview(touchIDButton)
        touchIDButton.bottom(of: pinView, constant: UIViewPadding.large + UIViewPadding.big).centerX().height(constant: 42).widthEqualsHeight().apply()
        touchIDButton.setImage(UIImage.iconTouchID(), for: .normal)
        touchIDButton.tintColor = UIColor.white
        touchIDButton.addTarget(self, action: #selector(didTapTouchID(sender:)), for: .touchUpInside)
        
        // Container view - touchIDLabel
        containerView.addSubview(touchIDLabel)
        touchIDLabel.bottom(of: touchIDButton, constant: UIViewPadding.medium).leftright().apply()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pinView.focus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pinView.unfocus()
    }
    
    func didTapTouchID(sender: Any) {
        pinView.unfocus()
        showIDTouch()
    }
    
    func didEnterCode(code: String) {
        if let user = dataManager.user, let userCode = user.code, userCode == code {
            authorized()
        } else {
            pinView.reset(vibrating: true)
        }
    }
    
    private func authorized() {
        if let _ = emergencyState {
            dataManager.emergencyStateManager?.state = .accepted
            
            delegate?.goNextStep()
        }
    }
    
    private func showIDTouch() {
        
        var error: NSError?
        let context = LAContext()
        
        if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: String.PLEASE_AUTHENTICATE_WITH_YOUR_FINGERPRINT, reply: { (success, error) in
                
                DispatchQueue.main.async {
                    // Error
                    if let error = error as NSError? {
                        
                        switch error.code {
                            
                        case LAError.Code.authenticationFailed.rawValue:
                            self.touchIDLabel.text          = String.NOT_AVAILABLE
                            self.touchIDButton.isEnabled    = false
                            self.touchIDButton.isHidden     = false
                            
                            self.focusCode()
                            break
                            
                        case LAError.Code.userCancel.rawValue, LAError.Code.userFallback.rawValue:
                            self.touchIDLabel.text          = nil
                            self.touchIDButton.isEnabled    = true
                            self.touchIDButton.isHidden     = false
                            
                            self.focusCode()
                            break
                            
                        case LAError.Code.systemCancel.rawValue:
                            self.touchIDLabel.text          = nil
                            self.touchIDButton.isEnabled    = true
                            self.touchIDButton.isHidden     = false
                            break
                            
                        default: // Touch ID not available
                            
                            self.touchIDLabel.text          = nil
                            self.touchIDButton.isEnabled    = false
                            self.touchIDButton.isHidden     = true
                            
                            self.focusCode()
                            break
                        }
                        
                        // Success
                    } else {
                        if success {
                            self.authorized()
                            
                            self.touchIDLabel.text          = nil
                            self.touchIDButton.isEnabled    = false
                            self.touchIDButton.isHidden     = false
                        }
                    }
                }
            })
        } else {
            self.touchIDLabel.text          = nil
            self.touchIDButton.isEnabled    = false
            self.touchIDButton.isHidden     = false
            
            focusCode()
        }
        
    }
    
    private func focusCode() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.pinView.focus()
        }
    }



}
