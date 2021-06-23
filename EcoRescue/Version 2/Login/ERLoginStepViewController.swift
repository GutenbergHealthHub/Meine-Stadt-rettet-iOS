//
//  ERLoginStepViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 23.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERLoginStepViewController: UIViewController, UITextFieldDelegate {
    
    weak var delegate: StepsViewControllerDelegate?
    
    let topView = UIView.view()
    let progressViewLeft    = UIView.view()
    let progressViewRight   = UIView.view()
    //let scrollView        = UIScrollView.scrollView()
    let containerView       = UIView.view()
    let bottomContainerView = UIView.view()
    
    var activeTextFieldFrame: CGRect = CGRect.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(topView)
        self.view.addSubview(progressViewLeft)
        self.view.addSubview(progressViewRight)
        self.view.addSubview(containerView)
        self.view.addSubview(bottomContainerView)
        
        topView.top().leftright().height(multiplier: 0.3).apply()
        topView.backgroundColor = UIColor.colorPrimaryBlue
        
        progressViewLeft.bottom(of: topView, constant: 0).left().left(of: progressViewRight, constant: 0).width(multiplier: 0.5).height(constant: 5).apply()
        progressViewRight.bottom(of: topView, constant: 0).right(of: progressViewLeft, constant: 0).width(multiplier: 0.5).height(constant: 5).right().apply()
        
        containerView.bottom(of: progressViewLeft, constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).top(of: bottomContainerView, constant: 0).apply()
        
        bottomContainerView.bottom().leftright().height(multiplier: 0.2).apply()
        
        //scrollView.addSubview(containerView)
        //containerView.match().width(constant: view.frame.width).apply()
        
        progressViewRight.backgroundColor = UIColor.colorIntroProgressBarBackgroundV2
        progressViewLeft.backgroundColor  = UIColor.colorIntroProgressBarBackgroundV2
        
        let imageView = UIImageView.imageView()
        topView.addSubview(imageView)
        
        imageView.centerX().top(constant: 25).height(multiplier: 0.5).widthEqualsHeight().apply()
        imageView.image = UIImage.iconLogoV2()
        imageView.contentMode = .scaleAspectFit
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Keyboard Observes
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Keyboard Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let yIndex = containerView.frame.minY + activeTextFieldFrame.maxY + self.view.frame.origin.y
            if yIndex > keyboardSize.minY {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= yIndex - keyboardSize.minY + self.activeTextFieldFrame.height
                })
            }
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if (((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y += -self.view.frame.origin.y
                })
            }
        }
    }
    
    //TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Alerts
    
    func openAlertController(_ title: String?, message: String?, completion: (() -> ())? = nil) {
        let cancelAction = UIAlertAction(title: String.BACK, style: .default) { (action) in completion?() }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

}
