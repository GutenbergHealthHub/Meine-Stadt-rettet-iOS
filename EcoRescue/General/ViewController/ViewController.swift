//
//  ViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 15.10.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        
        backButton.target = self
    }
    
    // Back Button
    
    var backButtonTitle: String? {
        set { backButton.title = newValue   }
        get { return backButton.title       }
    }
    
    var isBackButtonHidden: Bool = true { didSet { p_setBackButtonHidden(oldValue: oldValue) } }
    
    private var backButton = UIBarButtonItem(title: String.BACK, style: .plain, target: nil, action: #selector(didTapBarButtonItemBack(sender:)))
    
    // MARK: - Private methods
    
    fileprivate func p_setBackButtonHidden(oldValue: Bool) {
        if oldValue == isBackButtonHidden { return }
        p_setBackButtonHidden()
    }
    
    fileprivate func p_setBackButtonHidden() {
        if isBackButtonHidden {
            navigationItem.leftBarButtonItem = nil
        } else {
            navigationItem.leftBarButtonItem = backButton
        }
    }
    
    func didTapBarButtonItemBack(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
