//
//  UIViewController+Default.swift
//  CEUserControls
//
//  Created by Christoph Erl on 07.03.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

extension UIViewController {
    
    var visible: Bool {
        return isViewLoaded && view.window != nil
    }
    
    var statusBarHeight: CGFloat {
        let sharedApplication = UIApplication.shared
        if !sharedApplication.isStatusBarHidden {
            return sharedApplication.statusBarFrame.size.height
        }
        return 0.0
    }
    
    var navigationBarHeight: CGFloat {
        
        var nHeight: CGFloat = 0
        if let height = parent?.navigationController?.navigationBar.frame.height {
            nHeight = height
        }
        
        if let height = navigationController?.navigationBar.frame.height {
            nHeight = max(nHeight, height)
        }

        return nHeight
    }
    
    var toolbarHeight: CGFloat {
        if let navigationController = navigationController {
            return navigationController.isToolbarHidden ? 0.0 : navigationController.toolbar.frame.height
        }
        return 0.0
    }
    
    // Close View Controllers
    
    var topController: UIViewController {
        if let presentedViewController = presentedViewController {
            return presentedViewController.topController ?? presentedViewController
        }
        return self
    }
    
    func closePresentedControllers(_ completion: @escaping (()->())) {
        if let presentedViewController = presentedViewController?.presentedViewController {
            presentedViewController.closePresentedControllers(completion)
            
        } else if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: true, completion: { 
                self.closePresentedControllers(completion)
            })
            
        } else {
            dismiss(animated: true, completion: { 
                completion()
            })
        }
    }
    
    // MARK: - Utility for Keyboard
    
    func enableKeyboardDismissOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        if view.firstResponder is UITextField {
            view.endEditing(true)
        }
    }
    
}


