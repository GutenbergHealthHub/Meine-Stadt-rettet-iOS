//
//  EREmergencyCallPageViewController.swift
//  EcoRescue
//
//  Created by Birtan on 03.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class EREmergencyCallPageViewController: StepsPageViewController, ERFinalStepViewControllerDelegate {
    
    private let dataManager = ERDataManager.sharedManager
    
    private let callPage       = EREmergencyCallV2ViewController()
    private let pinPage        = EREmergencyCallPinV2ViewController()
    private let mapPage        = EREmergencyCallMapV2ViewController()
    private let aedTaskMapPage = EREmergencyCallAEDTaskMapV2ViewController()
    private let infoPage       = EREmergencyCallInfoV2ViewController()
    
    var emergencyState: EREmergencyState?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        callPage.delegate  = self
        pinPage.delegate = self
        mapPage.delegate  = self
        aedTaskMapPage.delegate = self
        infoPage.delegate = self
        
        reloadEmergency()
        
        if let emergencyState = emergencyState, emergencyState.stateValue == .accepted {
            dataManager.emergencyStateManager?.state = .accepted
            pages = [mapPage, infoPage]
        } else if let emergencyState = emergencyState, emergencyState.emergencyRelation.testEmergencySendBy != nil, dataManager.user?.code == nil  {
            pages = [callPage, mapPage, infoPage]
        } else {
            pages = [callPage, pinPage, mapPage, infoPage]
        }
        
        reOrderPages()
        
        
    }
    
    override func finalizeSteps() {
        super.finalizeSteps()
        self.dismiss(animated: true, completion: nil)
    }

    
    override func finalizeSteps(with: EREmergencyState?, cancel: Bool, expired: Bool) {
        super.finalizeSteps(with: with, cancel: cancel, expired: expired)
        self.emergencyState = with
        if expired {
            self.presentMissedEmergencyViewController()
        } else {
            self.presentFinalViewController(cancelled: cancel)
        }
        
    }
    
    private func reOrderPages() {
        
        if let emergencyState = emergencyState, emergencyState.emergencyTaskValue == .getAED {
            var mapIndex = 0
            for (index, page) in pages.enumerated() {
                if page is EREmergencyCallMapV2ViewController {
                    mapIndex = index
                    break
                }
            }
            pages.remove(at: mapIndex)
            pages.insert(aedTaskMapPage, at: mapIndex)
        }
    }
    
    private func presentMissedEmergencyViewController() {
        self.dismiss(animated: true, completion: {
            let vc = ERMissedEmergencyViewController()
            vc.emergencyState = self.emergencyState
            AppDelegate.topViewController?.present(vc, animated: true, completion: nil)
            })
    }
    
    private func presentFinalViewController(cancelled: Bool) {
        let vc = ERFinalStepViewController()
        vc.delegate = self
        vc.viewColor = UIColor.colorPrimaryBlue
        if !cancelled {
            vc.topTitleLabel.text    = String.PATIENT_REPORT
            vc.topTitleLabel.textColor = UIColor.white
            vc.titleLabel.text       = String.EMERGENCY_FINAL_TITLE
            vc.descriptionLabel.text = String.EMERGENCY_FINAL_DESCRIPTION
            vc.mainButton.setTitle(String.FILL_REPORT, for: .normal)
            vc.secondaryButton.setTitle(String.FILL_REPORT_LATER, for: .normal)
            vc.isSecondaryButton = true
            vc.titleImage.image = UIImage.iconContract()
        } else {
            vc.topTitleLabel.text    = String.EMERGENCY_CALL
            vc.topTitleLabel.textColor = UIColor.white
            vc.titleLabel.text       = String.EMERGENCY_CANCELLED
            vc.descriptionLabel.text = String.EMERGENCY_CANCELLED_DETAIL
            vc.mainButton.setTitle(String.GO_TO_HOME_PAGE, for: .normal)
        }
        present(vc, animated: true, completion: nil)
    }
    
    func reloadEmergency() {
        callPage.emergencyState  = self.emergencyState
        pinPage.emergencyState = self.emergencyState
        mapPage.emergencyState  = self.emergencyState
        aedTaskMapPage.emergencyState = self.emergencyState
        infoPage.emergencyState = self.emergencyState
    }
    
    // MARK: - ERFinalStepViewControllerDelegate
    
    func tapped(mainButton: Bool) {
        if mainButton {
            self.dismiss(animated: true, completion: {
                
                if self.emergencyState?.stateValue == .finished {
                    let protocolFinishedVC = ERProtocolFinishPageViewController()
                    protocolFinishedVC.emergencyState = self.emergencyState
                    AppDelegate.topViewController?.present(UINavigationController(rootViewController: protocolFinishedVC), animated: true, completion: nil)
                } else if self.emergencyState?.stateValue == .cancelled {
                    let protocolFinishedVC = ERProtocolCancelPageViewController()
                    protocolFinishedVC.emergencyState = self.emergencyState
                    AppDelegate.topViewController?.present(UINavigationController(rootViewController: protocolFinishedVC), animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }



}
