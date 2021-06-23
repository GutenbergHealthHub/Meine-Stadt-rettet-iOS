//
//  ERDefaultEmptyView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 13.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class ERDefaultEmptyView: EREmptyView {

    override init() {
        super.init()
        tintColor       = UIColor.separator
        
        titleFont       = UIFont.body
        subtitleFont    = UIFont.callout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
