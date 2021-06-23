//
//  ERButton.swift
//  EcoRescueASB
//
//  Created by Birtan on 03.01.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERButton: UIButton {

    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.colorPrimaryBlue
        layer.cornerRadius = 5
        setTitleColor(UIColor.white, for: .normal)

        titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        titleLabel?.minimumScaleFactor = 0.8
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.adjustsFontForContentSizeCategory = true
        
        height(constant: UIButtonHeight.forScreenSize).apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var text: String? {
        set { setTitle(newValue, for: .normal); invalidateIntrinsicContentSize()  }
        get { return titleLabel?.text                                             }
    }
    
}
