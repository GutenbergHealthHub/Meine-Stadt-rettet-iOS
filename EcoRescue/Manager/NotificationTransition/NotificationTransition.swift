//
//  NotificationTransition.swift
//  Nachtigall
//
//  Created by Christoph Erl on 27.02.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class NotificationTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    private let notificationTransitionAnimator = NotificationTransitionAnimator()
    
    // MARK: - Static Methods
    
    static func present(from: UIViewController, to: UCViewControllerProtocol) {
        to.modalPresentationStyle       = .custom
        to.transitioningStrongDelegate  = NotificationTransition()
        from.present(to.controller, animated: true, completion: nil)
    }
    
    // MARK: - UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        notificationTransitionAnimator.presenting = true
        return notificationTransitionAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        notificationTransitionAnimator.presenting = false
        return notificationTransitionAnimator
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return NotificationTransitionController(presentedViewController: presented, presenting: presenting)
    }
 
    
}
