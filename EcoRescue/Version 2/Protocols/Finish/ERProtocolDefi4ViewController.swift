//
//  ERProtocolDefi4ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolDefi4ViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.DEFI4_TITLE
        headerSubtitleLabel.text = String.DEFI4_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createPublicAEDData()
    }
    
    func getResult() -> Bool? {
        if let key = selectedItem?.key {
            return key == 1 ? true : false
        }
        return nil
    }


}
