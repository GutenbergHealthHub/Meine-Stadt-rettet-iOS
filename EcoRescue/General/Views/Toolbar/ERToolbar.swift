//
//  UCToolbar.swift
//  CEUserControls
//
//  Created by Christoph Erl on 08.03.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

private let kERToolbarHeightMin:            CGFloat = kUIViewDefaultSizeBarMedium
private let kERToolbarPaddingContentMin:    CGFloat = kUIViewDefaultPaddingMedium

class ERToolbar: View, UIToolbarDelegate {
    
    var contentView: UIView? { didSet { p_setContentView(oldValue) } }
    
    fileprivate let toolbar: UIToolbar
    fileprivate let position: UIBarPosition
    
    init(position: UIBarPosition) {
        self.position = position
        
        self.toolbar = UIToolbar()
        self.toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        super.init()
        
        toolbar.delegate = self
        addSubview(toolbar)
        toolbar.applyConstraintMatchParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize : CGSize {
        contentView?.layoutIfNeeded()
        
        let heightContentView = (contentView?.intrinsicContentSize.height ?? 0) + 2 * kUIViewDefaultPaddingMedium
        
        let height = max(kERToolbarHeightMin, heightContentView)
        return CGSize(width: 0.0, height: height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    // MARK: - UIToolbarDelegate
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return position
    }
    
    // MARK: - Private Methods
    
    fileprivate func p_setContentView(_ oldView: UIView?) {
        if oldView == contentView { return }
        
        oldView?.removeFromSuperview()
        
        if let contentView = contentView {
            contentView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(contentView)
            contentView.applyConstraintMatchParent()
        
            bringSubview(toFront: contentView)
        }
        
        sizeToFit()
    }
    
}
