//
//  UIView+Default.swift
//  Basics
//
//  Created by Christoph Erl on 26.01.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

public let kUIViewDefaultPaddingSmall:     CGFloat = 4.0
public let kUIViewDefaultPaddingMedium:    CGFloat = 8.0
public let kUIViewDefaultPaddingLarge:     CGFloat = 16.0
public let kUIViewDefaultPaddingHuge:      CGFloat = 20.0

public let kUIViewDefaultSizeBarXSmall:     CGFloat = 18.0
public let kUIViewDefaultSizeBarSmall:     CGFloat = 24.0
public let kUIViewDefaultSizeBarMedium:    CGFloat = 44.0
public let kUIViewDefaultSizeBarBig:       CGFloat = 54.0
public let kUIViewDefaultSizeBarLarge:     CGFloat = 64.0
public let kUIViewDefaultSizeBarXLarge:    CGFloat = 84.0
public let kUIViewDefaultSizeBarXXLarge:   CGFloat = 104.0
public let kUIViewDefaultSizeBarXXXLarge:  CGFloat = 124.0

public let kUIViewDefaultRowHeightSmall:    CGFloat = 24.0
public let kUIViewDefaultRowHeightMedium:   CGFloat = 44.0
public let kUIViewDefaultRowHeightBig:      CGFloat = 54.0
public let kUIViewDefaultRowHeightLarge:    CGFloat = 64.0
public let kUIViewDefaultRowHeightHuge:     CGFloat = 84.0

public let kUIViewDefaultValueMax:          CGFloat = 4000.0

extension UIView {
    
    class func seperatorView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.separator
        return view
    }
    
    var autoLayout: Bool {
        set { translatesAutoresizingMaskIntoConstraints = !newValue  }
        get { return !translatesAutoresizingMaskIntoConstraints      }
    }
    
    var firstResponder: UIView? {
        for view in subviews {
            if view.isFirstResponder {
                return view
            }
            
            if let recursiveSubView = view.firstResponder {
                return recursiveSubView
            }
        }
        
        return nil
    }
    
    func addBorder(withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        border.frame = CGRect(x: frame.minX, y: frame.maxY, width: frame.width, height: thickness)
        
        layer.addSublayer(border)
    }
    
}

public extension UIScrollView {
    
    public class func scrollView() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }
    
}

public extension UIBarButtonItem {


    public class func barButtonItem(_ image: UIImage?, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: image, style: UIBarButtonItemStyle.plain, target: target, action: action)
    }
    
}

public extension UIButton {
    
    public class func button() -> UIButton {
        let button = UIButton(type: UIButtonType.system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
}

extension UIToolbar {
    
    class func toolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        return toolbar
    }
    
}

public extension UIImageView {
    
    public class func imageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    public func setColor(_ color: UIColor) {
        if let image = self.image {
            self.image = image.imageWithColor(color)
        }
    }
    
}

public extension UISlider {
    
    public class func slider() -> UISlider {
        let slider = UISlider(frame: CGRect.zero)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }
    
}

public extension UIView {
    
    public class func initSwitch() -> UISwitch {
        let switchView = UISwitch(frame: CGRect.zero)
        switchView.translatesAutoresizingMaskIntoConstraints = false
        return switchView
    }
    
}

extension UITabBar {
    
    func makeTransparent() {
        backgroundImage = UIImage()
        shadowImage = UIImage()
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    func undoTransparent() {
        backgroundImage = nil
        shadowImage = nil
    }
    
}

extension UIToolbar {
    
    func makeTransparent() {
        setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
        setShadowImage(UIImage(), forToolbarPosition: .any)
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    func undoTransparent() {
        setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
        setShadowImage(nil, forToolbarPosition: .any)
    }
    
}

extension UINavigationBar {

    func makeTransparent() {
        setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        shadowImage = UIImage()
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
    }
    
    func undoTransparent() {
        setBackgroundImage(nil, for: UIBarMetrics.default)
        shadowImage = nil
    }
    
    func showBottomLine(_ show: Bool) {
        for subview in self.subviews {
            if (NSStringFromClass(subview.classForCoder) as NSString).range(of: "BarBackground").location != NSNotFound {
                for subsubview in subview.subviews {
                    if subsubview.isKind(of: UIImageView.classForCoder()) {
                        if subsubview.bounds.height == 0.5 {
                            (subsubview as! UIImageView).alpha = show ? 1.0 : 0.0
                            return
                        }
                    }
                    
                }
                
            }
        }
    }
    
    
}

public extension UIBarButtonItem {
    
    public class func item(_ image: UIImage?, target: AnyObject?, action: Selector) -> UIBarButtonItem {
        return UIBarButtonItem(image: image, style: .plain, target: target, action: action)
    }
    
}

public extension UITextField {
    
    class func textField() -> UITextField {
        let textField = UITextField(frame: CGRect.zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
}

public extension UITextView {
    
    class func textView() -> UITextView {
        let textView = UITextView(frame: CGRect.zero)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }
}
