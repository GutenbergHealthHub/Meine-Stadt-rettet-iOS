//
//  UIView+Layout.swift
//  Layout
//
//  Created by Christoph Erl on 05.10.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

// Default Values
let kUIViewLineWidthNormal: CGFloat = 1.0

let kUIViewPaddingSmall: CGFloat = 4.0
let kUIViewPaddingMedium: CGFloat = 8.0
let kUIViewPaddingBig: CGFloat = 16.0
let kUIViewPaddingLarge: CGFloat = 20.0
let kUIViewPaddingHuge: CGFloat = 32.0

let kUIPaddingSmall: CGFloat = 4.0
let kUIPaddingMedium: CGFloat = 8.0
let kUIPaddingBig: CGFloat = 16.0
let kUIPaddingLarge: CGFloat = 20.0
let kUIPaddingHuge: CGFloat = 32.0

let kUIRowSmall: CGFloat = 34.0
let kUIRowMedium: CGFloat = 44.0
let kUIRowBig: CGFloat = 54.0
let kUIRowLarge: CGFloat = 64.0

let kUIBarXSmall: CGFloat = 14.0
let kUIBarSmall: CGFloat = 24.0
let kUIBarMedium: CGFloat = 44.0
let kUIBarBig: CGFloat = 64.0

let kUISectionHeaderMedium: CGFloat = 22.0

let kUICornerRadius:  CGFloat = 4.0
let kUIShadowOpacity: Float   = 0.2
let kUIShadowRadius:  CGFloat = 1.0

class UIViewPadding {
    static let tiny:    CGFloat = 2.0
    static let small:   CGFloat = 4.0
    static let medium:  CGFloat = 8.0
    static let big:     CGFloat = 16.0
    static let large:   CGFloat = 20.0
}

class UIViewRowHeight {
    static let tiny:    CGFloat = 32.0
    static let small:   CGFloat = 44.0
    static let medium:  CGFloat = 54.0
    static let big:     CGFloat = 64.0
    static let large:   CGFloat = 84.0
    static let huge:    CGFloat = 104.0
}

class UITableViewSectionHeaderHeight {
    static let small:   CGFloat = 36.0
}

class UIViewShadow {
    static let mediumRadius:    CGFloat = 4.0
    static let mediumOpacity:   Float   = 0.2
    static let lowOpacity:      Float   = 0.05
}

class UITextFieldHeight {
    static var forScreenSize: CGFloat {
        switch UIScreen.main.bounds.height {
        case 568:
            return 35
        case 736:
            return 45
        default:
            return 40
        }
    }
}

class UIButtonHeight {
    static var forScreenSize: CGFloat {
        switch UIScreen.main.bounds.height {
        case 568:
            return 35
        case 736:
            return 50
        default:
            return 45
        }
    }
}

private let kUIViewDefaultPriority: Float = 1000

extension UIView {
    
    // MARK: - View
    
