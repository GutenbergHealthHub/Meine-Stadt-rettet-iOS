//
//  UIView+Constraints.swift
//  Basics
//
//  Created by Christoph Erl on 26.01.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

public extension UIView {
    
    public func removeSubviews() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    public func removeConstraints() {
        var superview = self.superview
        
        while (superview != nil) {
            if let sv = superview {
                
                for constraint in sv.constraints {
                    if (constraint.firstItem as? NSObject == self || constraint.secondItem as? NSObject == self) {
                        sv.removeConstraint(constraint)
                    }
                }
                superview = sv.superview;
            }
        }
    }
    
    
    public class func applyConstraintEqualSizeWithViews(_ views: [UIView]) {
        let multiplier = 1 / CGFloat(views.count)
        
        var view: UIView?
        for v in views {
            v.applyConstraintWidthOfSuperview(multiplier)
            v.applyConstraintTopBottomToSuperview()
            
            if let view = view {
                v.applyConstraintRightOfView(view)
            } else {
                v.applyConstraintLeftToSuperview()
            }
            view = v
        }
    }
    
    public class func applyConstraintEqualSizeVerticalWithViews(_ views: [UIView]) {
        let multiplier = 1 / CGFloat(views.count)
        
        var view: UIView?
        for v in views {
            v.applyConstraintHeightOfSuperview(multiplier)
            v.applyConstraintLeftRightToSuperview()
            
            if let view = view {
                v.applyConstraintBottomOfView(view)
            } else {
                v.applyConstraintTopToSuperview()
            }
            view = v
        }
    }
    
    // Merge
    public func applyConstraintMatchParent(_ padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
        return applyConstraintMatchParent(padding, paddingVertical: padding)
    }
    
