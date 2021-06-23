//
//  ERProtocolSexViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolSexViewController: ERProtocolTableViewController {
    
    var sex: String? { set { p_setSex(newValue) } get { return getSex() } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.SEX_CATEGORY_TITLE
        headerSubtitleLabel.text = String.SEX_CATEGORY_SUBTITLE
        
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        
    }
    
    override func getReportData() -> ERReportData! {
        return ERReportData.createReportSexData()
    }
    
    func p_setSex(_ newValue: String?) {
        if let text = newValue{
            text == "m" ? setSelectedTextWithKey(0 as NSNumber): setSelectedTextWithKey(1 as NSNumber)
        }
    }
    
    func getSex() -> String? {
        if let key = selectedItem?.key as Int?{
            return key == 0 ? "m" : "w"
        }
        return nil
    }


}
