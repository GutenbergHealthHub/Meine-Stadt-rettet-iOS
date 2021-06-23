//
//  ERPinViewV2.swift
//  EcoRescue
//
//  Created by Birtan on 19.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import AudioToolbox

protocol ERPinViewV2Delegate: NSObjectProtocol {
    func didEnterCode(code: String)
}

class ERPinViewV2: UIView {
    
    weak var delegate: ERPinViewV2Delegate?
    
    private let textfield = UITextField.textField()
    
    private var itemViews = [ERPinItemsViewV2]()
    
    //private var code: String? { didSet { setCode(oldValue: oldValue) } }

    init(type: ERPinItemsViewV2Type) {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        // textfield
        addSubview(textfield)
        textfield.match().apply()
        
        textfield.alpha = 0
        textfield.keyboardType = .numberPad
        textfield.addTarget(self, action: #selector(didChangeTextField(sender:)), for: .editingChanged)
        
        setItemViews(type: type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTextfield(code: String) {
        textfield.text = code
        updateItemViews(filled: 6)
    }
    
    func setItemViews(type: ERPinItemsViewV2Type) {
        
        var containerViews = [UIView]()
        for _ in 0..<6 {
            let containerView = UIView.view()
            addSubview(containerView)
            
            let item = ERPinItemsViewV2()
            containerView.addSubview(item)
            item.width(constant: 30).heightEqualsWidth().centerXY().apply()
            item.type = type
            
            itemViews.append(item)
            containerViews.append(containerView)
        }
        
        UIView.alignHorizontally(views: containerViews)
    }
    
    func focus() {
        textfield.performSelector(onMainThread: #selector(becomeFirstResponder), with: nil, waitUntilDone: false)
    }
    
    func unfocus() {
        textfield.performSelector(onMainThread: #selector(resignFirstResponder), with: nil, waitUntilDone: false)
    }
    
    func reset(vibrating: Bool) {
        textfield.text = ""
        updateItemViews(filled: 0)
        
        if vibrating {
            shake()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
    }
    
    func didChangeTextField(sender: UITextField) {
        if let text = sender.text {
         if text.count == 7 {
            sender.text = String(text.dropLast())
         } else if text.count == 6 {
            updateItemViews(filled: text.count)
            delegate?.didEnterCode(code: text)
         } else {
            updateItemViews(filled: text.count)
            }
        }
    }
    
    private func updateItemViews(filled: Int) {
        for i in 0..<filled {
            itemViews[i].filled = true
        }
        for j in filled..<6 {
            itemViews[j].filled = false
        }
    }
    
}

public enum ERPinItemsViewV2Type {
    case emergency, access
}

private class ERPinItemsViewV2: UIView {
    
    fileprivate var type = ERPinItemsViewV2Type.access
    var filled: Bool? { didSet { setFilled(oldValue: oldValue) } }
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.clear

        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.6
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let item = UIBezierPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerRadius: 3)
        item.lineWidth = 2
        
        switch type {
        case .access:
            UIColor.colorPrimaryBlue.setStroke()
            UIColor.colorPrimaryBlue.setFill()
            break
        case .emergency:
            UIColor.white.setStroke()
            UIColor.white.setFill()
            break
        }
        
        item.stroke()
        if let filled = filled, filled { item.fill() }
    }
    
    private func setFilled(oldValue: Bool?) {
        setNeedsDisplay()
    }
}
