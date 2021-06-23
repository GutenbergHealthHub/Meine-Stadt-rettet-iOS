//
//  Icon.swift
//  UCKit
//
//  Created by Christoph Erl on 25.09.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

public enum IconType: String {
    case ok                             = "icon_ok"
    case cancel                         = "icon_cancel"
    case attention                      = "icon_attention"
    case sound_3                        = "icon_sound_3"
    case graduation_cap                 = "icon_graduation_cap"
    case locked                         = "icon_locked"
    case checkmark                      = "icon_checkmark"
    
    case icon_location_arrow            = "icon_location_arrow"
    case icon_location_arrow_selected   = "icon_location_arrow_filled"
}

public class Icon: NSObject {
    
    private let type: IconType
    
    public init(type: IconType) {
        self.type = type
    }
    
    public func toImage() -> UIImage {
        let image = Icon.image(named: type.rawValue)!
        return image.withRenderingMode(.alwaysTemplate)
    }
    
    private class func image(named: String) -> UIImage? {
        //let bundle = Bundle(for: UCKit.self) //
        return UIImage(named: named) //named, in: bundle, compatibleWith: nil)
    }
    
}
