
//
//  ERSubContractEditSignatureV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 26.07.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit
import Parse

class ERSubContractEditSignatureV2ViewController: ERContractEditSignatureV2ViewController {
    
    var subContract: ERContractSub?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didTapSave(sender: Any) {
        if let contract = subContract, let image = signatureView.signatureImage, let data = UIImageJPEGRepresentation(image, 0.3),
            let file = PFFileObject(name: "sign.jpg", data: data), let user = ERUser.current() {
            
            // Alert Controller
            let alertController = UCProgressAlertController.createContractBasicSavingController()
            present(alertController, animated: true, completion: nil)
            
            // Save Signature
            file.saveInBackground({ (success, error) in
                
                if success {
                    
                    let userContractSub = ERUserContractSub()
                    userContractSub.contract  = contract
                    userContractSub.signature = file
                    userContractSub.user      = user
                    userContractSub.signedAt  = Date()
                    
                    userContractSub.saveInBackground(block: { (success, error) in
                        self.completionHandler(alertController: alertController, success: success, error: error)
                    })
                    
                } else {
                    self.present(UIAlertController.createContractBasicSavingErrorController(), animated: true, completion: nil)
                }
                
            }, progressBlock: { (progress) in
                alertController.progress = Float(progress) / 100
            })
            
        }
    }

}
