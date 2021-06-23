//
//  ERContainerViewController.swift
//  EcoRescue
//
//  Created by Birtan on 01.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import QuartzCore

class ERContainerViewController: UIViewController {
    
    let centerPanelExpandedOffset: CGFloat = 60
    
    var centerNavigationController: UINavigationController!
    var homeViewController: ERHomeViewController!
    var sideMenuViewController: ERSideMenuViewController!
    
    var isSideMenuExpanded = false
    
    var statusBarIsHidden: Bool = false { didSet { setStatusBarIsHidden() } }

    override func viewDidLoad() {
        super.viewDidLoad()

        homeViewController = ERHomeViewController()
        homeViewController.delegate = self
        
        centerNavigationController = UINavigationController(rootViewController: homeViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarIsHidden
    }
    
    private func setStatusBarIsHidden() {
        UIView.animate(withDuration: 0.2) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    func addSideMenuViewController() {
        guard sideMenuViewController == nil else { return }
        
        sideMenuViewController = ERSideMenuViewController()
        view.insertSubview(sideMenuViewController.view, at: 0)
        
        addChildViewController(sideMenuViewController)
        sideMenuViewController.delegate = self
        sideMenuViewController.didMove(toParentViewController: self)
    }
    
    func animateLeftMenu(shouldExpand: Bool) {
        if shouldExpand {
            self.addBlurEffect()
            animateCenterPanelXPosition(targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset) { finished in
                self.isSideMenuExpanded = true
                self.statusBarIsHidden  = true
            }
            showShadowForCenterViewController(true)
        } else {
            removeBlurEffect()
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.isSideMenuExpanded = false
                self.statusBarIsHidden  = false
                self.sideMenuViewController?.view.removeFromSuperview()
                self.sideMenuViewController = nil
            }
            showShadowForCenterViewController(false)
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { self.centerNavigationController.view.frame.origin.x = targetPosition }, completion: completion)
    }
    
    func showShadowForCenterViewController(_ shouldShowShadow: Bool) {
        
        if shouldShowShadow {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    func addBlurEffect() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        centerNavigationController.visibleViewController?.view.addSubview(blurEffectView)
    }
    
    func removeBlurEffect() {
        centerNavigationController.visibleViewController?.view.subviews.forEach { view in
            if view is UIVisualEffectView {
                view.removeFromSuperview()
            }
        }
    }

}

extension ERContainerViewController: CenterMenuViewControllerDelegate {
    func toggleLeftPanel() {
        if !isSideMenuExpanded {
            addSideMenuViewController()
        }
        
        animateLeftMenu(shouldExpand: !isSideMenuExpanded)
    }
    
    func changeViewController(to: Int) {
        
        removeBlurEffect()
        
        switch to {
            
        //HOME PAGE
        case 1:
            if !(centerNavigationController.topViewController is ERHomeViewController) {
                
                centerNavigationController.popToRootViewController(animated: false)
            }
            break
        
        //MAP
        case 2:
            if !(centerNavigationController.topViewController is ERMapV2ViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let mapViewController = ERMapV2ViewController()
                mapViewController.delegate = self
                centerNavigationController.pushViewController(mapViewController, animated: false)
            }
            break
            
        //NEWS & EVENTS
        case 3:
            if !(centerNavigationController.topViewController is ERNewsAndEventsV2ViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let newsAndEventsViewController = ERNewsAndEventsV2ViewController()
                newsAndEventsViewController.delegate = self
                centerNavigationController.pushViewController(newsAndEventsViewController, animated: false)
            }
            break
          /*
        //NEWS
        case 3:
            if !(centerNavigationController.topViewController is ERNewsV2ViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let newsViewController = ERNewsV2ViewController()
                newsViewController.delegate = self
                centerNavigationController.pushViewController(newsViewController, animated: false)
            }
            break
            
        //EVENTS
        case 4:
            if !(centerNavigationController.topViewController is EREventsV2ViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let eventsViewController = EREventsV2ViewController()
                eventsViewController.delegate = self
                centerNavigationController.pushViewController(eventsViewController, animated: false)
            }
            break
            */
        //COURSES
        case 5:
            if !(centerNavigationController.topViewController is ERCoursesV2ViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let coursesViewController = ERCoursesV2ViewController()
                coursesViewController.delegate = self
                centerNavigationController.pushViewController(coursesViewController, animated: false)
            }
            break
            
        //PROFILE
        case 6:
            if !(centerNavigationController.topViewController is ERProfileV2ViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let profileViewController = ERProfileV2ViewController()
                profileViewController.delegate = self
                centerNavigationController.pushViewController(profileViewController, animated: false)
            }
            break
            
        //SETTINGS
        case 7:
            if !(centerNavigationController.topViewController is ERSettingsV2ViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let settingsViewController = ERSettingsV2ViewController()
                settingsViewController.delegate = self
                centerNavigationController.pushViewController(settingsViewController, animated: false)
            }
            break
        
        //STANDBY
        case 8:
            if !(centerNavigationController.topViewController is ERStandByViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let standbyViewController = ERStandByViewController()
                standbyViewController.delegate = self
                centerNavigationController.pushViewController(standbyViewController, animated: false)
            }
            break
            
        //AboutTheProject
        case 9:
            let introPage = ERIntroPageViewController()
            centerNavigationController.topViewController?.present(introPage, animated: true, completion: nil)
            break
            
        //FAQ
        case 10:
            if !(centerNavigationController.topViewController is ERSettingsFAQViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let faqViewController = ERSettingsFAQViewController()
                faqViewController.delegate = self
                centerNavigationController.pushViewController(faqViewController, animated: false)
            }
            break
            
        //CONTACT&IMPRINT
        case 11:
            if !(centerNavigationController.topViewController is ERSettingsImpressumViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let impressumViewController = ERSettingsImpressumViewController()
                impressumViewController.delegate = self
                centerNavigationController.pushViewController(impressumViewController, animated: false)
            }
            break
            
        //LEGALNOTICE
        case 12:
            if !(centerNavigationController.topViewController is ERSettingsLegalViewController) {
                centerNavigationController.popToRootViewController(animated: false)
                let legalViewController = ERSettingsLegalViewController()
                legalViewController.delegate = self
                centerNavigationController.pushViewController(legalViewController, animated: false)
            }
            break
        default:
            break
        }
        
        
        
        
    }
    
}
