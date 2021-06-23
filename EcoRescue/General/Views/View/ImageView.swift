
//
//  ImageView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 01.04.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ImageView: UIImageView {

    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: -1, height: -1)
    }
    
}
