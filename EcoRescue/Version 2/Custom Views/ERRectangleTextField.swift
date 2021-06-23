//
//  ERRectangleTextField.swift
//  EcoRescue
//
//  Created by Birtan on 22.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERRectangleTextField: UITextField {

    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 2
        clipsToBounds = true
        
        height(constant: UITextFieldHeight.forScreenSize).apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    func addDoneToolbar(onDone: (target: Any, action: Selector)? = nil) {
        let onDone = onDone ?? (target: self, action: #selector(doneButtonTapped))
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: onDone.target, action: onDone.action)
        doneButton.tintColor = UIColor.coloriOS
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            doneButton
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    func addClearAndDoneToolbar() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = UIColor.coloriOS
        
        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonTapped))
        clearButton.tintColor = UIColor.coloriOS
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            clearButton,
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            doneButton
        ]
        toolbar.sizeToFit()
        
        self.inputAccessoryView = toolbar
    }
    
    // Default actions:
    func doneButtonTapped() { self.resignFirstResponder() }
    
    func clearButtonTapped() { self.text = "" }

}
