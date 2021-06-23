//
//  Font.swift
//  EcoRescue
//
//  Created by Christoph Erl on 29.09.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

extension UIFont {

    class func createFont(textStyle: UIFontTextStyle, weight: UIFontWeight = UIFontWeightRegular) -> UIFont {        
        let font = UIFont.preferredFont(forTextStyle: textStyle)
        return UIFont.systemFont(ofSize: font.pointSize, weight: weight)
    }
    
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
    
}
