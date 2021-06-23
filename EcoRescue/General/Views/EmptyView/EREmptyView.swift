//
//  UCEmptyView.swift
//  CEUserControls
//
//  Created by Christoph Erl on 16.03.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class EREmptyView: UCEmptyView {
    
    override init() {
        super.init()
        buttonTintColor = UIColor.theme
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
