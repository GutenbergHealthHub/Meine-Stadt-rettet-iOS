//
//  ERMapFilterButton.swift
//  EcoRescue
//
//  Created by Birtan on 21.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERMapFilterButton: UIButton {
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.white
        
        layer.cornerRadius = 5
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.6
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: (bounds.width - 35))
            //titleEdgeInsets = UIEdgeInsets(top: 5, left: (imageView?.frame.width)!, bottom: 5, right: 0)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? UIColor.white : UIColor.gray
        }
    }
    

}
