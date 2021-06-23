//
//  FixedTableView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 29.09.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class FixedTableViewSection: NSObject {
    
    var headerView:             UIView?
    var tableViewCells          = [(UITableViewCell, (()->())?)]()
    var tableViewCellHeights    = [CGFloat?]()
    var footerView:             UIView?
    
}

let kFixedGroupedTableHeaderViewSpacing: CGFloat = UIViewPadding.big
let kFixedGroupedTableFooterViewSpacing: CGFloat = UIViewPadding.big

class FixedTableView: TableView, UITableViewDataSource, UITableViewDelegate {
    
    public var sections = [FixedTableViewSection]() { didSet { p_setTableViewCells(oldValue: oldValue) } }
    
    // Views
    
    public override init(style: UITableViewStyle) {
        super.init(style: style)
        
        // Do any additional setup after loading the view.
        dataSource    = self
        delegate      = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UCTableViewDataSource
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return sections[indexPath.section].tableViewCells[indexPath.row].0
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].tableViewCells.count
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    // MARK: - UCTableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = sections[indexPath.section].tableViewCellHeights.get(at: indexPath.row) {
            return height ?? UITableViewAutomaticDimension
        }
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return sections[section].headerView
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView.style {
        case .plain:
            return sections[section].headerView != nil ? UITableViewAutomaticDimension : 0.0
        case .grouped:
            return sections[section].headerView != nil ? UITableViewAutomaticDimension : kFixedGroupedTableHeaderViewSpacing
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footerView
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch tableView.style {
        case .plain:
            return sections[section].footerView != nil ? UITableViewAutomaticDimension : 0.0
        case .grouped:
            return sections[section].footerView != nil ? UITableViewAutomaticDimension : kFixedGroupedTableFooterViewSpacing
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sections[indexPath.section].tableViewCells[indexPath.row].1?()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private Methods
    
    private func p_setTableViewCells(oldValue: [FixedTableViewSection]) {
        p_setTableViewCells()
    }
    
    private func p_setTableViewCells() {
        self.reloadData()
        self.invalidateIntrinsicContentSize()
    }

}
