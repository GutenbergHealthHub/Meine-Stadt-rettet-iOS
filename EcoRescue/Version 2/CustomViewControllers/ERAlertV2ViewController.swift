//
//  ERAlertV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 06.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit


class ERAlertV2ViewController: UIViewController {
    
    let alertLabel = UILabel.type2LightLabel()
    
    var alertButtons = [UIButton]()
    
    let alertView = UIView.view()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        view.addSubview(alertView)
        alertView.centerY().leftright(constant: UIViewPadding.large).height(constant: view.frame.height).apply()
        alertView.backgroundColor = UIColor.colorPrimaryBlue
        
        alertView.addSubview(alertLabel)
        alertLabel.top(constant: UIViewPadding.large).leftright(constant: UIViewPadding.large).apply()
        alertLabel.numberOfLines = 0
        alertLabel.textAlignment = .center
        
        let buttonContainerView = UIView.view()
        alertView.addSubview(buttonContainerView)
        buttonContainerView.leftright(constant: UIViewPadding.large).bottom(of: alertLabel, constant: UIViewPadding.large).bottom(constant: UIViewPadding.medium).apply()
        
        for button in alertButtons {
            buttonContainerView.addSubview(button)
            button.height(constant: 50).apply()
        }
        UIView.alignVertically(views: alertButtons)
        
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizeAlertView()
    }
    
    
    private var contentHeight: CGFloat {
        let numberOfButtons = CGFloat(alertButtons.count)
        return alertLabel.frame.size.height + alertButtons[0].frame.size.height * numberOfButtons + UIViewPadding.large * 3 + UIViewPadding.small * 2
    }
    
    public func resizeAlertView() {
        view.layoutIfNeeded()
        for constraint in self.alertView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = contentHeight
                break
            }
        }
        view.layoutIfNeeded()
    }


}
