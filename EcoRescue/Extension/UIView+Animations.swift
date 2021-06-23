//
//  UIView+Animations.swift
//  CEUserControls
//
//  Created by Christoph Erl on 10.03.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

private let kUIViewAnimationDamping: CGFloat = 0.8
private let kUIViewAnimationVelocity: CGFloat = 0.4

private let kUIViewAnimationDurationSmall: TimeInterval = 0.2

public extension UIView {
    
    func fadeOut() {
        animateLinearAlpha(0.0, duration: 0.2, delay: 0)
    }
    
    func fadeIn() {
        animateLinearAlpha(1.0, duration: 0.2, delay: 0)
    }
    
    public func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
    
    func animateLinearScale(_ scale: CGFloat, duration: TimeInterval, delay: TimeInterval, completion: (() -> ())? = nil) {
        UIView.animateLinear(duration, delay: delay, animations: { () -> () in
            self.transform = CGAffineTransform(scaleX: scale, y: scale)
            }, completion: completion)
    }
    
    
    func animateLinearAlpha(_ alpha: CGFloat, duration: TimeInterval, delay: TimeInterval, completion: (() -> ())? = nil) {
        UIView.animateLinear(duration, delay: delay, animations: { () -> () in
            self.alpha = alpha
            }, completion: completion)
    }
    
    func animateLinearScale(_ scale: CGFloat, completion: (() -> ())? = nil) {
        let duration = kUIViewAnimationDurationSmall
        animateLinearScale(scale, duration: duration, delay: 0.0, completion: nil)
    }
    
    class func animateLinear(_ duration: TimeInterval, delay: TimeInterval, animations: @escaping (() -> ()), completion: (() -> ())?) {
        UIView.animate(withDuration: duration, delay: delay, options: .curveLinear, animations: { () -> Void in
            animations()
            }) { (success) -> Void in
                completion?()
        }
    }
    
    class func animateLinear(_ duration: TimeInterval = kUIViewAnimationDurationSmall, animations: @escaping (() -> ()), completion: (() -> ())?) {
        UIView.animateLinear(duration, delay: 0.0, animations: animations, completion: completion)
    }
    
    public func layoutAnimated(_ duration: TimeInterval = kUIViewAnimationDurationSmall, completion: (() -> ())? = nil) {
        UIView.animate(withDuration: duration, animations: { () -> Void in
            self.layoutIfNeeded()
            }, completion: { (success) -> Void in
                completion?()
        }) 
    }
    
    // Spring
    
    public class func animateSpring(_ duration: TimeInterval, delay: TimeInterval, animations: @escaping (() -> ()), completion: (() -> ())?) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: kUIViewAnimationDamping, initialSpringVelocity: kUIViewAnimationVelocity, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
            animations()
            }) { (success) -> Void in
                completion?()
        }
    }
    
}
