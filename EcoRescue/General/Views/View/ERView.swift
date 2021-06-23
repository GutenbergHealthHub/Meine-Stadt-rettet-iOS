//
//  ECView.swift
//  Ecorium
//
//  Created by Christoph Erl on 02.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class ERView: UCView {

    override init() {
        super.init()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }

}

