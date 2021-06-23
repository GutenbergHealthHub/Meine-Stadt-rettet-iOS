//
//  ERStatusLabel.swift
//  EcoRescue
//
//  Created by Birtan on 23.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERStatusLabel: UILabel {
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }
    
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = UIEdgeInsetsInsetRect(bounds, textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return UIEdgeInsetsInsetRect(textRect, invertedInsets)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, textInsets))
    }
    
    func setTextInsets(left: CGFloat, right: CGFloat, top: CGFloat, bottom: CGFloat) {
        textInsets.left   = left
        textInsets.right  = right
        textInsets.top    = top
        textInsets.bottom = bottom
    }

}
