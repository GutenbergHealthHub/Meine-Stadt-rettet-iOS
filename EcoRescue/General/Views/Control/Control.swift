//
//  ControlView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 27.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class Control: UIControl {

    private var isTouching = false { didSet { p_setTouching(oldValue: oldValue) } }
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func didChangeTouching(isTouching: Bool) {
        
    }
    
    // MARK: - Touching
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isTouching = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isTouching = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isTouching = false
    }
    
    // MARK: - Private Methods
    
    private func p_setTouching(oldValue: Bool) {
        if oldValue == isTouching { return }
        p_setTouching()
    }
    
    private func p_setTouching() {
        didChangeTouching(isTouching: isTouching)
    }

}
