//
//  ERRegisterSuccessViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 24.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERRegisterSuccessViewController: ERLoginStepViewController {
    
    private let titleLabel = UILabel.type2SemiBoldLabel()
    
    private let descriptionTitleLabel = UILabel.type2SemiBoldLabel()
    private let descriptionLabel = UILabel.type2LightLabel()
    
    private let okButton = ERButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topView.addSubview(titleLabel)
        titleLabel.bottom(constant: UIViewPadding.medium).leftright(constant: UIViewPadding.large).centerX().apply()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "\(String.CONGRATULATIONS)\n\(String.YOU_ARE_A_FIRST_RESPONDER_NOW)"
        titleLabel.textColor = .white
        
        containerView.addSubview(descriptionTitleLabel)
        containerView.addSubview(descriptionLabel)
        bottomContainerView.addSubview(okButton)
        
        descriptionTitleLabel.top(constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).apply()
        descriptionLabel.bottom(of: descriptionTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        descriptionTitleLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionTitleLabel.text = String.REGISTER_SUCCESS_TITLE
        descriptionLabel.text      = String.REGISTER_SUCCESS_DESCRIPTION
        
        okButton.bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        
        okButton.text = String.OK
        okButton.addTarget(self, action: #selector(didTapOk(sender:)), for: .touchUpInside)
    }
    
    func didTapOk(sender: Any) {
        delegate?.finalizeSteps()
    }

}
