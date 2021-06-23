//
//  ERProtocolArrivalTimeViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolArrivalTimeViewController: ERProtocolExpandableTableViewController {
    
    var later: Bool?
    var time: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.ARRIVAL_TIME_TITLE
        headerSubtitleLabel.text = String.ARRIVAL_TIME_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        
        reportData = ERReportData.createReportTimeData()
        
        pickerRow = 1
        pickerValues = Array(1...40)
        pickerViewText = String.DURATION_UNIT_MIN
    }
    
    override func selectedValues() -> (Int?, Int?) {
        var index: Int?
        var pickerIndex: Int?
        
        if let later = self.later {
            index = later ? 0 : 1
        }
        
        if let time = self.time, time != -1 {
            pickerIndex = time - 1
        }
        
        return (index, pickerIndex)
    }
    
    override func selected(index: Int) {
        if index == 0 {
            later = true
            time  = -1
        } else {
            later = false
            time  = pickerValues[0]
        }
    }
    
    override func pickerView(value: Int) {
        time = value
    }

}
