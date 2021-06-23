//
//  TableSectionFooterView.swift
//  EcoRescueASB
//
//  Created by Birtan on 03.04.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class TableSectionFooterView: View {
    
    private let label   = UILabel.type1BoldLabel(.footnote)
    
    init(style: UITableViewStyle, title: String? = nil) {
        super.init()
        translatesAutoresizingMaskIntoConstraints = true
        
        // Add Views
        addSubview(label)
        label.leftright(constant: UIViewPadding.big).apply()
        
        //Setup Views
        label.numberOfLines = 0
        
        switch style {
        case .plain:
            label.textColor = UIColor.colorPrimaryRedV2
            //label.font      = UIFont.createFont(textStyle: .footnote, weight: UIFontWeightBold)
            label.topbottom(constant: UIViewPadding.medium).apply()
            break
            
        case .grouped:
            label.textColor = UIColor.darkGray
            label.font      = UIFont.createFont(textStyle: .footnote, weight: UIFontWeightThin)
            label.top(constant: UIViewPadding.small).bottom(constant: UIViewPadding.small).apply()
            break
            
        }
        
        // Title
        self.title = title
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let padding = UIViewPadding.big + UIViewRowHeight.small
        let height  = label.intrinsicContentSize.height
        return CGSize(width: 0, height: height + padding)
    }
    
    var title: String? {
        set { label.text = newValue; invalidateIntrinsicContentSize()     }
        get { return label.text                                                         }
    }
    
}