    class func view() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        return view
    }

    func apply() {}
    
    // MARK: - Width, Height
    
    func width(constant: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, toAttribute: .notAnAttribute, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func minHeight(constant: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, toAttribute: .notAnAttribute, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func minWidth(constant: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .width, relatedBy: .greaterThanOrEqual, toItem: nil, toAttribute: .notAnAttribute, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func maxHeight(constant: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .height, relatedBy: .lessThanOrEqual, toItem: nil, toAttribute: .notAnAttribute, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }

    func maxWidth(constant: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .width, relatedBy: .lessThanOrEqual, toItem: nil, toAttribute: .notAnAttribute, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func width(multiplier: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .width, relatedBy: .equal, toItem: superview!, toAttribute: .width, multiplier: multiplier, constant: 0.0, priority: priority, closure: closure)
    }
    
    func widthEqualsHeight(multiplier: CGFloat = 1, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, toAttribute: .height, multiplier: multiplier, constant: 0.0, priority: priority, closure: closure)
    }
    
    func height(constant: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, toAttribute: .notAnAttribute, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func height(multiplier: CGFloat, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .height, relatedBy: .equal, toItem: superview!, toAttribute: .height, multiplier: multiplier, constant: 0.0, priority: priority, closure: closure)
    }
    
    func heightEqualsWidth(multiplier: CGFloat = 1, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: self, toAttribute: .width, multiplier: multiplier, constant: 0.0, priority: priority, closure: closure)
    }
    
    // MARK: - Center
    
    func centerX(to: UIView, constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .centerX, relatedBy: .equal, toItem: to, toAttribute: .centerX, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func centerX(constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .centerX, relatedBy: .equal, toItem: superview!, toAttribute: .centerX, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func centerY(to: UIView, constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .centerY, relatedBy: .equal, toItem: to, toAttribute: .centerY, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func centerY(constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview!, toAttribute: .centerY, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func centerYWithMulitplier(multiplier: CGFloat = 0, priority: Float = kUIViewDefaultPriority, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .centerY, relatedBy: .equal, toItem: superview!, toAttribute: .centerY, multiplier: multiplier, constant: 0, priority: priority, closure: closure)
    }
    
    func centerXY() -> UIView {
        _ = centerY(constant: 0)
        _ = centerX(constant: 0)
        return self
    }
    
    // MARK: - Match, leftright, topbottom
    
    func match(constant: CGFloat = 0) -> UIView {
        _ = leftright(constant: constant)
        _ = topbottom(constant: constant)
        return self
    }
    
    func match(view: UIView, constant: CGFloat = 0) -> UIView {
        _ = left(to: view, constant: constant)
        _ = right(to: view, constant: constant)
        _ = top(to: view, constant: constant)
        _ = bottom(to: view, constant: constant)
        return self
    }
    
    func leftright(constant: CGFloat = 0) -> UIView {
        _ = left(to: superview!, constant: constant)
        _ = right(to: superview!, constant: constant)
        return self
    }
    
    func topbottom(constant: CGFloat = 0) -> UIView {
        _ = top(to: superview!, constant: constant)
        _ = bottom(to: superview!, constant: constant)
        return self
    }
    
    // MARK: - Left, Top, Right, Bottom
    
    func right(constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return right(to: superview!, constant: constant, relatedBy: relatedBy, closure: closure)
    }
    
    func right(to: UIView, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .right, relatedBy: relatedBy, toItem: to, toAttribute: .right, multiplier: 1.0, constant: -constant, priority: priority,  closure: closure)
    }
    
    func right(of: UIView, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .left, relatedBy: relatedBy, toItem: of, toAttribute: .right, multiplier: 1.0, constant: constant, priority: priority,  closure: closure)
    }
    
    func left(constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return left(to: superview!, constant: constant, relatedBy: relatedBy, closure: closure)
    }
    
    func left(to: UIView, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .left, relatedBy: relatedBy, toItem: to, toAttribute: .left, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func left(of: UIView, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .right, relatedBy: relatedBy, toItem: of, toAttribute: .left, multiplier: 1.0, constant: -constant, priority: priority, closure: closure)
    }
    
    func top(constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return top(to: superview!, constant: constant, relatedBy: relatedBy, closure: closure)
    }
    
    func top(to: Any, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .top, relatedBy: relatedBy, toItem: to, toAttribute: .top, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    func top(of: Any, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .bottom, relatedBy: relatedBy, toItem: of, toAttribute: .top, multiplier: 1.0, constant: -constant, priority: priority, closure: closure)
    }
    
    func bottom(constant: CGFloat = 0, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return bottom(to: superview!, constant: constant, relatedBy: relatedBy, closure: closure)
    }
    
    func bottom(to: Any, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .bottom, relatedBy: relatedBy, toItem: to, toAttribute: .bottom, multiplier: 1.0, constant: -constant, priority: priority, closure: closure)
    }
    
    func bottom(of: Any, constant: CGFloat, priority: Float = kUIViewDefaultPriority, relatedBy: NSLayoutRelation = .equal, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        return applyConstraintToSuperview(item: self, attribute: .top, relatedBy: relatedBy, toItem: of, toAttribute: .bottom, multiplier: 1.0, constant: constant, priority: priority, closure: closure)
    }
    
    // MARK: - Helper Methods
    
    private func applyConstraintToSuperview(item: Any, attribute: NSLayoutAttribute, relatedBy: NSLayoutRelation, toItem: Any?, toAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, priority: Float = 0, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        
        let layoutConstraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: toAttribute, multiplier: multiplier, constant: constant)
        layoutConstraint.priority = priority
        
        superview!.addConstraint(layoutConstraint)
        closure?(layoutConstraint)
        
        return self
    }
    
    private func applyConstraint(item: Any, attribute: NSLayoutAttribute, relatedBy: NSLayoutRelation, toItem: Any?, toAttribute: NSLayoutAttribute, multiplier: CGFloat, constant: CGFloat, priority: Float = 0, closure: ((NSLayoutConstraint) ->())? = nil) -> UIView {
        
        let layoutConstraint = NSLayoutConstraint(item: item, attribute: attribute, relatedBy: relatedBy, toItem: toItem, attribute: toAttribute, multiplier: multiplier, constant: constant)
        layoutConstraint.priority = priority
        
        addConstraint(layoutConstraint)
        closure?(layoutConstraint)
        
        return self
    }
    
    // Class
    
    class func alignHorizontally(views: [UIView]) {
        let multiplier = 1 / CGFloat(views.count)
        
        var tempView: UIView?
        for view in views {
            view.width(multiplier: multiplier).topbottom().apply()
            
            if let tempView = tempView {
                view.right(of: tempView, constant: 0).apply()
            } else {
                view.left().apply()
            }
            tempView = view
        }
    }
    
    class func alignVertically(views: [UIView]) {
        
        var tempView: UIView?
        for view in views {
            view.leftright().apply()
            
            if let tempView = tempView {
                view.bottom(of: tempView, constant: UIViewPadding.small).apply()
            } else {
                view.top().apply()
            }
            tempView = view
        }
    }
    
}
