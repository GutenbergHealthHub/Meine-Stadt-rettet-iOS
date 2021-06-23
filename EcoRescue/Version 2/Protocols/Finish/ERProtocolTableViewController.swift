//
//  ERProtocolTableViewController.swift
//  EcoRescue
//
//  Created by Birtan on 10.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolTableViewController: StepsViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let containerView = UIView.view()
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var selectedItem: ERReportDataItem?
    
    var selectedItems = [ERReportDataItem]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(containerView)
        containerView.bottom(of: progressView, constant: 0).leftright().top(of: progressView2, constant: 0).apply()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        tableView.top().leftright().bottom().apply()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        isNextButtonEnabled()
        
    }
    
    private func isNextButtonEnabled() {
        if selectedItem == nil && selectedItems.isEmpty {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        } else {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        }
    }
    
    func selected(item: ERReportDataItem) {
        selectedItem = item
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getReportData().data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        cell.textLabel?.text = getReportData().data[indexPath.row].text
        cell.textLabel?.font = UIFont.openSansRegular(textStyle: .body)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        cell.textLabel?.numberOfLines = 0
        cell.selectionStyle  = .none
        
        if tableView.allowsMultipleSelection {
            if !selectedItems.isEmpty {
                for selectedItem in selectedItems {
                    if selectedItem.key == getReportData().data[indexPath.row].key {
                        cell.textLabel?.textColor = UIColor.colorPrimaryRedV2
                        cell.textLabel?.font = UIFont.openSansBold(textStyle: .body)
                        cell.textLabel?.adjustsFontForContentSizeCategory = true
                        tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    }
                }
            }
        } else {
            if let selectedItem = selectedItem, selectedItem.key == getReportData().data[indexPath.row].key {
                cell.textLabel?.textColor = UIColor.colorPrimaryRedV2
                cell.textLabel?.font = UIFont.openSansBold(textStyle: .body)
                cell.textLabel?.adjustsFontForContentSizeCategory = true
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.colorPrimaryRedV2
        tableView.cellForRow(at: indexPath)?.textLabel?.font = UIFont.openSansBold(textStyle: .body)
        selected(item: getReportData().data[indexPath.row])
        isNextButtonEnabled()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.black
        tableView.cellForRow(at: indexPath)?.textLabel?.font = UIFont.openSansRegular(textStyle: .body)
        selected(item: getReportData().data[indexPath.row])
    }
    
    // MARK: Helper Functions
    
    func getReportData() -> ERReportData! {
        return nil
    }

    
    func setSelectedTextWithKey(_ key: NSNumber?) {
        if let key = key {
            selectedItem = getReportData().itemWithKey(key)
        } else {
            selectedItem = nil
        }
    }
    
    func setSelectedTextWithKeys(_ keys: NSArray?) {
        if let keys = keys {
            selectedItems = getReportData().itemWithKeyArray(keys)
        } else {
            selectedItems = []
        }
    }



}
