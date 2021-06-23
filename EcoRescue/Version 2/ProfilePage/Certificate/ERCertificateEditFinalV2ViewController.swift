//
//  ERCertificateEditFinalV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 20.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import Parse

class ERCertificateEditFinalV2ViewController: UIViewController {
    
    private let descriptionView = ERDescriptionView()
    private let imageContainer  = UIView.view()
    private let imageView       = UIImageView.imageView()
    
    private var certificateFile: PFFileObject? { didSet { setCertificateFile(oldValue: oldValue) } }
    
    var image: UIImage? { didSet { setImage(oldValue: oldValue) } }
    
    var certificate: ERCertificate?
    var certificateType = ERCertificateType.firstResponder
    
    private var savingProgressController: UCProgressAlertController!
    
    private var alertController: ERAlertV2ViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = String.CERTIFICATE
        view.backgroundColor = UIColor.white
        
        // Description view
        view.addSubview(descriptionView)
        descriptionView.top().leftright().height(multiplier: 0.2).apply()
        descriptionView.image = UIImage.iconCertificateV2().withRenderingMode(.alwaysTemplate)
        descriptionView.text  = String.CERTIFICATE_FINAL_DESCRIPTION
        
        // ImageContainer
        view.addSubview(imageContainer)
        imageContainer.bottom(of: descriptionView, constant: 0).leftright().height(multiplier: 0.5).apply()
        
        imageContainer.backgroundColor = UIColor.background
        
        // ImageContainer - imageView
        imageContainer.addSubview(imageView)
        imageView.centerX().topbottom().width(multiplier: 0.5).apply()
        
        imageView.contentMode = .scaleAspectFit
        
        
        // Buttons
        let cancelButton = ERButton()
        let saveButton   = ERButton()
        
