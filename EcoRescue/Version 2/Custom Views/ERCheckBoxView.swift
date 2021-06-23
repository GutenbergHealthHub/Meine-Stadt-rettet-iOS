//
//  ERCheckBoxView.swift
//  EcoRescueASB
//
//  Created by Birtan on 19.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERCheckBoxView: Control {
    
    private let checkImage = UIImageView.imageView()
    
    var check: Bool = false { didSet { setCheck(oldValue: oldValue) } }

    override init() {
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderWidth = 2
        layer.borderColor = UIColor.gray.cgColor
        layer.masksToBounds = true
        
        addSubview(checkImage)
        checkImage.match(constant: UIViewPadding.small).apply()
        
        checkImage.contentMode = .scaleAspectFit
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func setCheck(oldValue: Bool) {
        if oldValue == check { return }
        
        checkImage.image = check ? UIImage.iconTickSmall() : nil
        
    }
    
}
