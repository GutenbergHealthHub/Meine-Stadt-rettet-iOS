//
//  ERContractEditSignatureV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 23.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import Parse

class ERContractEditSignatureV2ViewController: UIViewController, ERSignatureViewDelegate, ERFinalStepViewControllerDelegate {
    
    var contract: ERContract? { didSet { setContract(oldValue: oldValue) } }
    
    let signatureView = ERSignatureView()
    
    private let descriptionView = ERDescriptionView()
    
    private let saveButton    = ERButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //title = "Sign"
        view.backgroundColor = UIColor.white
        
        // Description view
        view.addSubview(descriptionView)
        descriptionView.top().leftright().height(multiplier: 0.2).apply()
        descriptionView.image = UIImage.iconContract().withRenderingMode(.alwaysTemplate)
        descriptionView.text  = String.AGREEMENT_INFO
        
        //Button
        view.addSubview(saveButton)
        saveButton.leftright(constant: UIViewPadding.big).bottom(constant: UIViewPadding.big).apply()
        saveButton.setTitle(String.SAVE_AND_SEND, for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSave(sender:)), for: .touchDown)
        
        //Signature View
        view.addSubview(signatureView)
        signatureView.bottom(of: descriptionView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).top(of: saveButton, constant: UIViewPadding.big).apply()
        
        
    }
    
    private func setContract(oldValue: ERContract?) {
        if contract == oldValue { return }
    }
    
    func didTapSave(sender: Any) {
        if let contract = contract, let image = signatureView.signatureImage, let data = UIImageJPEGRepresentation(image, 0.3),
            let file = PFFileObject(name: "sign.jpg", data: data), let user = ERUser.current() {
            
            // Alert Controller
            let alertController = UCProgressAlertController.createContractBasicSavingController()
            present(alertController, animated: true, completion: nil)
            
            // Save Signature
            file.saveInBackground({ (success, error) in
                
                if success {
                    
                    let userContract = ERUserContract()
                    userContract.contract  = contract
                    userContract.signature = file
                    userContract.signedAt  = Date()
                    
                    user.userContractBasic = userContract
                    user.saveInBackground(block: { (success, error) in
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
    
    func completionHandler(alertController: UIAlertController, success: Bool, error: Error?) {
        alertController.dismiss(animated: true) {
            if success {
                self.present(UIAlertController.createContractBasicSavingSuccessController {
                    self.dismiss(animated: true, completion: nil)
                    self.goSuccessPage()
                }, animated: true, completion: nil )
                
            } else {
                self.present(UIAlertController.createContractBasicSavingErrorController(), animated: true, completion: nil)
            }
        }
    }
    
    private func goSuccessPage() {
        let vcFinal = ERFinalStepViewController()
        vcFinal.delegate = self
        vcFinal.topTitleLabel.text    = String.AGREEMENT
        vcFinal.topTitleLabel.textColor = .white
        vcFinal.titleLabel.text       = String.AGREEMENT_FINAL_TEXT
        vcFinal.descriptionLabel.text = String.AGREEMENT_DESCRIPTION_TEXT
        vcFinal.detailLabel.text      = String.AGREEMENT_DETAIL_TEXT
        vcFinal.mainButton.setTitle(String.GO_TO_PROFILE, for: .normal)
        vcFinal.titleImage.image = UIImage.iconContract()
        present(vcFinal, animated: true, completion: nil)
    }
    
    // MARK: - ERSignatureViewDelegate
    func signatureViewDidStartDrawing(signatureView: ERSignatureView) {
        
    }
    
    func signatureViewDidStopDrawing(signatureView: ERSignatureView) {
        saveButton.isEnabled = signatureView.containsSignature
    }
    
    func signatureViewDidDeleteDrawing(signatureView: ERSignatureView) {
        saveButton.isEnabled = false
    }
    
    //MARK: ERFinalStepViewControllerDelegate
    func tapped(mainButton: Bool) {
        for vc in (self.navigationController?.viewControllers ?? []) {
            if vc is ERProfileV2ViewController {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }

}
