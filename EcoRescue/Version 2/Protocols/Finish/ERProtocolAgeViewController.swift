//
//  ERProtocolAgeViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolAgeViewController: ERProtocolExpandableTableViewController {
    
    var age: Int?
    var ageCategory: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.AGE_CATEGORY_TITLE
        headerSubtitleLabel.text = String.AGE_CATEGORY_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        
        reportData = ERReportData.createAgeCategoryData()
        
        pickerRow = 3
        pickerValues = Array(1...121)

    }
    
    override func selectedValues() -> (Int?, Int?) {
        var ageIndex: Int?
        var ageCategoryIndex: Int?
        
        if let age = self.age {
            ageIndex = age == 0 ? nil : age - 1
        }
        
        if let ageCategory = self.ageCategory {
            ageCategoryIndex = ageCategory - 1
        }
        
        return (ageCategoryIndex, ageIndex)
    }
    
    override func selected(index: Int) {
        if index == 3 {
            age = 1
            ageCategory = nil
        } else {
            ageCategory = index + 1
            age = 0
        }
    }
    
    override func pickerView(value: Int) {
        age = value
    }



}
