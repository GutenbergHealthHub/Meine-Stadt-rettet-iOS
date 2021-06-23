//
//  ERProtocolEndBreathingViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolEndBreathingViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.END_BREATHING_TITLE
        headerSubtitleLabel.text = String.END_BREATHING_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = true

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createReportEndBreatheData()
    }
    
    override func selected(item: ERReportDataItem) {
        guard let index = selectedItems.index(where: { (element) -> Bool in
            element.key == item.key
        }) else {
            selectedItems.append(item)
            return
        }
        selectedItems.remove(at: index)
    }


}
