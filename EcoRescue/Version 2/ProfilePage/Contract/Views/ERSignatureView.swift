//
//  ERSignatureView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 10.11.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

// MARK: - Optional Protocol Methods for YPDrawSignatureViewDelegate
/// ## YPDrawSignatureViewDelegate Protocol
/// YPDrawSignatureViewDelegate:
/// - startedDrawing()
/// - finishedDrawing() 
protocol ERSignatureViewDelegate: NSObjectProtocol {
    func signatureViewDidStartDrawing(signatureView: ERSignatureView)
    func signatureViewDidStopDrawing(signatureView: ERSignatureView)
    func signatureViewDidDeleteDrawing(signatureView: ERSignatureView)
}

class ERSignatureView: UIView, ERSignatureAreaViewDelegate {
    
    private static var strokeWidth: CGFloat = 2.0

    weak var delegate: ERSignatureViewDelegate?
    
    var signatureImage: UIImage? { return areaView.signatureImage }
    var containsSignature: Bool { return areaView.containsSignature }
    
    // MARK: - Private properties
    private let areaView = ERSignatureAreaView()
    private let button   = ERButton()
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        button.tintColor = UIColor.theme
        button.setTitle(String.DELETE, for: .normal)
        
        addSubview(areaView)
        addSubview(button)
        
        button.bottom().leftright().height(constant: 44).apply()
        areaView.top().leftright().top(of: button, constant: 0).apply()
        
        button.text = String.CLEAR_SIGNATURE
        button.backgroundColor = UIColor.gray
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        areaView.delegate = self
        
        p_updateButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapButton(sender: AnyObject) {
        areaView.clear()
        p_updateButton()
        
        delegate?.signatureViewDidDeleteDrawing(signatureView: self)
    }
    
    // MARK: - ERSignatureAreaViewDelegate
    
    func signatureAreaViewDidStopDrawing(signatureAreaView: ERSignatureAreaView) {
        p_updateButton()
        
        delegate?.signatureViewDidStopDrawing(signatureView: self)
    }
    
    func signatureAreaViewDidStartDrawing(signatureAreaView: ERSignatureAreaView) {
        delegate?.signatureViewDidStartDrawing(signatureView: self)
    }
    
    // MARK: - Private Methods - Helper
    
    private func p_updateButton() {
        button.isEnabled = areaView.containsSignature
    }
    
}

