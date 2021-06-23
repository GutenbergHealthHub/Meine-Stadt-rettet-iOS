//
//  View.swift
//  EcoRescue
//
//  Created by Christoph Erl on 27.09.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class View: UIView {

    init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var preferredIntrinsicContentSize: CGSize? {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override var intrinsicContentSize: CGSize {
        return preferredIntrinsicContentSize ?? super.intrinsicContentSize
    }
    
}
