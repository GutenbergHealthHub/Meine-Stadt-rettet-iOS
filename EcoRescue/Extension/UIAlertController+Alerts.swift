//
//  UIAlertController+Alerts.swift
//  EcoRescue
//
//  Created by Christoph Erl on 01.05.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

extension UIAlertController {
    
    // MARK: - Certificate
    
    class func createCertificateSavingErrorController(message: String? = nil) -> UIAlertController {
        let message = message ?? String.AN_ERROR_HAS_OCCURED
        let ac = UCAlertController(title: String.ERROR, message: message, preferredStyle: .alert)
        ac.addBackAction(title: String.BACK)
        return ac
    }
    
    class func createCertificateSavingProgressController() -> UCProgressAlertController {
        let ac = UCProgressAlertController(title: String.PLEASE_WAIT, message: String.PROOF_OF_QUALITY_IS_SAVING, preferredStyle: .alert)
        return ac
    }
    
    class func createCertificateSavingSuccessController(completion: @escaping (()->())) -> UIAlertController {
        let ac = UCAlertController(title: String.PROOF_OF_QUALITY_IS_SAVED, message: nil, preferredStyle: .alert)
        ac.addBackAction(title: String.BACK, completion: completion)
        return ac
    }
    
    // MARK: - Contract
    
    class func createContractBasicSavingController() -> UCProgressAlertController {
        let ac = UCProgressAlertController(title: String.SAVE_BASIS_AGREEMENT, message: nil, preferredStyle: .alert)
        ac.message = String.BASIS_AGREEMENT_IS_SAVING
        return ac
    }
    
    class func createContractBasicSavingSuccessController(completion: @escaping (()->())) -> UIAlertController {
        let ac = UCAlertController(title: String.BASIS_AGREEMENT_SAVED, message: nil, preferredStyle: .alert)
        ac.addBackAction(title: String.BACK, completion: completion)
        return ac
    }
    
    class func createContractBasicLoadingController() -> UIAlertController {
        let ac = UCProgressAlertController(title: String.LOAD_BASIS_AGREEMENT, message: nil, preferredStyle: .alert)
        ac.message = String.BASIS_AGREEMENT_IS_LOADING
        ac.type = .infinite
        return ac
    }
    
    class func createContractBasicSavingErrorController() -> UIAlertController {
        let ac = UCAlertController(title: String.ERROR, message: nil, preferredStyle: .alert)
        ac.message = String.AN_ERROR_OCCURED_WHILE_SAVING_THE_BASIS_AGREEMENT
        ac.addBackAction(title: String.BACK)
        return ac
    }
    
    // MARK: - Profile
    
    class func createProfileUpdateErrorController() -> UIAlertController {
        let ac = UCAlertController(title: String.ERROR, message: nil, preferredStyle: .alert)
        ac.message = String.YOUR_PROFILE_COULD_NOT_BE_UPDATED
        ac.addBackAction(title: String.BACK)
        return ac
    }
    
    // MARK: - Protocol
    
    class func createProtocolCompletionController(completion: @escaping (()->())) -> UIAlertController {
        let ac = UCAlertController(title: String.MISSION_PROTOCOL, message: nil, preferredStyle: .alert)
        ac.message = String.THANK_YOU_FOR_UPLOADING_THE_EMERGENCY_REPORT
        ac.addBackAction(title: String.OK, completion: completion)
        return ac
    }
    
    // MARK: - Mobile AED
    
    class func createMobileAEDSavingProgressController() -> UCProgressAlertController {
        let ac = UCProgressAlertController(title: String.PLEASE_WAIT, message: String.MOBILE_AED_IS_SAVING, preferredStyle: .alert)
        return ac
    }
    
    class func createMobileAEDSavingSuccessController(completion: @escaping (()->())) -> UIAlertController {
        let ac = UCAlertController(title: String.MOBILE_AED_IS_SAVED, message: nil, preferredStyle: .alert)
        ac.addBackAction(title: String.BACK, completion: completion)
        return ac
    }
    
    class func createMobileAEDSavingErrorController() -> UIAlertController {
        let ac = UCAlertController(title: String.ERROR, message: String.MOBILE_AED_COULDN_T_SAVED, preferredStyle: .alert)
        ac.addBackAction(title: String.BACK)
        return ac
    }
    
    // MARK: - General
    
    class func createIndicatorAlertController(with message: String?) -> UIAlertController {
        let ac = UCProgressAlertController(title: String.PLEASE_WAIT, message: message, preferredStyle: .alert)
        ac.type = .infinite
        return ac
    }
    
}
