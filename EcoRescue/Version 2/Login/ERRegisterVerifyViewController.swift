//
//  ERRegisterVerifyViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 24.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit

class ERRegisterVerifyViewController: ERLoginStepViewController {
    
    private let titleLabel = UILabel.type2SemiBoldLabel()
    
    //private let checkView = UCCheckView()
    
    private let descriptionTitleLabel = UILabel.type2SemiBoldLabel()
    private let descriptionLabel = UILabel.type2LightLabel()
    
    private let verifyButton = ERButton()
    private let skipButton   = UIButton.button()
    
    private var isVerified = false
    
    var registeredEmail: String?
    var registeredPassword: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.addSubview(titleLabel)
        titleLabel.bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.large).centerX().apply()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = String.REGISTRATION_SUCCESSFULLY_FINISHED
        titleLabel.textColor = .white
        
        //containerView.addSubview(checkView)
        bottomContainerView.addSubview(verifyButton)
        bottomContainerView.addSubview(skipButton)
        containerView.addSubview(descriptionTitleLabel)
        containerView.addSubview(descriptionLabel)
        
        descriptionTitleLabel.top(constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).apply()
        descriptionLabel.bottom(of: descriptionTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        descriptionTitleLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionTitleLabel.text = String.EMAIL_VERIFICATION
        descriptionLabel.text      = String.EMAIL_VERIFICATION_DETAIL
        
        //checkView.centerX().top(constant: 2 * UIViewPadding.large).height(constant: 160).widthEqualsHeight().apply()
        //checkView.mode = .unchecked
        
        skipButton.bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        verifyButton.top(of: skipButton, constant: UIViewPadding.medium).leftright(constant: UIViewPadding.big).height(constant: UIButtonHeight.forScreenSize).apply()
        
        verifyButton.text = String.VERIFY
        skipButton.setTitle(String.SKIP, for: .normal)

        verifyButton.addTarget(self, action: #selector(didTapVerify(sender:)), for: .touchUpInside)
        
        skipButton.setTitleColor(UIColor.black, for: UIControlState.normal)
        skipButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .callout)
        skipButton.titleLabel?.minimumScaleFactor = 0.8
        skipButton.titleLabel?.adjustsFontSizeToFitWidth = true
        skipButton.titleLabel?.adjustsFontForContentSizeCategory = true
        skipButton.addTarget(self, action: #selector(didTapSkip(sender:)), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    func checkEmailVerification() {
        
        if let email = self.registeredEmail, let password = self.registeredPassword {
            verifyButton.isEnabled = false
            ERUser.logInWithUsername(inBackground: email, password: password, block: { (user, error) in
                ERUser.logOutInBackground(block: { (error) in
                    
                    if let user = user as? ERUser, user.emailVerifiedValue {
                        self.verifyButton.alpha = 0.5
                        self.skipButton.setTitle(String.FINISH, for: .normal)
                        self.skipButton.setTitleColor(UIColor.active, for: .normal)
                        self.isVerified = true
                    } else {
                        self.isVerified = false
                        self.verifyButton.isEnabled = true
                    }
                })
            })
        } else {
            self.isVerified = false
            self.verifyButton.isEnabled = true
        }
    }
    
    // MARK: Actions
    func didTapVerify(sender: Any) {
        UCUtil.openMail()
    }
    
    func didTapSkip(sender: Any) {
        if !isVerified {
            delegate?.finalizeSteps()
        } else {
            delegate?.goNextStep()
        }
    }
    
    func appWillEnterForeground() {
        checkEmailVerification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
