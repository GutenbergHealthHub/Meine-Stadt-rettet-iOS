//
//  GeneralPageViewController.swift
//  EcoRescue
//
//  Created by Birtan on 30.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class StepsPageViewController: UIPageViewController, StepsViewControllerDelegate {
    
    var pages = [UIViewController]() { didSet { setPages(oldValue: oldValue) } }
    var finalPage: UIViewController?
    var index: Int = 0 { didSet { setIndex(oldValue) } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //dataSource = self
        orderStepControllers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    
    fileprivate func setPages(oldValue: [UIViewController]) {
        if pages == oldValue { return }
        orderStepControllers()
    }
    
    fileprivate func setIndex(_ oldValue: Int) {
        if oldValue == index { return }
        
        if index >= 0 && index < pages.count {
            
            let page = pages[index]
            let direction: UIPageViewControllerNavigationDirection = oldValue < index ? .forward : .reverse
            
            setViewControllers([page], direction: direction, animated: false, completion: nil)
        }
    }
    
    fileprivate func orderStepControllers() {
        
        if let controller = pages.first {
            setViewControllers([controller], direction: .forward, animated: false, completion: nil)
        } else {
            setViewControllers(nil, direction: .forward, animated: false, completion: nil)
        }

    }
    
    func contains(_ vc: UIViewController) -> Bool {
        return pages.contains(vc)
    }
    
    func insert(_ vc: UIViewController, after: UIViewController) {
        if let index = pages.index(of: after) {
            pages.insert(vc, at: index + 1)
        }
    }
    
    func remove(_ vc: UIViewController) {
        if let index = pages.index(of: vc) {
            pages.remove(at: index)
        }
    }
    
    //MARK: StepsViewControllerDelegate
    
    func goNextStep() {
        if index < pages.count - 1 {
            self.index = index + 1
        } else {
            finalizeSteps()
        }
    }
    
    func goPreviousStep() {
        if index > 0 {
            self.index = index - 1
        }
    }
    
    func finalizeSteps() {
    }
    
    func finalizeSteps(with: EREmergencyState?, cancel: Bool, expired: Bool) {
    }


}
/*
extension StepsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = pages.index(of: viewController) else {
            return nil
        }
        
        if vcIndex == 0 {
            return nil
        } else {
            return self.pages[vcIndex - 1]
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = pages.index(of: viewController) else {
            return nil
        }
        
        if vcIndex == pages.count - 1 {
            return nil
        } else {
            return self.pages[vcIndex + 1]
        }
        
    }
    
}*/
