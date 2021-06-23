//
//  BadgeView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.10.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class BadgeView: View {

    private let label = UILabel.bodyLabel
    
    override init() {
        super.init()
        
        label.textColor     = UIColor.white
        label.textAlignment = .center
        
        addSubview(label)
        label.leftright(constant: UIViewPadding.tiny).topbottom(constant: UIViewPadding.tiny).apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        
        // Height
        let height  = label.intrinsicContentSize.height
        let paddingHeight = 2 * UIViewPadding.tiny
        
        // Width
        let width  = max(label.intrinsicContentSize.width, height)
        let paddingWidth = 2 * UIViewPadding.tiny
        
        return CGSize(width: width + paddingWidth, height: height + paddingHeight)
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return intrinsicContentSize
    }
    
    override func draw(_ rect: CGRect) {
        let drawRect = rect.insetBy(dx: 1, dy: 1)
        let radius = min(drawRect.height / 2, drawRect.width / 2)
        
        if isFilled {
            tintColor.setFill()
            UIColor.clear.setStroke()
        } else {
            UIColor.clear.setFill()
            tintColor.setStroke()
        }
        
        let path = UIBezierPath(roundedRect: drawRect, cornerRadius: radius)
        path.lineWidth = 1
        path.fill()
        path.stroke()
    }
    
    override var tintColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isFilled: Bool = true {
        didSet {
            p_setFilled()
        }
    }
    
    var value: String? {
        set { label.text = newValue }
        get { return label.text     }
    }

    // MARK: - Private Methods
    
    private func p_setFilled() {
        if isFilled {
            label.textColor     = UIColor.white
        } else {
            label.textColor     = tintColor
        }
        setNeedsDisplay()
    }
    
}
