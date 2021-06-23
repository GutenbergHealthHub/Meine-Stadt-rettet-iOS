//
//  ERPersonalPageViewController.swift
//  EcoRescue
//
//  Created by Birtan on 26.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERPersonalPageViewController: StepsPageViewController, ERFinalStepViewControllerDelegate {
    
    private let vc1     = ERPersonalFirstViewController()
    private let vc2     = ERPersonalSecondViewController()
    private let vc3     = ERPersonalThirdViewController()
    private let vcFinal = ERFinalStepViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pages = [vc1, vc2, vc3]
        finalPage = vcFinal
        
        for (index, vc) in pages.enumerated() {
            (vc as! StepsViewController).delegate = self
            (vc as! StepsViewController).setProgressViews(progress: Float(index+1)/Float(pages.count))
            (vc as! StepsViewController).progressLabel.text = "\(index+1)/\(pages.count)"
        }
        
        vcFinal.delegate = self
        
        vc1.backButton.isHidden = true
        vc3.nextButton.isHidden = true
        
        vcFinal.topTitleLabel.text    = String.PERSONAL_DATA
        vcFinal.topTitleLabel.textColor = .white
        vcFinal.titleLabel.text       = String.PROFILE_SUCCESS_TITLE
        vcFinal.descriptionLabel.text = String.PROFILE_SUCCESS_DESCRIPTION
        vcFinal.detailLabel.text      = String.PROFILE_SUCCESS_DETAIL
        vcFinal.mainButton.setTitle(String.GO_TO_PROFILE, for: .normal)
        vcFinal.titleImage.image = UIImage.iconIdentification()
        
        setTexts()
    }
    
    //MARK: ERFinalStepViewControllerDelegate
    func tapped(mainButton: Bool) {
        self.navigationController?.pop(animated: false)
    }
    
    override func finalizeSteps() {
        super.finalizeSteps()
        
        if let user = ERUser.current() {
            user.firstname       = vc1.getName()
            user.lastname        = vc1.getSurname()
            user.birthdate       = vc1.getDate()
            user.phoneCode       = vc1.getPhonecode()
            user.phoneNumber     = vc1.getPhonenumber()
            user.thoroughfare    = vc2.getStreet()
            user.subThoroughfare = vc2.getNumber()
            user.zip             = vc2.getPostcode()
            user.city            = vc2.getCity()
            user.country         = vc2.getCountry()
            user.profession      = vc3.getProfession()
            user.qualification   = vc3.getQualification()
            user.mobileAED       = vc3.getMobileAED()
            user.saveEventually()
        }
        
        if let final = finalPage {
            present(final, animated: true, completion: nil)
        }
    }
    
    private func setTexts() {
        if let user = ERUser.current() {
            vc1.setTextWith(name: user.firstname, surname: user.lastname, birthdate: user.birthdate, phoneCode: user.phoneCode, phoneNumber: user.phoneNumber)
            vc2.setTextWith(street: user.thoroughfare, number: user.subThoroughfare, postcode: user.zip, city: user.city, country: user.country)
            vc3.setTextWith(profession: user.profession, qualification: user.qualificationValue, qualificationKey: user.qualification, mobileAED: user.mobileAED)
        }
    }
    


}