        view.addSubview(saveButton)
        saveButton.bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).height(constant: 44).apply()
        
        view.addSubview(cancelButton)
        cancelButton.top(of: saveButton, constant: UIViewPadding.medium).leftright(constant: UIViewPadding.big).height(constant: 44).apply()
        
        cancelButton.backgroundColor = UIColor.gray
        cancelButton.text = String.CANCEL
        cancelButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(didTapCancel(sender:)), for: .touchDown)
        
        saveButton.backgroundColor = UIColor.colorPrimaryBlue
        saveButton.text = String.SAVE_AND_SEND
        saveButton.addTarget(self, action: #selector(didTapSave(sender:)), for: .touchDown)
        
    }
    
    func setImage(oldValue: UIImage?) {
        if image == oldValue { return }
        
        if let data = UIImageJPEGRepresentation(image!, 0.5)  {
            self.certificateFile = PFFileObject(name: "certificate.jpg", data: data)
            self.imageView.image = image
        }
    }
    
    func setCertificateFile(oldValue: PFFileObject?) {
        if certificateFile == oldValue { return }
    }
    
    func didTapCancel(sender: Any) {
        alertController = ERAlertV2ViewController()
        
        alertController?.alertLabel.text = String.CERTIFICATE_LEAVE_ALERT
        alertController?.alertLabel.textColor = UIColor.white
        
        let btn1 = UIButton.button()
        btn1.backgroundColor = UIColor.clear
        btn1.layer.cornerRadius = 5
        btn1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn1.setTitle(String.LEAVE_THIS_PAGE, for: .normal)
        btn1.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn1.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn1.layer.borderColor = UIColor.white.cgColor
        btn1.layer.borderWidth = 2
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(didTapLeave(sender:)), for: .touchDown)
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
        btn2.addTarget(self, action: #selector(didTapStay(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn2)
        
        alertController!.providesPresentationContextTransitionStyle = true
        alertController!.definesPresentationContext = true
        alertController!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func didTapStay(sender: Any) {
        alertController?.dismiss(animated: true, completion: nil)
    }
    
    func didTapLeave(sender: Any) {
        alertController?.dismiss(animated: true, completion: {
            for vc in (self.navigationController?.viewControllers ?? []) {
                if vc is ERProfileV2ViewController {
                    _ = self.navigationController?.popToViewController(vc, animated: true)
                    break
                }
            }
        })
    }
    
    func didTapSave(sender: Any) {
        
        if let file = certificateFile, let user = ERUser.current() {
            
            // Setup Object
            var certificateToSave: ERCertificate! = certificate
            if certificateToSave == nil {
                certificateToSave = ERCertificate()
            }
            
            // Set Data
            certificateToSave.title         = ERCertificateType.stringWith(type: certificateType)
            certificateToSave.typeValue     = certificateType
            certificateToSave.stateValue    = .review
            certificateToSave.file          = file
            
            // Save Data
            savingProgressController = UIAlertController.createCertificateSavingProgressController()
            present(savingProgressController, animated: true, completion: nil)
            
            file.saveInBackground({ (success, error) in
                if success {
                    
                    if self.certificate == nil {
                        
                        certificateToSave.saveInBackground(block: { (success, errro) in
                            if success {
                                self.save(user: user, certificate: certificateToSave)
                            } else {
                                self.saveCompletionHandler(certificate: nil, error: error)
                            }
                        })
                        
                    } else {
                        certificateToSave.saveInBackground(block: { (success, error) in
                            if success, self.certificateType == .firstResponder {
                                if let user = ERUser.current() {
                                    
                                    // Add File To Certificate & Add Certificate To User
                                    user.activated = false as NSNumber?
                                    user.saveInBackground(block: { (success, error) in
                                        self.saveCompletionHandler(certificate: nil, error: error)
                                    })
                                } else {
                                    self.saveCompletionHandler(certificate: nil, error: NSError())
                                }
                            } else {
                                self.saveCompletionHandler(certificate: nil, error: error)
                            }
                        })
                    }
                    
                } else {
                    self.savingProgressController.dismiss(animated: true, completion: {
                        self.present(UIAlertController.createCertificateSavingErrorController(), animated: true, completion: nil)
                    })
                }
                
            }, progressBlock: { (progress) in
                self.savingProgressController.progress = Float(progress) / 100
            })
        }
    }
    
    private func save(user: ERUser, certificate: ERCertificate) {
        certificate.saveInBackground(block: { (success, error) in
            
            if success {
                
                switch self.certificateType {
                    
                case .firstResponder:
                    
                    if let user = ERUser.current() {
                        
                        // Add File To Certificate & Add Certificate To User
                        user.activated = false as NSNumber?
                        user.certificateFR = certificate
                        user.saveInBackground(block: { (success, error) in
                            self.saveCompletionHandler(certificate: certificate, error: error)
                        })
                    } else {
                        self.saveCompletionHandler(certificate: nil, error: NSError())
                    }
                    break
                    
                case .other:
                    
                    if let user = ERUser.current() {
                        
                        // Add File To Certificate & Add Certificate To User
                        user.add(certificate: certificate)
                        user.saveInBackground(block: { (success, error) in
                            self.saveCompletionHandler(certificate: certificate, error: error)
                        })
                        
                    } else {
                        self.saveCompletionHandler(certificate: nil, error: NSError())
                    }
                    
                    break
                }
            } else {
                self.saveCompletionHandler(certificate: nil, error: NSError())
            }
        })
    }
    
    private func saveCompletionHandler(certificate: ERCertificate?, error: Error?) {
        
        if error != nil {
            self.savingProgressController.dismiss(animated: true, completion: {
                self.present(UIAlertController.createCertificateSavingErrorController(), animated: true, completion: nil)
            })
            
        } else {
            
            // Pin Data
            self.savingProgressController.dismiss(animated: true, completion: {
                let savedController = UIAlertController.createCertificateSavingSuccessController(completion: {
                    for vc in (self.navigationController?.viewControllers ?? []) {
                        if vc is ERProfileV2ViewController {
                            _ = self.navigationController?.popToViewController(vc, animated: true)
                            break
                        }
                    }
                })
                self.present(savedController, animated: true, completion: nil)
            })
        }
    }


}
