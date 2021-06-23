//
//  ERLoginPageViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 23.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERLoginPageViewController: StepsPageViewController {
    
    private let firstPage   = ERLoginV2ViewController()
    private let secondPage  = ERRegisterV2ViewController()
    private let thirdPage   = ERRegisterVerifyViewController()
    private let fourthPage  = ERRegisterSuccessViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        pages = [firstPage, secondPage, thirdPage, fourthPage]
        firstPage.delegate  = self
        secondPage.delegate = self
        thirdPage.delegate  = self
        fourthPage.delegate = self

    }
    
    override func finalizeSteps() {
        super.finalizeSteps()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func goNextStep() {
        thirdPage.registeredEmail    = secondPage.email
        thirdPage.registeredPassword = secondPage.password
        super.goNextStep()
    }

}
