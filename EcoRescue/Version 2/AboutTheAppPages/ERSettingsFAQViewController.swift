//
//  ERSettingsFAQViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 24.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class ERSettingsFAQViewController: ERSettingsWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = String.FAQ
        
        loadViewIndicatorHidden = true
        failViewTitle = String.FAQ
        failViewSubtitle = String.FAQ_COULD_NOT_BE_LOADED
        failViewButtonImage = UIImage.iconRepeat()
        
        loadViewIndicatorHidden = false
        loadViewTitle = String.FAQ
        loadViewSubtitle = String.FAQ_IS_LOADING
        loadViewButtonImage = nil
    }
    
    override func getURLType() -> ERURLType {
        return .faq
    }

}
