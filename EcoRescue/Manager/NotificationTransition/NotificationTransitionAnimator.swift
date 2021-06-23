//
//  NotificationTransitionAnimator.swift
//  Nachtigall
//
//  Created by Christoph Erl on 27.02.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

private let kHeight: CGFloat = 480.0

class NotificationTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // Get Container View
        let containerView = transitionContext.containerView
        
        // Get View From Transition Context
        if presenting {
            let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
            toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: kHeight)
            
            backgroundView.transform    = CGAffineTransform(translationX: 0, y: kHeight)
            shadowView.alpha            = 0.0
            
            containerView.addSubview(shadowView)
            containerView.addSubview(backgroundView)
            
            shadowView.match().apply()
            backgroundView.leftright().bottom().height(constant: kHeight).apply()
            backgroundView.layoutIfNeeded()

            backgroundView.addSubview(toView)
            
            // get the duration of the animation
            let duration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                self.shadowView.alpha = 0.75
                self.backgroundView.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
        } else {
            let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
            toViewController.beginAppearanceTransition(true, animated: true)
            // get the duration of the animation
            let duration = self.transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: {
                self.shadowView.alpha = 0.0
                self.backgroundView.transform = CGAffineTransform(translationX: 0, y: kHeight)
                
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                toViewController.endAppearanceTransition()
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return presenting ? 0.3 : 0.2
    }
    
    // MARK: - Private Views
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.black
        return view
    }()
    
    private lazy var backgroundView: UIView = {
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            view.backgroundColor = .clear
            
            let blurEffect      = UIBlurEffect(style: UIBlurEffectStyle.light)
            let blurEffectView  = UIVisualEffectView(effect: blurEffect)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false

            view.addSubview(blurEffectView)
            blurEffectView.match().apply()
        } else {
            view.backgroundColor = .white
        }
        
        return view
    }()

}
