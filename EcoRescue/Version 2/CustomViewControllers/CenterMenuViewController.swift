//
//  CenterMenuViewController.swift
//  EcoRescue
//
//  Created by Birtan on 12.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

@objc protocol CenterMenuViewControllerDelegate {
    @objc optional func toggleLeftPanel()
    @objc optional func changeViewController(to: Int)
}

class CenterMenuViewController: UIViewController {
    
    var delegate: CenterMenuViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuBarButtonItem = UIBarButtonItem.barButtonImageItem(image: UIImage.iconMenuToolbar(), target: self, action: #selector(didTapMenu(sender:)))
        
        self.navigationItem.leftBarButtonItem = menuBarButtonItem
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorPrimaryBlue
        self.navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
        
        //self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont.quicksandBold(textStyle: .headline)]
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func appWillEnterForeground() {
    }
    
    func didTapMenu(sender: Any) {
        delegate?.toggleLeftPanel?()
    }

}
