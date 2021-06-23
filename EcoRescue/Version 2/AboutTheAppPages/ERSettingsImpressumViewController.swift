//
//  ERSettingsImpressumViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 19.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class ERSettingsImpressumViewController: ERSettingsWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = String.IMPRINT
        
        loadViewIndicatorHidden = true
        failViewTitle = String.IMPRINT
        failViewSubtitle = String.IMPRINT_COULD_NOT_BE_LOADED
        failViewButtonImage = UIImage.iconRepeat()
        
        loadViewIndicatorHidden = false
        loadViewTitle = String.IMPRINT
        loadViewSubtitle = String.IMPRINT_IS_LOADING
        loadViewButtonImage = nil
    }
    
    override func getURLType() -> ERURLType {
        return .impressum
    }

}