    public func applyConstraintMatchParent(_ paddingHorizontal: CGFloat, paddingVertical: CGFloat) -> [NSLayoutConstraint] {
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: applyConstraintLeftRightToSuperview(paddingHorizontal))
        constraints.append(contentsOf: applyConstraintTopBottomToSuperview(paddingVertical))
        return constraints
    }
    
    public func applyConstraintMatchView(_ view: UIView, padding: CGFloat) {
        applyConstraintLeftToView(view, padding: padding)
        applyConstraintTopToView(view, padding: padding)
        applyConstraintRightToView(view, padding: padding)
        applyConstraintBottomToView(view, padding: padding)
    }
    
    public func applyConstraintMatchView(_ view: UIView, inset: UIEdgeInsets) {
        applyConstraintLeftToView(view, padding: inset.left)
        applyConstraintTopToView(view, padding: inset.top)
        applyConstraintRightToView(view, padding: inset.right)
        applyConstraintBottomToView(view, padding: inset.bottom)
    }
    
    public func applyConstraintCenterXY(_ padding: CGFloat = 0.0) {
        applyConstraintCenterX(padding)
        applyConstraintCenterY(padding)
    }
    
    public func applyConstraintCenterX(_ padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        if let superview = superview {
            return add(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: padding))
        }
        return nil
    }
    
    public func applyConstraintCenterY(_ padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        if let superview = superview {
            return add(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: padding))
        }
        return nil
    }
    
    public func applyConstraintHeight(_ height: CGFloat) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: height))
    }
    
    public func applyConstraintWidth(_ height: CGFloat) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: height))
    }
    
    public func applyConstraintMinWidth(_ minHeight: CGFloat) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: nil, attribute: .width, multiplier: 1.0, constant: minHeight))
    }
    
    public func applyConstraintWidth() -> NSLayoutConstraint? {
        return applyConstraintWidth(self.intrinsicContentSize.width)
    }
    
    public func applyConstraintHeight() -> NSLayoutConstraint? {
        return applyConstraintHeight(self.intrinsicContentSize.height)
    }
    
    public func applyConstraintWidthEqualsHeight() -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .height, multiplier: 1.0, constant: 0.0))
    }
    
    public func applyConstraintHeightEqualsWidth() -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .width, multiplier: 1.0, constant: 0.0))
    }
    
    public func applyConstraintWidthOfSuperview(_ multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
        if let superview = superview {
            return add(NSLayoutConstraint(item: self, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: .width, multiplier: multiplier, constant: 0.0))
        }
        return nil
    }
    
    public func applyConstraintHeightOfSuperview(_ multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
        if let superview = superview {
            return add(NSLayoutConstraint(item: self, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: superview, attribute: .height, multiplier: multiplier, constant: 0.0))
        }
        return nil
    }
    
    public func applyConstraintHeightOfView(_ view: UIView, multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
        if let _ = superview {
            return add(NSLayoutConstraint(item: self, attribute: .height, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .height, multiplier: multiplier, constant: 0.0))
        }
        return nil
    }
    
    public func applyConstraintWidthOfView(_ view: UIView, multiplier: CGFloat = 1.0) -> NSLayoutConstraint? {
        if let _ = superview {
            return add(NSLayoutConstraint(item: self, attribute: .width, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .width, multiplier: multiplier, constant: 0.0))
        }
        return nil
    }
    
    // Left, Top, Right, Bottom
    public func applyConstraintLeftRightToSuperview(_ padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
    
        var constraints = [NSLayoutConstraint]()
        constraints.append(applyConstraintLeftToSuperview(padding))
        constraints.append(applyConstraintRightToSuperview(padding))
        return constraints
    }
    
    public func applyConstraintTopBottomToSuperview(_ padding: CGFloat = 0.0) -> [NSLayoutConstraint] {
       
        var constraints = [NSLayoutConstraint]()
        constraints.append(applyConstraintTopToSuperview(padding))
        constraints.append(applyConstraintBottomToSuperview(padding))
        return constraints
    }
    
    // MARK: - Left/Top/Right/Bottom To View
    public func applyConstraintLeftToSuperview(_ padding: CGFloat = 0.0) -> NSLayoutConstraint! {
        if let superview = superview {
            return applyConstraintLeftToView(superview, padding: padding)
        }
        return nil
    }
    
    public func applyConstraintTopToSuperview(_ padding: CGFloat = 0.0) -> NSLayoutConstraint! {
        if let superview = superview {
            return applyConstraintTopToView(superview, padding: padding)
        }
        return nil
    }
    
    public func applyConstraintRightToSuperview(_ padding: CGFloat = 0.0) -> NSLayoutConstraint! {
        if let superview = superview {
            return applyConstraintRightToView(superview, padding: padding)
        }
        return nil
    }
    
    public func applyConstraintBottomToSuperview(_ padding: CGFloat = 0.0) -> NSLayoutConstraint! {
        if let superview = superview {
            return applyConstraintBottomToView(superview, padding: padding)
        }
        return nil
    }
    
    // MARK: - Left/Top/Right/Bottom To View
    public func applyConstraintLeftToView(_ view: UIView, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .left, multiplier: 1.0, constant: padding))
    }
    
    public func applyConstraintTopToView(_ view: UIView, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1.0, constant: padding))
    }
    
    public func applyConstraintRightToView(_ view: UIView, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: view, attribute: .right, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .right, multiplier: 1.0, constant: padding))
    }
    
    public func applyConstraintBottomToView(_ view: UIView, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: padding))
    }
    
    // MARK: - Left/Top/Right/Bottom Of
    public func applyConstraintLeftOfView(_ view: UIView, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .right, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .left, multiplier: 1.0, constant: -padding))
    }
    
    public func applyConstraintTopOfView(_ view: AnyObject, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .top, multiplier: 1.0, constant: -padding))
    }
    
    public func applyConstraintRightOfView(_ view: UIView, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .left, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .right, multiplier: 1.0, constant: padding))
    }
    
    public func applyConstraintBottomOfView(_ view: AnyObject, padding: CGFloat = 0.0) -> NSLayoutConstraint? {
        return add(NSLayoutConstraint(item: self, attribute: .top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: padding))
    }
    
    // MARK: - Helper
    
    fileprivate func add(_ constraint: NSLayoutConstraint) -> NSLayoutConstraint? {
        if let superview = superview {
            superview.addConstraint(constraint)
            return constraint
        }
        return nil
    }
    
}
