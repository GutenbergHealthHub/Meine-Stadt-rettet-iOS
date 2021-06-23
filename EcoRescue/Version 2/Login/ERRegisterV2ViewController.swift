//
//  ERRegisterV2ViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 23.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERRegisterV2ViewController: ERLoginStepViewController {
    
    private let emailLabel = UILabel.type2SemiBoldLabel()
    private let passwordLabel = UILabel.type2SemiBoldLabel()
    private let passwordRepeatLabel = UILabel.type2SemiBoldLabel()
    private let passwordWarningLabel = UILabel.type2LightLabel(.footnote)
    
    private let emailTextField          = ERRectangleTextField()
    private let passwordTextField       = ERRectangleTextField()
    private let passwordRepeatTextField = ERRectangleTextField()
    
    private let registerButton       = ERButton()
    private let noRegistrationButton = UIButton.button()
    
    private let registerPageButton = UIButton.button()
    private let loginPageButton    = UIButton.button()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.addSubview(registerPageButton)
        topView.addSubview(loginPageButton)
        
        registerPageButton.bottom(constant: UIViewPadding.medium).right(constant: UIViewPadding.big).apply()
        loginPageButton.bottom(constant: UIViewPadding.medium).left(constant: UIViewPadding.big).apply()
        
        progressViewRight.backgroundColor = UIColor.colorIntroProgressBarV2
        
        registerPageButton.setTitle(String.REGISTER, for: .normal)
        loginPageButton.setTitle(String.LOGIN, for: .normal)
        registerPageButton.setTitleColor(UIColor.white, for: .normal)
        loginPageButton.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .normal)
        registerPageButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        loginPageButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        registerButton.titleLabel?.adjustsFontForContentSizeCategory = true
        loginPageButton.titleLabel?.adjustsFontForContentSizeCategory = true
        loginPageButton.addTarget(self, action: #selector(didTapLoginPage(sender:)), for: .touchUpInside)
        
        registerPageButton.isEnabled = false
        loginPageButton.isEnabled = true
        
        containerView.addSubview(emailLabel)
        containerView.addSubview(emailTextField)
        containerView.addSubview(passwordLabel)
        containerView.addSubview(passwordTextField)
        containerView.addSubview(passwordRepeatLabel)
        containerView.addSubview(passwordRepeatTextField)
        containerView.addSubview(passwordWarningLabel)
        bottomContainerView.addSubview(registerButton)
        bottomContainerView.addSubview(noRegistrationButton)
        
        emailLabel.top(constant: UIViewPadding.medium).leftright().apply()
        emailTextField.bottom(of: emailLabel, constant: UIViewPadding.small).leftright().apply()
        passwordLabel.bottom(of: emailTextField, constant: UIViewPadding.big).left().apply()
        passwordTextField.bottom(of: passwordLabel, constant: UIViewPadding.small).leftright().apply()
        passwordRepeatLabel.bottom(of: passwordTextField, constant: UIViewPadding.big).left().apply()
        passwordRepeatTextField.bottom(of: passwordRepeatLabel, constant: UIViewPadding.small).leftright().apply()
        passwordWarningLabel.bottom(of: passwordRepeatTextField, constant: UIViewPadding.small).leftright().apply()
        
        registerButton.top(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        noRegistrationButton.bottom(of: registerButton, constant: UIViewPadding.medium).bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        
        setViews()
        
        enableRegisterButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.clearTextFields()
    }
    
    private func setViews() {
        emailLabel.text = String.EMAIL
        //emailTextField.placeholder = "Email"
        passwordLabel.text  = String.PASSWORD
        passwordRepeatLabel.text = String.REPEAT_PASSWORD
        passwordWarningLabel.text = String.PASSWORD_DETAIL
        passwordWarningLabel.numberOfLines = 0
        
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry  = true
        passwordRepeatTextField.isSecureTextEntry = true
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordRepeatTextField.delegate = self
        emailTextField.addTarget(self, action: #selector(didChangeValue(sender:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .touchDown)
        passwordTextField.addTarget(self, action: #selector(didChangeValue(sender:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .touchDown)
        passwordRepeatTextField.addTarget(self, action: #selector(didChangeValue(sender:)), for: .editingChanged)
        passwordRepeatTextField.addTarget(self, action: #selector(textFieldChanged(_:)), for: .touchDown)
        
        registerButton.text = String.REGISTER
        noRegistrationButton.setTitle(String.ENTER_WITHOUT_REGISTRATION, for: .normal)

        registerButton.addTarget(self, action: #selector(didTapRegister(sender:)), for: .touchUpInside)
        
        noRegistrationButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        noRegistrationButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .callout)
        noRegistrationButton.titleLabel?.minimumScaleFactor = 0.8
        noRegistrationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        noRegistrationButton.titleLabel?.adjustsFontForContentSizeCategory = true
        noRegistrationButton.addTarget(self, action: #selector(didTapNoRegister(sender:)), for: .touchUpInside)
    }
    
    private func enableRegisterButton() {
        if String.isEmpty(string: email) || String.isEmpty(string: password) || String.isEmpty(string: passwordRepeated) {
            registerButton.alpha = 0.5
            registerButton.isEnabled = false
        } else {
            registerButton.alpha = 1
            registerButton.isEnabled = true
        }
    }
    
    func clearTextFields() {
        emailTextField.text    = ""
        passwordTextField.text = ""
        passwordRepeatTextField.text = ""
    }
    
    var email: String? {
        return emailTextField.text?.lowercased()
    }
    
    var password: String? {
        return passwordTextField.text
    }
    
    var passwordRepeated: String? {
        return passwordRepeatTextField.text
    }
    
    func didTapLoginPage(sender: Any) {
        delegate?.goPreviousStep()
    }
    
    func didTapRegister(sender: Any) {
        registerUser(email: email!, password: password!, passwordRepeated: passwordRepeated!)
    }
    
    func didTapNoRegister(sender: Any) {
        delegate?.finalizeSteps()
    }
    
    func didChangeValue(sender: Any) {
        enableRegisterButton()
    }
    
    func textFieldChanged(_ sender: UITextField) {
        self.activeTextFieldFrame = sender.frame
    }
    
    func registerUser(email: String, password: String, passwordRepeated: String) {
        if invalidateEntries(email: email, password: password, passwordRepeated: passwordRepeated) {
            
            // Create new user
            let user = ERUser()
            user.username    = email
            user.email       = email
            user.password    = password
            user.pausedUntil = Date().minusDays(1)
            
            // Register
            user.signUpInBackground { (success, error) in
                
                // Error
                if let error = error as NSError? {
                    
                    print(error.code)
                    print(error)
                    
                    switch error.code {
                    case 202:
                        let title   = String.EMAIL_ALREADY_IN_USE
                        let message = String.PLEASE_USE_ANOTHER_EMAIL_ADDRESS
                        self.openAlertController(title, message: message, completion: nil)
                        break
                        
                    default:
                        let title   = String.NO_CONENCTION
                        let message = String.PLEASE_CHECK_YOUR_CONNECTION_AND_TRY_AGAIN
                        self.openAlertController(title, message: message, completion: nil)
                        break
                    }
                    
                    
                    
                    // Success
                } else {
                    ERUser.logOutInBackground()
                    self.delegate?.goNextStep()
                }
            }
        }
    }
    
    private func invalidateEntries(email: String, password: String, passwordRepeated: String?) -> Bool{
        if let _ = passwordRepeated {
            if !email.validEmailString {
                let title   = String.ERROR
                let message = String(format: String.INVALID_EMAIL_X, email)
                openAlertController(title, message: message, completion: nil)
                return false
            } else if !password.validPassword {
                let title   = String.ERROR
                let message = String.PASSWORD_DETAIL
                openAlertController(title, message: message, completion: nil)
                return false
            } else if password != passwordRepeated {
                let title   = String.ERROR
                let message = String.PASSWORDS_DO_NOT_MATCH
                openAlertController(title, message: message, completion: nil)
                return false
            }
            return true
        }
        
        return true
    }

}
