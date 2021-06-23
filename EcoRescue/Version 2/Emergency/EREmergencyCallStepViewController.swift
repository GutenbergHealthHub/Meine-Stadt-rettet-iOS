//
//  EREmergencyCallStepViewController.swift
//  EcoRescue
//
//  Created by Birtan on 03.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class EREmergencyCallStepViewController: UIViewController, ERDataManagerDelegate {
    
    weak var delegate: StepsViewControllerDelegate?
    
    let dataManager = ERDataManager.sharedManager
    
    var emergencyState: EREmergencyState? { didSet { setEmergencyState(oldValue: oldValue) } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.addObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.removeObserver(self)
    }
    
    private func setEmergencyState(oldValue: EREmergencyState?) {
        if oldValue == emergencyState { return }
        
    }
    
    func dataManagerDidCancelEmergencyState(dataManager: ERDataManager, emergencyState: EREmergencyState) {
        if let emergency = self.emergencyState, emergency.objectId == emergencyState.objectId {
            delegate?.finalizeSteps(with: emergencyState, cancel: true, expired: false)
        }
    }
    
    func dataManagerDidUpdateEmergencyState(dataManager: ERDataManager, emergencyState: EREmergencyState) {
        if let emergency = self.emergencyState, emergency.objectId == emergencyState.objectId {
            self.emergencyState = emergencyState
        }
    }


}
