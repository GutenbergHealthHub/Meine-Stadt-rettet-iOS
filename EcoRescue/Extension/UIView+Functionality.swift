//
//  UIView+Functionality.swift
//  EcoRescue
//
//  Created by Christoph Erl on 21.03.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

extension UITableView {
    
    func invalidateTableHeaderViewFrame() {
        if let tempTableHeaderView = tableHeaderView {
            tempTableHeaderView.setNeedsLayout()
            tempTableHeaderView.layoutIfNeeded()
            
            tempTableHeaderView.frame = CGRect(x: 0, y: 0, width: frame.width, height: tempTableHeaderView.intrinsicContentSize.height)
            tableHeaderView = tempTableHeaderView
        }
    }
    
    func invalidateTableFooterViewFrame() {
        if let tempTableFooterView = tableFooterView {
            tempTableFooterView.frame = CGRect(x: 0, y: 0, width: frame.width, height: tempTableFooterView.intrinsicContentSize.height)
            tableFooterView = tempTableFooterView
        }
    }

}
