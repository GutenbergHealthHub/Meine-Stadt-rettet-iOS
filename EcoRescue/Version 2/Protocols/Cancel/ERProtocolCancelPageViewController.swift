//
//  ERProtocolCancelPageViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 18.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERProtocolCancelPageViewController: StepsPageViewController, ERFinalStepViewControllerDelegate {

    private let remarksPage = ERProtocolCancelRemarksViewController()
    
    private var alertController: ERAlertV2ViewController?
    
    var emergencyState: EREmergencyState? { didSet { setEmergencyState(oldValue: oldValue) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorPrimaryBlue
        self.navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
        
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        saveButton.setTitle(String.SAVE.lowercased(), for: .normal)
        saveButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        saveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        saveButton.addTarget(self, action: #selector(didTapSave(sender:)), for: .touchDown)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        let label = UILabel.type1Label()
        label.text = String.PATIENT_REPORT_PROTOCOLS
        label.textColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        addPages()
    }
    
    private func addPages() {
        pages = [remarksPage]
        for (index, vc) in pages.enumerated() {
            (vc as! StepsViewController).delegate = self
            (vc as! StepsViewController).setProgressViews(progress: Float(index+1)/Float(pages.count))
            (vc as! StepsViewController).progressLabel.text = "\(index+1)/\(pages.count)"
        }
            
        remarksPage.backButton.isHidden = true
        remarksPage.nextButton.isHidden = true
    }
    
    private func setEmergencyState(oldValue: EREmergencyState?) {
        if oldValue == emergencyState { return }
        
        if let prot = emergencyState?.protocolRelation {
            
            remarksPage.textView.text = prot.cancelComment
        }
    }
    
    private func saveProtocol(done: Bool) {
        guard let emergencyState = emergencyState else {
            return
        }
        
        var prot: ERProtocol! = emergencyState.protocolRelation
        if prot == nil {
            prot = ERProtocol()
            prot.isDone = false
            
            emergencyState.protocolRelation = prot
        }
        
        prot.isDone = done
        
        prot.cancelComment = remarksPage.textView.text
        
        emergencyState.saveInBackground()
    }
    
    private func dismissAlertController() {
        if let vc = alertController {
            vc.dismiss(animated: true, completion: nil)
            alertController = nil
        }
    }
    
    // MARK: Actions
    
    func didTapSave(sender: Any) {
        saveProtocol(done: false)
        
        alertController = ERAlertV2ViewController()
        
        alertController?.alertLabel.text = String.REPORT_SAVE_ALERT
        alertController?.alertLabel.textColor = UIColor.white
        
        let btn1 = UIButton.button()
        btn1.backgroundColor = UIColor.clear
        btn1.layer.cornerRadius = 5
        btn1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn1.setTitle(String.CONTINUE_FILLING_REPORT, for: .normal)
        btn1.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn1.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.layer.borderColor = UIColor.white.cgColor
        btn1.layer.borderWidth = 2
        btn1.addTarget(self, action: #selector(didTapContinue(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn1)
        
        let btn2 = UIButton.button()
        btn2.layer.cornerRadius = 5
        btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn2.setTitle(String.GO_TO_HOME_PAGE, for: .normal)
        btn2.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn2.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderWidth = 2
        btn2.addTarget(self, action: #selector(didTapGoHome(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn2)
        
        alertController!.providesPresentationContextTransitionStyle = true
        alertController!.definesPresentationContext = true
        alertController!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func didTapContinue(sender: Any) {
        dismissAlertController()
    }
    
    func didTapGoHome(sender: Any) {
        dismissAlertController()
        self.dismiss(animated: true, completion: {
            if let vcs = AppDelegate.topViewController?.childViewControllers{
                for vc in vcs {
                    if vc is UINavigationController {
                        (vc as! UINavigationController).popToRootViewController(animated: true)
                    }
                }
            }
        })
    }
    
    // MARK: StepsPageViewController functions
    
    override func finalizeSteps() {
        saveProtocol(done: true)
        
        let vcFinal = ERFinalStepViewController()
        vcFinal.delegate = self
        vcFinal.topTitleLabel.text    = String.PATIENT_REPORT_PROTOCOLS
        vcFinal.topTitleLabel.textColor = .white
        vcFinal.titleLabel.text       = String.REPORT_SUCCESS_TITLE
        vcFinal.descriptionLabel.text = String.REPORT_SUCCESS_DESCRIPTION
        vcFinal.mainButton.setTitle(String.GO_TO_HOME_PAGE, for: .normal)
        vcFinal.titleImage.image = UIImage.iconTickWhite().imageWithColor(UIColor.black)
        
        present(vcFinal, animated: true, completion: nil)
    }
    
    //MARK: ERFinalStepViewControllerDelegate
    func tapped(mainButton: Bool) {
        self.dismiss(animated: true, completion: {
            if let vcs = AppDelegate.topViewController?.childViewControllers{
                for vc in vcs {
                    if vc is UINavigationController {
                        (vc as! UINavigationController).popToRootViewController(animated: true)
                    }
                }
            }
        })
    }


}
