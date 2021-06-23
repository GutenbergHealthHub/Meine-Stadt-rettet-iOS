//
//  ERSettingsV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 07.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERSettingsV2ViewController: CenterMenuViewController, UIPopoverPresentationControllerDelegate, ERPopOverTableViewControllerDelegate {
    
    let dataManager = ERDataManager.sharedManager
    
    private let soundManager = ERSoundManager()
    
    private let toneListView = ERRectangleView()
    
    private let testAlarmCheckbox = ERCheckBoxView()
    
    private var alarmIndex: Int?
    
    private var alertController: ERAlertV2ViewController?
    
    private var deletingProgressController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = String.SETTINGS
        
        view.backgroundColor = UIColor.background
        
        let containerView = UIView.view()
        view.addSubview(containerView)
        containerView.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
        
        // containerView - toneLabel
        let toneLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(toneLabel)
        toneLabel.left().top().apply()
        toneLabel.text = String.CHANGE_TONE
        
        // containerView - toneDetailLabel
        let toneDetailLabel = UILabel.type2LightLabel()
        containerView.addSubview(toneDetailLabel)
        toneDetailLabel.leftright().bottom(of: toneLabel, constant: UIViewPadding.small).apply()
        toneDetailLabel.text = String.SELECT_ONE_OF_THE_TONES_FROM_THE_LIST
        
        // containerView - toneListView
        containerView.addSubview(toneListView)
        toneListView.leftright(constant: UIViewPadding.small).bottom(of: toneDetailLabel, constant: UIViewPadding.medium).height(constant: 40).apply()
        toneListView.backgroundColor = UIColor.white
        
        // containerView - testAlarmCheckbox
        containerView.addSubview(testAlarmCheckbox)
        testAlarmCheckbox.bottom(of: toneListView, constant: UIViewPadding.large).left().width(constant: 20).heightEqualsWidth().apply()
        testAlarmCheckbox.addTarget(target: self, action: #selector(didTapCheckbox(sender:)))
        
        // Container view - testAlarmTitleLabel
        let testAlarmTitleLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(testAlarmTitleLabel)
        testAlarmTitleLabel.bottom(of: toneListView, constant: UIViewPadding.large).right(of: testAlarmCheckbox, constant: UIViewPadding.medium).right().apply()
        testAlarmTitleLabel.text = String.RECEIVE_TEST_ALARM_ON_SATURDAY
        testAlarmTitleLabel.numberOfLines = 0
        
        // Container view - testAlarmInfoTitleLabel
        let testAlarmButton = UIButton.button()
        containerView.addSubview(testAlarmButton)
        testAlarmButton.bottom(of: testAlarmTitleLabel, constant: UIViewPadding.medium).left().right().apply()
        testAlarmButton.addTarget(self, action: #selector(didTapSendEmergencyNow(sender:)), for: .touchDown)
        testAlarmButton.titleLabel?.numberOfLines = 0
        testAlarmButton.titleLabel?.textAlignment = .left
        testAlarmButton.titleLabel?.adjustsFontSizeToFitWidth = true
        testAlarmButton.titleLabel?.minimumScaleFactor = 0.8
        
        let attributedTitle = NSMutableAttributedString(string: String.TEST_EMERGENCY_BUTTON_TITLE, attributes: [NSFontAttributeName: UIFont.openSansLight(textStyle: .callout), NSForegroundColorAttributeName: UIColor.black])
        attributedTitle.append(NSAttributedString(string: String.PRESS_HERE, attributes: [NSFontAttributeName: UIFont.openSansLight(textStyle: .callout), NSForegroundColorAttributeName: UIColor.colorPrimaryRedV2
            ]))
        testAlarmButton.setAttributedTitle(attributedTitle, for: .normal)
        
        
        // containerView - logoutButton
        let logoutButton = ERButton()
        containerView.addSubview(logoutButton)
        logoutButton.bottom().leftright(constant: UIViewPadding.big).apply()
        logoutButton.text = String.LOG_OUT
        logoutButton.addTarget(self, action: #selector(didTapLogout(sender:)), for: .touchDown)
        
        // containerView - deleteAccountButton
        let deleteAccountButton = ERButton()
        containerView.addSubview(deleteAccountButton)
        deleteAccountButton.top(of: logoutButton, constant: UIViewPadding.medium).leftright(constant: UIViewPadding.big).apply()
        deleteAccountButton.backgroundColor = UIColor.gray
        deleteAccountButton.text = String.DELETE_ACCOUNT
        deleteAccountButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        deleteAccountButton.addTarget(self, action: #selector(didTapDeleteAccount(sender:)), for: .touchDown)
        
        let toneListTap = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        toneListView.addGestureRecognizer(toneListTap)
        
        reloadData()
    }
    
    private func reloadData() {
        if let user = self.dataManager.user {
            testAlarmCheckbox.check = user.receivesPracticeAlarm?.boolValue ?? false
            toneListView.label.text = ERSoundManager.titleForFilename(ERDataManager.sharedManager.user?.sound ?? "") ?? String.NOT_SPECIFIED
        }
    }
    
    private func save(_ soundIndex: Int? = nil) {
        if let user = self.dataManager.user {
            if let soundIndex = soundIndex {
                user.sound = ERSoundManager.sounds[soundIndex].filename
            }
            user.receivesPracticeAlarm = testAlarmCheckbox.check as NSNumber?
            user.saveEventually()
        }
    }
    
    // MARK: Actions
    
    func tapHandler (_ sender:UITapGestureRecognizer) {
        let vc = ERSettingsPopOverViewController()
        vc.delegate = self
        vc.soundManager  = soundManager
        vc.selectedSound = ERSoundManager.titleForFilename(ERDataManager.sharedManager.user?.sound ?? "")
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize   = CGSize(width: (toneListView).frame.width, height: 300)
        
        if let pres = vc.presentationController {
            pres.delegate = self
        }
        
        self.present(vc, animated: true)
        if let ppc = vc.popoverPresentationController {
            ppc.sourceView = (toneListView)
            ppc.sourceRect = (toneListView).bounds
            ppc.permittedArrowDirections = .up
        }
    }
    
    func didTapCheckbox(sender: ERCheckBoxView) {
        sender.check = !sender.check
        save()
    }
    
    func didTapDeleteAccount(sender: Any) {
        alertController = ERAlertV2ViewController()
        
        alertController?.alertLabel.text = String.DELETE_ACCOUNT_ALERT
        alertController?.alertLabel.textColor = UIColor.white
        
        let btn1 = UIButton.button()
        btn1.backgroundColor = UIColor.clear
        btn1.layer.cornerRadius = 5
        btn1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn1.setTitle(String.DELETE_ACCOUNT, for: .normal)
        btn1.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn1.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn1.layer.borderColor = UIColor.white.cgColor
        btn1.layer.borderWidth = 2
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(didTapConfirmDelete(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn1)
        
        let btn2 = UIButton.button()
        btn2.layer.cornerRadius = 5
        btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn2.setTitle(String.CANCEL, for: .normal)
        btn2.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn2.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn2.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderWidth = 2
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.addTarget(self, action: #selector(didTapCancelDelete(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn2)
        
        alertController!.providesPresentationContextTransitionStyle = true
        alertController!.definesPresentationContext = true
        alertController!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func didTapConfirmDelete(sender: Any) {
        self.alertController?.dismiss(animated: true, completion: {
            self.deletingProgressController = UIAlertController.createIndicatorAlertController(with: nil)
            self.present(self.deletingProgressController, animated: true, completion: nil)
            if let user = ERUser.current(), let objectId = user.objectId {
                self.dataManager.deleteAccount(objectId) { (success, error) in
                    self.deletingProgressController.dismiss(animated: true, completion: {
                        if success {
                            self.delegate?.changeViewController!(to: 1)
                        } else {
                            self.openAlertController(String.ERROR, message: String.PLEASE_TRY_AGAIN_LATER, completion: nil)
                        }
                    })
                }
            }
        })
    }
    
    func didTapCancelDelete(sender: Any) {
        self.alertController?.dismiss(animated: true, completion: nil)
    }
    
    func didTapSendEmergencyNow(sender: Any) {
        self.deletingProgressController = UIAlertController.createIndicatorAlertController(with: nil)
        self.present(self.deletingProgressController, animated: true, completion: nil)
        if let user = ERUser.current(), let objectId = user.objectId {
            self.dataManager.sendTestEmergency(objectId) { (success, error) in
                self.deletingProgressController.dismiss(animated: true, completion: {
                    if !success {
                        self.openAlertController(String.ERROR, message: String.PLEASE_TRY_AGAIN_LATER, completion: nil)
                    }
                })
            }
        }
    }
    
    func didTapLogout(sender: Any) {
        self.dataManager.logoutUser(completion: { (error) in
            self.delegate?.changeViewController!(to: 1)
        })
    }
    
    //MARK: UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        soundManager.stop()
        save(alarmIndex)
    }
    
    //MARK: ERPopOverTableViewControllerDelegate
    func selectedText(text: String, index: Int) {
        toneListView.label.text = text
        alarmIndex = index
    }
    
    //MARK: Alerts
    func openAlertController(_ title: String?, message: String?, completion: (() -> ())? = nil) {
        let cancelAction = UIAlertAction(title: String.BACK, style: .default) { (action) in completion?() }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
