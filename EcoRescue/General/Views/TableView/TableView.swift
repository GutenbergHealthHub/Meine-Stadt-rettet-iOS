//
//  TableView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 29.09.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class TableView: UITableView {

    init(style: UITableViewStyle) {
        super.init(frame: CGRect.zero, style: style)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.clear
        
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 44
        
        sectionHeaderHeight = UITableViewAutomaticDimension
        estimatedSectionHeaderHeight = 44
        
        sectionFooterHeight = UITableViewAutomaticDimension
        estimatedSectionFooterHeight = 44
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func layoutTableHeaderView() {
        DispatchQueue.main.async {
            if let tableHeaderView = self.tableHeaderView {
                tableHeaderView.layoutIfNeeded()
                self.tableHeaderView = tableHeaderView
            }
        }
    }
    
    func layoutTableFooterView() {
        DispatchQueue.main.async {
            if let tableFooterView = self.tableFooterView {
                tableFooterView.layoutIfNeeded()
                self.tableFooterView = tableFooterView
            }
        }
    }
    
    // MARK: - Getters & Setters
   
    override var tableHeaderView: UIView? {
        didSet {
            if let tableHeaderView = tableHeaderView, tableHeaderView != oldValue {
                tableHeaderView.top().width(multiplier: 1).centerX().apply()
                layoutTableHeaderView()
            }
        }
    }
    
     /*
    override var tableFooterView: UIView? {
        didSet {
            if let tableFooterView = tableFooterView, tableFooterView != oldValue {
                tableFooterView.bottom().width(multiplier: 1).centerX().apply()
                layoutTableFooterView()
            }
        }
    }
 */
    
}
