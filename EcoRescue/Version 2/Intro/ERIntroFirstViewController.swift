//
//  ERIntroFirstViewController.swift
//  EcoRescue
//
//  Created by Birtan on 05.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERIntroFirstViewController: ERIntroStepViewController {
    
    private let label = UILabel.type2LightLabel(.title3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = String.INTRO_FIRST_PAGE_TITLE
        
        containerView.addSubview(label)
        label.topbottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.small).apply()
        label.textAlignment = .center
        label.numberOfLines = 0
        //label.minimumScaleFactor = 0.5
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        
        var attrString = NSMutableAttributedString(string: String.INTRO_FIRST_PAGE_DETAIL)
        attrString = fixText(inputText: attrString, attributeName: NSFontAttributeName as AnyObject, attributeValue: UIFont.openSansBold(textStyle: .title3), propsIndicator: "<b>", propsEndIndicator: "</b>")
        
        label.attributedText = attrString
        
    }
    
    
}
