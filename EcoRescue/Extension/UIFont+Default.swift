//
//  UIFont+Default.swift
//  EcoRescue
//
//  Created by Birtan on 22.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

extension UIFont {
    
    public class func quicksandRegular(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "Quicksand-Regular", with: textStyle)
    }
    
    public class func quicksandLight(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "Quicksand-Light", with: textStyle)
    }
    
    public class func quicksandBold(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "Quicksand-Bold", with: textStyle)
    }
    
    public class func quicksandMedium(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "Quicksand-Medium", with: textStyle)
    }
    
    public class func openSansRegular(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "OpenSans-Regular", with: textStyle)
    }
    
    public class func openSansLight(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "OpenSans-Light", with: textStyle)
    }
    
    public class func openSansBold(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "OpenSans-Bold", with: textStyle)
    }
    
    public class func openSansSemiBold(textStyle: UIFontTextStyle) -> UIFont {
        return scaledFont(forFont: "OpenSans-SemiBold", with: textStyle)
    }
    
    private class func scaledFont(forFont name: String, with textStyle: UIFontTextStyle) -> UIFont {
        if #available(iOS 11.0, *) {
            let pointSize = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle).pointSize
            return UIFontMetrics.default.scaledFont(for: UIFont(name: name, size: pointSize)!)
        } else {
            return UIFont(name: name, size: UIFont.preferredFont(forTextStyle: textStyle).pointSize)!
        }
    }
    
}
