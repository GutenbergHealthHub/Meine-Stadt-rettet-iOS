//
//  ERPinViewUpdateV2ViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 13.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERPinViewUpdateV2ViewController: UIViewController, ERPinViewV2Delegate {
    
    private let descriptionView = ERDescriptionView()
    
    private let pinView      = ERPinViewV2(type: .access)
    private let infoLabel    = UILabel.calloutLabel
    private let changeButton = ERButton()
    
    private var code: String? { didSet { setCode(oldValue: oldValue) } }
    
    private var phase: UpdatePhase = .verify

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
        
        // pinView
        view.addSubview(pinView)
        pinView.bottom(of: descriptionView, constant: UIViewPadding.big + UIViewPadding.large).centerX().width(constant: 230).apply()
        pinView.delegate = self
        
        // infoLabel
        view.addSubview(infoLabel)
        infoLabel.bottom(of: pinView, constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).apply()
        infoLabel.textAlignment = .center
        infoLabel.text = String.YOUR_PIN_IS_CORRECTLY_SET
        infoLabel.numberOfLines = 0
        
        //Sign Button
        view.addSubview(changeButton)
        changeButton.centerX().bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        changeButton.text = String.CHANGE_PIN
        changeButton.addTarget(self, action: #selector(didTapChange(sender:)), for: .touchDown)
        
        code = ERUser.current()?.code
        
        pinView.setTextfield(code: code!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        pinView.unfocus()
    }
    
    private func setCode(oldValue: String?) {
        if oldValue == nil { return }
        switch phase {
        case .verify:
            if code == ERUser.current()?.code {
                phase = .enter
                pinView.reset(vibrating: false)
                infoLabel.text = String.PLEASE_INSERT_YOUR_NEW_PIN
            } else {
                pinView.reset(vibrating: true)
                infoLabel.text = String.WRONG_PIN
            }
            break
        case .enter:
            phase = .verifyNew
            pinView.reset(vibrating: false)
            infoLabel.text = String.PLEASE_REENTER_YOUR_NEW_PIN_TO_VERIFY
            break
        case .verifyNew:
            if oldValue == code {
                saveCode()
            } else {
                pinView.reset(vibrating: true)
                infoLabel.text = String.WRONG_PIN
            }
            break
        default:
            break
        }
    }
    
    private func saveCode() {
        ERUser.current()?.code = code
        ERUser.current()?.saveEventually()
        self.navigationController?.pop(animated: true)
    }
    
    // MARK: - Actions
    func didTapChange(sender: Any) {
        pinView.focus()
        pinView.reset(vibrating: false)
        infoLabel.text = String.INSERT_YOUR_CURRENT_PIN
    }
    
    //MARK: ERPinViewV2Delegate
    func didEnterCode(code: String) {
        self.code = code
    }
    
    private enum UpdatePhase {
        case verify, enter, reEnter, verifyNew
    }

}
