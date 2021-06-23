//
//  ERCertificateEditV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 25.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERCertificateEditV2ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ERImageCaptureViewControllerDelegate {
  
    private let descriptionView = ERDescriptionView()
    
    private let takePhotoButton   = UIButton.button()
    private let openGalleryButton = UIButton.button()
    
    private let pickerController  = UIImagePickerController()
    
    var certificate: ERCertificate?
    var certificateType = ERCertificateType.firstResponder

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = String.CERTIFICATE
        view.backgroundColor = UIColor.white
        
        // Description view
        view.addSubview(descriptionView)
        descriptionView.top().leftright().height(multiplier: 0.2).apply()
        descriptionView.image = UIImage.iconCertificateV2().withRenderingMode(.alwaysTemplate)
        descriptionView.text  = String.CERTIFICATE_INFO
        
        // infolabel
        let infolabel = UILabel.type2Label()
        view.addSubview(infolabel)
        infolabel.bottom(of: descriptionView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        infolabel.textAlignment = .left
        infolabel.numberOfLines = 0
        infolabel.text = String.CERTIFICATE_SELECT_INFO
        
        // Buttons
        view.addSubview(takePhotoButton)
        view.addSubview(openGalleryButton)
        takePhotoButton.bottom(of: infolabel, constant: UIViewPadding.big).left(constant: view.frame.midX - view.frame.width * 0.4 - UIViewPadding.medium).width(multiplier: 0.4).widthEqualsHeight().apply()
        openGalleryButton.bottom(of: infolabel, constant: UIViewPadding.big).right(constant: view.frame.midX - view.frame.width * 0.4 - UIViewPadding.medium).width(multiplier: 0.4).widthEqualsHeight().apply()
        
        takePhotoButton.backgroundColor   = UIColor.colorPrimaryBlue
        openGalleryButton.backgroundColor = UIColor.colorPrimaryBlue
        
        takePhotoButton.setImage(UIImage.iconCameraV2(), for: UIControlState.normal)
        openGalleryButton.setImage(UIImage.iconUploadV2(), for: UIControlState.normal)
        
        takePhotoButton.tintColor   = UIColor.white
        openGalleryButton.tintColor = UIColor.white
        
        takePhotoButton.setTitle(String.CERTIFICATE_TAKE_PICTURE, for: .normal)
        openGalleryButton.setTitle(String.CERTIFICATE_UPLOAD_PICTURE, for: .normal)
        
        takePhotoButton.setTitleColor(UIColor.white, for: .normal)
        openGalleryButton.setTitleColor(UIColor.white, for: .normal)
        
        takePhotoButton.titleLabel?.font   = UIFont.openSansRegular(textStyle: .body)
        openGalleryButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        
        takePhotoButton.titleLabel?.lineBreakMode   = .byWordWrapping
        openGalleryButton.titleLabel?.lineBreakMode = .byWordWrapping
        
        takePhotoButton.titleLabel?.textAlignment   = .center
        openGalleryButton.titleLabel?.textAlignment = .center
        
        takePhotoButton.layer.cornerRadius   = 5
        openGalleryButton.layer.cornerRadius = 5
        
        takePhotoButton.centerVerticallyWith(padding: 10)
        openGalleryButton.centerVerticallyWith(padding: 10)
        
        takePhotoButton.addTarget(self, action: #selector(didTapTakePhoto(sender:)), for: .touchDown)
        openGalleryButton.addTarget(self, action: #selector(didTapOpenGallery(sender:)), for: .touchDown)
        
        // pickerController
        pickerController.delegate = self
    }
    
    func didTapTakePhoto(sender: Any) {
        let vc = ERImageCaptureViewController()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapOpenGallery(sender: Any) {
        pickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        pickerController.navigationBar.isTranslucent = false
        pickerController.navigationBar.barTintColor = UIColor.colorPrimaryBlue
        pickerController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.quicksandBold(textStyle: .headline)]
        
        present(pickerController, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerController
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // Set Image
            save(image: image)
            
        } else {
            print("ERROR")
        }
    }
    
    //MARK: ERImageCaptureViewControllerDelegate
    func save(image: UIImage) {
        let vc = ERCertificateEditFinalV2ViewController()
        vc.image = image
        vc.certificate = certificate
        vc.certificateType = certificateType
        navigationController?.pushViewController(vc, animated: true)
    }

}
