//
//  ERAnnotationView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 11.01.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import MapKit

// Constants
private let kSize          = CGSize(width: 24.0, height: 24.0 + kArrowHeight)
private let kSizeSelected  = CGSize(width: 36.0, height: 36.0 + kArrowHeight)
private let kSubCircleSize = CGSize(width: 2.0, height: 2.0)

private let kArrowHeight: CGFloat = 8.0

class ERAnnotationView: MKAnnotationView {
    
    // Variables
    var contentView: UIView { return pinView.contentView }
    var sideRatio: CGFloat  { return intrinsicContentSize.height / intrinsicContentSize.width }
    var shadowHidden: Bool  { set { pinView.shadowHidden = newValue } get { return pinView.shadowHidden } }
    
    // Override Variables
    override var isSelected:    Bool        { didSet { p_setSelected(oldValue: oldValue) } }
    override var tintColor:     UIColor!    { didSet { p_setTintColor(oldValue: oldValue) } }
    
    // Views
    private let pinView = PinView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        tintColor = UIColor.theme
        
        addSubview(pinView)
        pinView.match().apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        p_updateLayout()
    }
    
    override var intrinsicContentSize: CGSize {
        return isSelected ? kSizeSelected : kSize
    }

    // MARK: - Getters & Setters
    
    private func p_setSelected(oldValue: Bool) {
        pinView.isSelected = isSelected
        
        p_updateLayout(animated: true)
    }
    
    private func p_setTintColor(oldValue: UIColor!) {
        pinView.tintColor = tintColor
    }
    
    // MARK: Layout

    
    private func p_updateLayout(animated: Bool = false) {
        
        // Old & New Frame
        var oldFrame = frame
        oldFrame.size   = isSelected ? kSize : kSizeSelected
        oldFrame.origin = CGPoint(x: center.x - oldFrame.size.width / 2.0, y: center.y - oldFrame.size.height / 2.0)
        
        var newFrame = frame
        newFrame.size   = isSelected ? kSizeSelected : kSize
        newFrame.origin = CGPoint(x: center.x - newFrame.size.width / 2.0, y: center.y - newFrame.size.height / 2.0)
        
        frame = newFrame
        centerOffset = CGPoint(x: 0, y: -newFrame.height / 2)
        
        layoutIfNeeded()
        
        //mainShapeLayer.path = self.createMainPath(frame: oldFrame).cgPath
        
//        if animated {
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveEaseOut, animations: { 
//                
//                
//            }, completion: { (success) in
//                
//            })
//        } else {
//            frame = newFrame
//        }
    }    
}




private class PinView: ERView {
    
    // Attributes
    var             shadowHidden: Bool      = false         { didSet { p_setShadowHidden(oldValue: oldValue) } }
    var             isSelected:    Bool     = false         { didSet { p_setSelected(oldValue: oldValue) } }
    override var    tintColor:     UIColor!                 { didSet { p_setTintColor(oldValue: oldValue) } }
    
    let contentView             = UIView.initImageView()
    
    // Private Attributes
    private let shapeLayer  = CAShapeLayer()
    private let contentContainerView = ERView.view()
    
    // Private Constraints
    private var constraintBottom: NSLayoutConstraint!
    
    // Constants
    private let kMultiplier: CGFloat = 0.65
    
    override init() {
        super.init()
        
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.shadowColor = UIColor.black.cgColor
        
        shapeLayer.shadowOffset     = CGSize(width: 0, height: 0)
        
        layer.addSublayer(shapeLayer)
        
        addSubview(contentContainerView)
        contentContainerView.leftright().top().bottom(constant: 0, closure: { (constraint) in self.constraintBottom = constraint }).apply()
        
        contentContainerView.addSubview(contentView)
        contentView.centerXY().height(multiplier: kMultiplier).width(multiplier: kMultiplier).apply()
    
        p_setShadowHidden()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate override func layoutSubviews() {
        super.layoutSubviews()
        
        shapeLayer.frame        = bounds
        
        let path                = p_createPath(inFrame: bounds).cgPath
        shapeLayer.path         = path
        shapeLayer.shadowPath   = path
        
        constraintBottom.constant = (frame.height >= kArrowHeight ?  -kArrowHeight : 0)
    }
    
    // MARK: - Computed Variables
    
    
    // MARK: - Getters & Setters
    
    private func p_setSelected(oldValue: Bool) {
        
    }
    
    private func p_setTintColor(oldValue: UIColor!) {
        shapeLayer.fillColor = tintColor.cgColor
    }
    
    private func p_setShadowHidden(oldValue: Bool) {
        p_setShadowHidden()
    }
    
    private func p_setShadowHidden() {
        shapeLayer.shadowRadius     = shadowHidden ? 0 : 8.0
        shapeLayer.shadowOpacity    = shadowHidden ? 0 : 0.3
    }
    
    // MARK: - Private Methods
    
    private func p_createPath(inFrame: CGRect) -> UIBezierPath {        
        return UIBezierPath.pin(rect: inFrame, arrowHeight: kArrowHeight)
    }
    
}
