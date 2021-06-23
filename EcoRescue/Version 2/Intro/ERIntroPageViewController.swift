//
//  ERIntroPageViewController.swift
//  EcoRescue
//
//  Created by Birtan on 05.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERIntroPageViewController: StepsPageViewController {
    
    private let firstPage  = ERIntroFirstViewController()
    private let secondPage = ERIntroSecondViewController()
    private let thirdPage  = ERIntroThirdViewController()
    private let fourthPage = ERIntroFourthViewController()
    private let fifthPage  = ERIntroFifthViewController()
    private let sixthPage  = ERIntroSixthViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if let _ = ERUser.current() {
            pages = [firstPage, secondPage, thirdPage, fourthPage, fifthPage]
        } else {
            pages = [firstPage, secondPage, thirdPage, fourthPage, fifthPage, sixthPage]
        }
        
        for (index, vc) in pages.enumerated() {
            (vc as! ERIntroStepViewController).delegate = self
            (vc as! ERIntroStepViewController).progressView.progress = Float(index+1)/Float(pages.count)
        }
        
    }
    
    override func finalizeSteps() {
        super.finalizeSteps()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}
