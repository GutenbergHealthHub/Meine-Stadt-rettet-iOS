//
//  ERProtocolDefiViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolDefiViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.DEFI_TITLE
        headerSubtitleLabel.text = String.DEFI_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createReportActivityDefiData()
    }
    
    var wasDefiUsed: Bool {
        if let key = selectedItem?.key as Int? {
            return (key == 1 || key == 2)
        }
        return false
    }

}
