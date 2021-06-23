//
//  UILabel+Default.swift
//  EcoRescue
//
//  Created by Birtan on 22.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

public extension UILabel {
    
    class func type1Label(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.quicksandRegular(textStyle: style))
        return label
    }
    
    class func type1BoldLabel(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.quicksandBold(textStyle: style))
        return label
    }
    
    class func type1LightLabel(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.quicksandLight(textStyle: style))
        return label
    }
    
    class func type1MediumLabel(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.quicksandMedium(textStyle: style))
        return label
    }
    
    class func type2Label(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.openSansRegular(textStyle: style))
        return label
    }
    
    class func type2BoldLabel(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.openSansBold(textStyle: style))
        return label
    }
    
    class func type2SemiBoldLabel(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.openSansSemiBold(textStyle: style))
        return label
    }
    
    class func type2LightLabel(_ style: UIFontTextStyle = .body) -> UILabel {
        let label = UILabel.label(font: UIFont.openSansLight(textStyle: style))
        return label
    }
    
    // MARK: - Private
    
    private static func label(font: UIFont) -> UILabel {
        let label = GenericLabel()
        label.font = font
        label.minimumScaleFactor = 0.8
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }
    
}

