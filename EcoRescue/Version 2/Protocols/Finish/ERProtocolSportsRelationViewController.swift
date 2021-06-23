//
//  ERProtocolSportsRelationViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolSportsRelationViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.SPORTS_RELATION_TITLE
        headerSubtitleLabel.text = String.SPORTS_RELATION_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createYesNoData()
    }
    
    func getResult() -> Bool? {
        if let key = selectedItem?.key {
            return key == 1 ? true : false
        }
        return nil
    }


}
