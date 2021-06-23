//
//  ERProtocolCancelRemarksViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 18.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERProtocolCancelRemarksViewController: StepsViewController, UITextViewDelegate {

    private let containerView = UIView.view()
    
    let textView = UITextView.textView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.CANCELLED_REPORT_REMARKS_TITLE
        headerSubtitleLabel.text = "\(String.END_REMARKS_SUBTITLE) (max 1000)"
        
        view.addSubview(containerView)
        containerView.bottom(of: progressView, constant: 0).leftright().top(of: progressView2, constant: 0).apply()
        containerView.backgroundColor = UIColor.background
        
        // Container View - button
        let button = ERButton()
        containerView.addSubview(button)
        button.bottom(constant: UIViewPadding.large).leftright(constant: UIViewPadding.large).apply()
        button.text = String.SAVE_REPORT_AND_SEND
        button.addTarget(self, action: #selector(didTapSend(sender:)), for: .touchDown)
        
        containerView.addSubview(textView)
        textView.top(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).top(of: button, constant: UIViewPadding.large).apply()
        textView.delegate = self
        textView.layer.borderWidth = 0.8
        textView.layer.borderColor = UIColor.black.cgColor
        textView.font = UIFont.openSansRegular(textStyle: .body)
        textView.adjustsFontForContentSizeCategory = true
        addDoneToolbar()
    }
    
    func didTapSend(sender: Any) {
        delegate?.finalizeSteps()
    }
    
    func addDoneToolbar() {
        let doneButton = UIBarButtonItem(title: String.DONE, style: .done, target: self, action: #selector(doneButtonTapped(sender:)))
        doneButton.tintColor = UIColor.coloriOS
        
        let toolbar: UIToolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            doneButton
        ]
        toolbar.sizeToFit()
        
        textView.inputAccessoryView = toolbar
    }
    
    // Default actions:
    func doneButtonTapped(sender: Any) { textView.resignFirstResponder() }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count <= 1000
    }
    
    
}
