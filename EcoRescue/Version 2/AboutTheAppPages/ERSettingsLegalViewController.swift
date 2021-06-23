//
//  ERSettingsLegalViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 24.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class ERSettingsLegalViewController: ERSettingsWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = String.LEGAL_NOTICE
        
        loadViewIndicatorHidden = true
        failViewTitle = String.LEGAL_NOTICE
        failViewSubtitle = String.LEGAL_NOTICES_COULD_NOT_BE_LOADED
        failViewButtonImage = UIImage.iconRepeat()
        
        loadViewIndicatorHidden = false
        loadViewTitle = String.LEGAL_NOTICE
        loadViewSubtitle = String.LEGAL_NOTICES_ARE_LOADING
        loadViewButtonImage = nil
    }

    override func getURLType() -> ERURLType {
        return .legal
    }

}
