//
//  ERProtocolCardiacMassageViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolCardiacMassageViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.CARDIAC_MASSAGE_TITLE
        headerSubtitleLabel.text = String.CARDIAC_MASSAGE_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createReportActivityHeartData()
    }
    
}
