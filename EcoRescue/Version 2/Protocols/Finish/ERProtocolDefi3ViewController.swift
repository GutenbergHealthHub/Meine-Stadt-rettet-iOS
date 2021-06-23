//
//  ERProtocolDefi3ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolDefi3ViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.AED_MANUFACTURER
        headerSubtitleLabel.text = String.DEFI3_SUBTITLE
        
        tableView.isScrollEnabled = true
        tableView.allowsMultipleSelection = false

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createReportAEDManufacturerData()
    }


}
