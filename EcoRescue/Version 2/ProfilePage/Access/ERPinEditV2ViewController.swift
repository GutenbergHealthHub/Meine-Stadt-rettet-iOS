//
//  ERPinEditViewController.swift
//  EcoRescue
//
//  Created by Birtan on 19.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERPinEditV2ViewController: UIViewController, ERPinViewV2Delegate {
    
    private let descriptionView = ERDescriptionView()
    private let containerView   = UIView.view()
    private let pinView         = ERPinViewV2(type: .access)
    private let infoLabel       = UILabel.type2LightLabel()
    
    private var isFirstEntry: Bool = true
    
    private var code: String? { didSet { setCode(oldValue: oldValue) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = String.ACCESS_WITH_PIN
        view.backgroundColor = UIColor.white
        
        // Description view
        view.addSubview(descriptionView)
        descriptionView.top().leftright().height(multiplier: 0.2).apply()
        descriptionView.image = UIImage.iconPinV2().withRenderingMode(.alwaysTemplate)
        descriptionView.text  = String.ACCESS_INFO
        
        // Container view
        view.addSubview(containerView)
        containerView.bottom(of: descriptionView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.large).bottom().apply()
        
        // Container view - pinView
        containerView.addSubview(pinView)
        pinView.top(constant: UIViewPadding.large).centerX().width(constant: 230).apply()
        pinView.delegate = self
        
        // Container view - infoLabel
        containerView.addSubview(infoLabel)
        infoLabel.bottom(of: pinView, constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).apply()
        infoLabel.textAlignment = .center
        infoLabel.text = String.ENTER_NEW_PIN_TO_ACCESS
        infoLabel.numberOfLines = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pinView.focus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pinView.unfocus()
    }
    
    private func setCode(oldValue: String?) {
        if isFirstEntry {
            infoLabel.text = String.PLEASE_REENTER_TO_VERIFY
            pinView.reset(vibrating: false)
            isFirstEntry = false
        } else {
            if oldValue != code {
                infoLabel.text = String.ENTER_NEW_PIN_TO_ACCESS
                pinView.reset(vibrating: true)
                isFirstEntry = true
            } else {
                saveCode()
            }
        }
        
    }
    
    private func saveCode() {
        ERUser.current()?.code = code
        ERUser.current()?.saveEventually()
        self.navigationController?.pop(animated: true)
    }

    //MARK: ERPinViewV2Delegate
    func didEnterCode(code: String) {
        self.code = code
    }

}
