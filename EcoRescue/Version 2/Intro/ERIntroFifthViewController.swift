//
//  ERIntroFifthViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 10.02.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERIntroFifthViewController: ERIntroStepViewController {
    
    private let label = UILabel.type2LightLabel(.title3)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = String.INTRO_FIFTH_PAGE_TITLE
        
        containerView.addSubview(label)
        label.topbottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.small).apply()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        
        var attrString = NSMutableAttributedString(string: String.INTRO_FIFTH_PAGE_DETAIL)
        attrString = fixText(inputText: attrString, attributeName: NSFontAttributeName as AnyObject, attributeValue: UIFont.openSansBold(textStyle: .title3), propsIndicator: "<b>", propsEndIndicator: "</b>")
        
        label.attributedText = attrString
    }

}
