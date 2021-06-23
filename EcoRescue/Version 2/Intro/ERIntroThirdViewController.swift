//
//  ERIntroThirdViewController.swift
//  EcoRescue
//
//  Created by Birtan on 05.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERIntroThirdViewController: ERIntroStepViewController {
    
    private let imageView = UIImageView.imageView()
    
    private let label = UILabel.type2LightLabel(.title3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        titleLabel.text = String.INTRO_THIRD_PAGE_TITLE
        
        containerView.addSubview(imageView)
        imageView.topbottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.small).height(multiplier: 0.6).apply()
        imageView.image = UIImage(named: "scheme_intro_v2")
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        containerView.addSubview(label)
        label.bottom(of: imageView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.small).apply()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        
        var attrString = NSMutableAttributedString(string: String.INTRO_THIRD_PAGE_DETAIL)
        attrString = fixText(inputText: attrString, attributeName: NSFontAttributeName as AnyObject, attributeValue: UIFont.openSansBold(textStyle: .title3), propsIndicator: "<b>", propsEndIndicator: "</b>")
        
        label.attributedText = attrString
    }
    
}
