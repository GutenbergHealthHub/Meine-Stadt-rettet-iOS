//
//  ERProtocolLocationViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolLocationViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.LOCATION_TITLE
        headerSubtitleLabel.text = String.LOCATION_SUBTITLE
        
        tableView.allowsMultipleSelection = false

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createReportStartLocationData()
    }


}
