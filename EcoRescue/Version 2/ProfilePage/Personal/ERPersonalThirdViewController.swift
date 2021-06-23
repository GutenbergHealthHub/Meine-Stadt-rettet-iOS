//
//  ERPersonalThirdViewController.swift
//  EcoRescue
//
//  Created by Birtan on 14.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

private enum ThirdPageEnum {
    case profession, qualification, mobileAED
}

class ERPersonalThirdViewController: StepsViewController, UIPopoverPresentationControllerDelegate, ERPopOverTableViewControllerDelegate, UITextFieldDelegate {
    
    private let containerView = UIView.view()
    
    private let qualificationLabel = UILabel.type2SemiBoldLabel()
    private let professionLabel    = UILabel.type2SemiBoldLabel()
    private let mobileAEDLabel     = UILabel.type2SemiBoldLabel()
    
    private let qualificationDetailLabel = UILabel.type2LightLabel(.footnote)
    private let professionDetailLabel    = UILabel.type2LightLabel(.footnote)
    
    private let qualificationView = ERRectangleView()
    private let professionView    = ERRectangleView()
    private let mobileAEDView     = ERRectangleView()
    
    private var onRectangleView: ThirdPageEnum = .profession
    
    private var qualificationKey: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        headerTitleLabel.text    = String.QUALIFICATION
        headerSubtitleLabel.text = String.PROFILE_INFO_THIRD_PAGE
        
        // Container View
        view.addSubview(containerView)
        containerView.bottom(of: progressView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).top(of: progressView2, constant: UIViewPadding.big).apply()
        
        // Container View - qualificationLabel
        containerView.addSubview(qualificationLabel)
        qualificationLabel.top().left().apply()
        qualificationLabel.text = String.MY_QUALIFICATION_FOR_REANIMATION
        
        // Container View - qualificationDetailLabel
        containerView.addSubview(qualificationDetailLabel)
        qualificationDetailLabel.bottom(of: qualificationLabel, constant: 0).left().apply()
        qualificationDetailLabel.text = String.SELECT_ONE_OF_THE_OPTIONS_FROM_THE_LIST
        
        // Container View - qualificationView
        containerView.addSubview(qualificationView)
        qualificationView.bottom(of: qualificationDetailLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        qualificationView.addTarget(target: self, action: #selector(didTapQualificationView))
        
        // Container View - professionLabel
        containerView.addSubview(professionLabel)
        professionLabel.bottom(of: qualificationView, constant: UIViewPadding.big).left().apply()
        professionLabel.text = String.MY_JOB
        
        // Container View - professionDetailLabel
        containerView.addSubview(professionDetailLabel)
        professionDetailLabel.bottom(of: professionLabel, constant: 0).left().apply()
        professionDetailLabel.text = String.SELECT_ONE_OF_THE_OPTIONS_FROM_THE_LIST
        
        // Container View - professionView
        containerView.addSubview(professionView)
        professionView.bottom(of: professionDetailLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        professionView.addTarget(target: self, action: #selector(didTapProfessionView))
        
        // Container View - mobileAEDLabel
        containerView.addSubview(mobileAEDLabel)
        mobileAEDLabel.bottom(of: professionView, constant: UIViewPadding.big).left().apply()
        mobileAEDLabel.text = String.MOBILE_AED
        
        // Container View - mobileAEDView
        containerView.addSubview(mobileAEDView)
        mobileAEDView.bottom(of: mobileAEDLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        mobileAEDView.addTarget(target: self, action: #selector(didTapMobileAEDView))
        
        // Container View - button
        let button = ERButton()
        containerView.addSubview(button)
        button.bottom(constant: UIViewPadding.medium).leftright().apply()
        button.text = String.SEND_INFORMATION
        button.addTarget(self, action: #selector(didTapSend(sender:)), for: .touchDown)
        
    }
    
    func didTapQualificationView(sender: Any) {
        onRectangleView = .qualification
        addPopOverView(sender: sender as! UIView, data: ERUser.qualificationTuple.map( { $1 } ))
    }
    
    func didTapProfessionView(sender: Any) {
        onRectangleView = .profession
        addPopOverView(sender: sender as! UIView, data: ERUser.professionStrings)
    }
    
    func didTapMobileAEDView(sender: Any) {
        onRectangleView = .mobileAED
        addPopOverView(sender: sender as! UIView, data: [String.YES, String.NO], height: 100)
    }
    
    func didTapSend(sender: Any) {
        delegate?.finalizeSteps()
    }
    
    private func addPopOverView(sender: UIView, data: [String]?, height: CGFloat = 300) {
        let vc = ERPopOverTableViewController()
        vc.delegate = self
        vc.popOverData = data
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize   = CGSize(width: (sender).frame.width, height: height)
        
        if let pres = vc.presentationController {
            pres.delegate = self
        }
        
        self.present(vc, animated: true)
        if let ppc = vc.popoverPresentationController {
            ppc.sourceView = (sender)
            ppc.sourceRect = (sender).bounds
            ppc.permittedArrowDirections = .up
        }
    }
    
    //MARK: UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK: ERPopOverTableViewControllerDelegate
    func selectedText(text: String, index: Int) {
        switch onRectangleView {
        case .qualification:
            qualificationView.label.text = text
            qualificationKey = ERUser.qualificationTuple[index].0
            break
        case .profession:
            professionView.label.text = text
            break
        case .mobileAED:
            mobileAEDView.label.text = text
            break
        }
        
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    //MARK: Getters
    func getProfession() -> String? {
        return professionView.label.text
    }
    
    func getQualification() -> String? {
        return qualificationKey
    }
    
    func getMobileAED() -> NSNumber? {
        if mobileAEDView.label.text == String.YES {
            return true
        } else {
            return false
        }
    }
    
    //MARK: Setters
    func setTextWith(profession: String?, qualification: String?, qualificationKey: String?, mobileAED: NSNumber?) {
        professionView.label.text    = profession
        qualificationView.label.text = qualification
        self.qualificationKey        = qualificationKey
        
        if let mobileAED = mobileAED {
            mobileAEDView.label.text = mobileAED as! Bool ? String.YES : String.NO
        } else {
            mobileAEDView.label.text = String.NO
        }
        
    }
    
}
