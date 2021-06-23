//
//  ERProfileV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 12.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import Parse

private let kHeaderViewHeight: CGFloat = 150

class ERProfileV2ViewController: CenterMenuViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let sideMenuHeaderView = SideMenuHeaderView()
    
    private let agreementCell    = ERProfileV2TableViewCell()
    private let personalDataCell = ERProfileV2TableViewCell()
    private let certificateCell  = ERProfileV2TableViewCell()
    private let accessCell       = ERProfileV2TableViewCell()
    private let notificationCell = ERProfileV2TableViewCell()
    private let locationCell     = ERProfileV2TableViewCell()
    
    private let tableView = FixedTableView(style: .grouped)
    
    private let responderStateManager = ResponderStateManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.PROFILE
        
        view.backgroundColor = UIColor.background
        
        //sideMenuHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: kHeaderViewHeight)
        
        self.view.addSubview(sideMenuHeaderView)
        self.view.addSubview(tableView)
        sideMenuHeaderView.top().leftright().width(multiplier: 1).height(multiplier: 0.25).apply()
        tableView.bottom(of: sideMenuHeaderView, constant: UIViewPadding.small).leftright().bottom().apply()
        
        sideMenuHeaderView.addUserIconTarget(target: self, action: #selector(didTapUserIcon(sender:)))
        sideMenuHeaderView.canAddPicture = true
        
        let section1 = FixedTableViewSection()
        section1.tableViewCells = [(agreementCell, didTapAgreement), (personalDataCell, didTapPersonal), (certificateCell, didTapCertificate), (accessCell, didTapAccess), (notificationCell, didTapNotification), (locationCell, didTapLocation),]
        section1.tableViewCellHeights = []
        
        tableView.sections = [section1]

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadData()
    }
    
    override func appWillEnterForeground() {
        reloadData()
    }
    
    private func reloadData() {
        
        agreementCell.title       = String.AGREEMENT
        agreementCell.subtitle    = responderStateManager.isUserContractBasicValid ? String.SIGNED : String.NOT_SIGNED
        agreementCell.icon        = UIImage.iconContract()
        agreementCell.setProgressType(type: .start)
        agreementCell.setProgressCompleted(completed: responderStateManager.isUserContractBasicValid ? .completed : .notCompleted)
        
        personalDataCell.title    = String.PERSONAL_DATA
        personalDataCell.subtitle = isProfileCompleted ? String.COMPLETED : String.NOT_COMPLETED
        personalDataCell.icon     = UIImage.iconIdentification()
        personalDataCell.setProgressType(type: .mid)
        personalDataCell.setProgressCompleted(completed: isProfileCompleted ? .completed : .notCompleted)
        
        certificateCell.title     = String.FIRST_RESPONDER_CERTIFICATION
        certificateCell.icon      = UIImage.iconCertificateV2()
        
        if let certificate = ERUser.current()?.certificateFR {
            certificateCell.subtitle  = certificate.stateString
            switch certificate.stateValue {
            case .create:
                certificateCell.setProgressCompleted(completed: .notCompleted)
            case .review:
                certificateCell.setProgressCompleted(completed: .inReview)
            case .verified:
                certificateCell.setProgressCompleted(completed: .completed)
            case .denied:
                certificateCell.setProgressCompleted(completed: .notCompleted)
            }
        } else {
            certificateCell.subtitle  = String.NOT_ADDED
        }
        certificateCell.setProgressType(type: .mid)
        
        accessCell.title          = String.ACCESS
        accessCell.subtitle       = responderStateManager.isPinCodeValid ? String.ADDED : String.NOT_ADDED
        accessCell.icon           = UIImage.iconPinV2()
        accessCell.setProgressType(type: .mid)
        accessCell.setProgressCompleted(completed: responderStateManager.isPinCodeValid ? .completed : .notCompleted)
        
        notificationCell.title    = String.NOTIFICATIONS
        notificationCell.subtitle = " "
        notificationCell.icon     = UIImage.iconNotificationV2()
        notificationCell.setProgressType(type: .mid)
        responderStateManager.isNotificationAuthorized(completion: {(isAuthorized) in
            self.notificationCell.subtitle = isAuthorized ? String.AUTHORIZED : String.NOT_AUTHORIZED
            self.notificationCell.setProgressCompleted(completed: isAuthorized ? .completed : .notCompleted)
        })
        
        locationCell.title    = String.LOCATION
        locationCell.subtitle = responderStateManager.isLocationAccessAuthorized ? String.AUTHORIZED : String.NOT_AUTHORIZED
        locationCell.icon     = UIImage.iconLocationV2()
        locationCell.setProgressType(type: .end)
        locationCell.setProgressCompleted(completed: responderStateManager.isLocationAccessAuthorized ? .completed : .notCompleted)
        
        sideMenuHeaderView.reloadData()
        
    }
    
    // MARK: - Private Methods - Profile Picture
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let user = ERUser.current(), let image = info[UIImagePickerControllerEditedImage] as? UIImage, let data = UIImageJPEGRepresentation(image, 0.5)  {
            
            // Pogress Alert
            let progressAlertController     = UCProgressAlertController(title: String.SAVE, message: nil, preferredStyle: .alert)
            progressAlertController.message = String.PLEASE_WAIT_FOR_SOME_SECONDS
            present(progressAlertController, animated: true, completion: nil)
            
            let profilePicture = PFFileObject(name: "profile_picture.jpg", data: data)
            profilePicture?.saveInBackground({ (success, error) in
                if success {
                    user.profilePicture = profilePicture
                    user.saveInBackground(block: { (success, error) in
                        if success {
                            self.sideMenuHeaderView.reloadData()
                        } else {
                            self.presentUnknownErrorAlertController()
                        }
                    })
                } else {
                    self.presentUnknownErrorAlertController()
                }
            }, progressBlock: { (progress) in
                progressAlertController.progress = Float(progress) / 100
            })
        }
        picker.dismiss(animated: false, completion: nil)
    }
    
    private func presentUnknownErrorAlertController() {
        let progressAlertController     = UIAlertController(title: String.SAVE_FAILED, message: nil, preferredStyle: .alert)
        progressAlertController.message = String.AN_ERROR_HAS_OCCURED
        progressAlertController.addAction(UIAlertAction(title: String.CANCEL, style: .cancel, handler: nil))
        present(progressAlertController, animated: true, completion: nil)
    }
    
    private func presentEditProfilePictureAlertController() {
        
        let cancelAction = UIAlertAction(title: String.CANCEL, style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: String.TAKE_A_PHOTO, style: .default) { (action) in
            self.openPhotoSource(type: .camera)
        }
        let libraryAction = UIAlertAction(title: String.OPEN_MEDIA_CENTER, style: .default) { (action) in
            self.openPhotoSource(type: .photoLibrary)
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func openPhotoSource(type: UIImagePickerControllerSourceType) {
        let imagePicker             = UIImagePickerController()
        imagePicker.delegate        = self
        imagePicker.sourceType      = type
        imagePicker.allowsEditing   = true
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Error
        }
    }
    
    private func openSettingsAlert() {
        let viewController      = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        viewController.title    = String.OPEN_CONFIGURATION
        viewController.message  = String.PERMISSION_CAN_BE_RESET_IN_SETTINGS
        
        viewController.addAction(UIAlertAction(title: String.OPEN_CONFIGURATION, style: .default, handler: { (action) in
            ERUtil.openSettings()
        }))
        
        viewController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    func didTapAgreement(sender: Any) {
        
        ERDataManager.findContractSubs { (contracts, error) in
            let vc = ERContractListV2ViewController()
            if let contracts = contracts, let user = ERUser.current()   {
                vc.subContracts = contracts
                ERDataManager.findUserContractSubs(user: user) { (userContractSubs, error) in
                    
                    if let error = error {
                        
                    }
                    
                    if let userContractSubs = userContractSubs {
                      vc.userSubContracts = userContractSubs
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }
        
    }
    
    func didTapCertificate(sender: Any) {
        if let _ = ERUser.current()?.certificateFR {
            let vc = ERCertificateOverviewV2ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = ERCertificateEditV2ViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func didTapPersonal(sender: Any) {
        let vc = isProfileCompleted ? ERPersonalOverviewViewController() : ERPersonalPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAccess(sender: Any) {
        let vc = responderStateManager.isPinCodeValid ? ERPinViewUpdateV2ViewController() : ERPinEditV2ViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapNotification(sender: Any) {
        responderStateManager.isNotificationAuthorized { (authorized) in
            if #available(iOS 12.0, *) {
                let vc = ERNotificationAccessViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                if !authorized {
                    let viewController = NotificationAuthorizationViewController(accessLevel: .firstResponder)
                    NotificationTransition.present(from: self, to: viewController.pack())
                    
                } else {
                    self.openSettingsAlert()
                }
            }
        }
    }
    
    func didTapLocation(sender: Any) {
        if !responderStateManager.isLocationAccessAuthorized {
            let viewController = LocationAuthorizationViewController(accessLevel: .firstResponder)
            NotificationTransition.present(from: self, to: viewController.pack())
        } else {
            openSettingsAlert()
        }
    }
    
    func didTapUserIcon(sender: Any) {
        presentEditProfilePictureAlertController()
    }
    
    private var isProfileCompleted: Bool {
        return responderStateManager.isAddressValid && responderStateManager.isBirthdateValid && responderStateManager.isPhoneNumberValid && responderStateManager.isProfessionValid
    }

}
