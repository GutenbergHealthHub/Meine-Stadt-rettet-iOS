//
//  ERDescriptionView.swift
//  EcoRescueASB
//
//  Created by Birtan on 23.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERDescriptionView: UIView {
    
    private let imageView = UIImageView.imageView()
    private let label     = UILabel.type2LightLabel(.callout)

    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.colorPrimaryBlue
        
        addSubview(imageView)
        addSubview(label)
        
        imageView.left(constant: UIViewPadding.big).centerY().height(multiplier: 0.3).widthEqualsHeight().apply()
        label.topbottom(constant: UIViewPadding.small).right(of: imageView, constant: UIViewPadding.big).right(constant: UIViewPadding.small).apply()
        
        label.numberOfLines = 0
        label.textColor = UIColor.white
        
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var text: String? {
        set { label.text = newValue; invalidateIntrinsicContentSize()  }
        get { return label.text                                        }
    }
    
    public var image: UIImage? {
        set { imageView.image = newValue; invalidateIntrinsicContentSize()  }
        get { return imageView.image                                        }
    }

}
