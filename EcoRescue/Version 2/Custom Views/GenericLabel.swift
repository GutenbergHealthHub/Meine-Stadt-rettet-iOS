//
//  GenericLabel.swift
//  EcoRescue
//
//  Created by Birtan on 22.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class GenericLabel: UILabel {

    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.preferredMaxLayoutWidth = self.frame.width
        super.layoutSubviews()
    }
    
}

