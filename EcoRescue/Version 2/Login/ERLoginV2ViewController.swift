//
//  ERLoginV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 21.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERLoginV2ViewController: ERLoginStepViewController {
    
    private let emailLabel          = UILabel.type2SemiBoldLabel()
    private let passwordLabel       = UILabel.type2SemiBoldLabel()
    private let forgotPasswordLabel = UILabel.type2LightLabel(.footnote)
    
    private let emailTextField    = ERRectangleTextField()
    private let passwordTextField = ERRectangleTextField()
    
    private let loginButton          = ERButton()
    private let noRegistrationButton = UIButton.button()
    private let forgotPasswordButton = UIButton.button()
    
    private let registerPageButton = UIButton.button()
    private let loginPageButton    = UIButton.button()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addSubview(registerPageButton)
        topView.addSubview(loginPageButton)
        
        registerPageButton.bottom(constant: UIViewPadding.medium).right(constant: UIViewPadding.big).apply()
        loginPageButton.bottom(constant: UIViewPadding.medium).left(constant: UIViewPadding.big).apply()
        
        progressViewLeft.backgroundColor = UIColor.colorIntroProgressBarV2
        
        registerPageButton.setTitle(String.REGISTER, for: .normal)
        loginPageButton.setTitle(String.LOGIN, for: .normal)
        registerPageButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        loginPageButton.setTitleColor(UIColor.white, for: .normal)
        registerPageButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        loginPageButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        registerPageButton.addTarget(self, action: #selector(didTapRegisterPage(sender:)), for: .touchUpInside)
        
        registerPageButton.isEnabled = true
        loginPageButton.isEnabled = false
        
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(forgotPasswordLabel)
        containerView.addSubview(forgotPasswordButton)
        bottomContainerView.addSubview(loginButton)
        bottomContainerView.addSubview(noRegistrationButton)
        
        emailLabel.top(constant: UIViewPadding.medium).leftright().apply()
        emailTextField.bottom(of: emailLabel, constant: UIViewPadding.small).leftright().apply()
        passwordLabel.bottom(of: emailTextField, constant: UIViewPadding.big).left().apply()
        passwordTextField.bottom(of: passwordLabel, constant: UIViewPadding.small).leftright().apply()
        forgotPasswordLabel.bottom(of: passwordTextField, constant: UIViewPadding.medium).left(constant: UIViewPadding.small).apply()
        forgotPasswordButton.centerY(to: forgotPasswordLabel).right(of: forgotPasswordLabel, constant: UIViewPadding.small).apply()
        loginButton.top(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        noRegistrationButton.bottom(of: loginButton, constant: UIViewPadding.medium).bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        
        setViews()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.clearTextFields()
    }
    
    private func setViews() {
        emailLabel.text = String.EMAIL
        passwordLabel.text  = String.PASSWORD
        forgotPasswordLabel.text = String.DID_YOU_FORGET_YOUR_PASSWORD
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry  = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(didChangeValue(sender:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .touchDown)
        passwordTextField.addTarget(self, action: #selector(didChangeValue(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .touchDown)
        
        
        loginButton.text = String.LOGIN
        noRegistrationButton.setTitle(String.ENTER_WITHOUT_REGISTRATION, for: .normal)
        forgotPasswordButton.setTitle(String.PRESS_HERE, for: .normal)
        
        loginButton.addTarget(self, action: #selector(didTapLogin(sender:)), for: .touchUpInside)
        enableLoginButton()
        
        noRegistrationButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        noRegistrationButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .callout)
        noRegistrationButton.titleLabel?.minimumScaleFactor = 0.8
        noRegistrationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        noRegistrationButton.addTarget(self, action: #selector(didTapNoRegister(sender:)), for: .touchUpInside)
        
        forgotPasswordButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        forgotPasswordButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .footnote)
        forgotPasswordButton.titleLabel?.minimumScaleFactor = 0.8
        forgotPasswordButton.titleLabel?.adjustsFontSizeToFitWidth = true
        forgotPasswordButton.addTarget(self, action: #selector(didTapForgotPassword(sender:)), for: .touchUpInside)
    }
    
    private func enableLoginButton() {
        if String.isEmpty(string: email) || String.isEmpty(string: password) {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        } else {
            loginButton.alpha = 1
            loginButton.isEnabled = true
        }
    }
    
    func clearTextFields() {
        emailTextField.text    = ""
        passwordTextField.text = ""
    }
    
    var email: String? {
        return emailTextField.text?.lowercased()
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
    func didTapRegisterPage(sender: Any) {
        delegate?.goNextStep()
    }
    
    func didTapLogin(sender: Any) {
        loginUser(email: email!, password: password!)
    }
    
    func didTapNoRegister(sender: Any) {
        delegate?.finalizeSteps()
    }
    
    func didTapForgotPassword(sender: Any) {
        resetPassword(email: email)
    }
    
    func didChangeValue(sender: Any) {
        enableLoginButton()
    }
    
    func textFieldChanged(_ sender: UITextField) {
        self.activeTextFieldFrame = sender.frame
    }
    
    func loginUser(email: String, password: String) {
        
        // Login Action
        ERDataManager.loginUser(email, password: password) { (user, error) in
            if let error = error as NSError? {
                
                switch error.code {
                    
                case 2:
                    let title   = String.EMAIL_NOT_VERIFIED
                    let message = String.PLEASE_CHECK_YOUR_INBOX
                    self.openAlertController(title, message: message, completion: nil)
                    break
                    
                case 101:
                    let title   = String.EMAIL_OR_PASSWORD_WRONG
                    let message = String.PLEASE_CHECK_YOUR_INPUT
                    self.openAlertController(title, message: message, completion: nil)
                    break
                    
                default:
                    let title   = String.NO_CONENCTION
                    let message = String.PLEASE_CHECK_YOUR_CONNECTION_AND_TRY_AGAIN
                    self.openAlertController(title, message: message, completion: nil)
                }
                
            } else if let _ = user {
                // Overview Controller
                ERDataManager.sharedManager.reloadEmergencyStates()
                
                self.dismiss(animated: true, completion: nil)
            }

        }
    }
    
    func resetPassword(email: String?) {
        
        if !String.isEmpty(string: email), let username = email {
            
            ERDataManager.resetPassword(username) { (success, error) in
                
                if(success) {
                    let title   = String.AN_EMAIL_HAS_BEEN_SENT
                    let message = String.PLEASE_CHECK_YOUR_INBOX
                    self.openAlertController(title, message: message, completion: nil)
                } else {
                    if let error = error as NSError? {
                        
                        switch error.code {
                            
                        case 205:
                            let title   = String.EMAIL_ADDRESS_DOES_NOT_EXIST
                            let message = String.PLEASE_CHECK_THE_ADDRESS
                            self.openAlertController(title, message: message, completion: nil)
                            break
                            
                        default:
                            let title   = String.EMAIL_COULDN_T_SEND
                            let message = String.PLEASE_TRY_AGAIN_LATER
                            self.openAlertController(title, message: message, completion: nil)
                        }
                        
                    }
                }
            }
        } else {
            let title   = String.PLEASE_PROVIDE_AN_EMAIL
            let message = String.PLEASE_PROVIDE_AN_EMAIL
            self.openAlertController(title, message: message, completion: nil)
        }
    }
    
    func enterWithoutRegister() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func activeTextField(ofFrame: CGRect) {
        self.activeTextFieldFrame = ofFrame
    }
    
    //View Animations
    
    private func animateBottomViews(view: UIView, alpha: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { view.alpha = alpha }, completion: completion)
    }


}
