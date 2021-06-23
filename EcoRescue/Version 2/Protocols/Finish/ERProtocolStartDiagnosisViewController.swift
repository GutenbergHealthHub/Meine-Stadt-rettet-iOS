//
//  ERProtocolStartDiagnosisViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolStartDiagnosisViewController: ERProtocolTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.START_DIAGNOSIS_TITLE
        headerSubtitleLabel.text = String.START_DIAGNOSIS_SUBTITLE

        tableView.allowsMultipleSelection = true

    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createReportStartDiagnosisData()
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
