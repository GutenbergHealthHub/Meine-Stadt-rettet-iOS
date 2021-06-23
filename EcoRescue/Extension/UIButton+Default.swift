//
//  UIButton+Default.swift
//  EcoRescue
//
//  Created by Christoph Erl on 03.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

extension UIButton {
    
    fileprivate class func p_button() -> UIButton {
        let button = UIButton.button()
        button.tintColor = UIColor.theme
        return button
    }
    
    class func buttonImageWalk() -> UIButton {
        let button = p_button()
        button.setImage(UIImage.iconRunningMan(), for: UIControlState())
        return button
    }
    
    class func buttonRoadSign() -> UIButton {
        let button = p_button()
        button.setImage(UIImage.iconRoadSign(), for: UIControlState())
        return button
    }
    
    class func buttonLocationTarget() -> UIButton {
        let button = p_button()
        button.setImage(UIImage.iconLocationTarget(), for: UIControlState())
        return button
    }
    
    class func buttonRefresh() -> UIButton {
        let button = p_button()
        button.setImage(UIImage.iconRefreshToolbar(), for: UIControlState())
        return button
    }
    
    func centerVerticallyWith(padding: CGFloat) {
        guard let imageView = self.imageView, let titleLabel = self.titleLabel else {
            return
        }
        
        let imageSize = imageView.frame.size;
        let titleSize = titleLabel.frame.size;
        
        let totalHeight = (imageSize.height + titleSize.height + padding);
        
        self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height),
                                                0,
                                                0,
            -titleSize.width);
        
        self.titleEdgeInsets = UIEdgeInsetsMake(0,
                                                -imageSize.width,
                                                -(totalHeight - titleSize.height),
                                                0);
    }
    
    
}
