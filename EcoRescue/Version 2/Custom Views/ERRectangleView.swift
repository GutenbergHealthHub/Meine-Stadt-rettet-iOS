//
//  ERRectangleView.swift
//  EcoRescue
//
//  Created by Birtan on 15.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERRectangleView: Control {
    
    let label = UILabel.bodyLabel
    let imageView = UIImageView.imageView()

    override init() {
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 2
        clipsToBounds = true
        
        self.addSubview(imageView)
        imageView.centerY().right(constant: UIViewPadding.medium).width(constant: 10).widthEqualsHeight().apply()
        
        self.addSubview(label)
        label.left(constant: UIViewPadding.small).topbottom(constant: UIViewPadding.small).left(of: imageView, constant: UIViewPadding.medium).apply()
        label.numberOfLines = 1
        
        imageView.image = UIImage.iconBackLightGray()
        imageView.transform = imageView.transform.rotated(by: .pi)
        
        height(constant: UITextFieldHeight.forScreenSize).apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }

}
