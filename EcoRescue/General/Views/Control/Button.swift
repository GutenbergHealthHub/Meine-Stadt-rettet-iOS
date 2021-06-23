//
//  Button.swift
//  EcoRescue
//
//  Created by Christoph Erl on 01.04.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class Button: Control {
    
    var shape = Shape.cornered { didSet { p_setShape(oldValue: oldValue) } }
    
    var icon:   UIImage?  { didSet { p_setImage(oldValue: oldValue) } }
    var title:  String?   { didSet { p_setText(oldValue: oldValue) } }
    
    private var imageView: ImageView?
    private var textLabel: UILabel?

    var isFilled: Bool = false { didSet { p_setFilled(oldValue: oldValue) } }
    
    override init() {
        super.init()
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        textLabel?.layoutIfNeeded()
        imageView?.layoutIfNeeded()
        
        let width   = (textLabel?.intrinsicContentSize.width ?? 0) + (imageView?.intrinsicContentSize.width ?? 0)
        let height  = max(textLabel?.intrinsicContentSize.height ?? 0, imageView?.intrinsicContentSize.height ?? 0)
        
        let doesBothExist   = textLabel != nil && imageView != nil
        let paddingWidth    = 2*UIViewPadding.big + (doesBothExist ? UIViewPadding.medium : 0)
        let paddingHeight   = 2*UIViewPadding.medium
        
        print(height + paddingHeight)
        print(width + paddingWidth)
        /*
        switch shape {
            
        case .cornered:
            return CGSize(width: width + paddingWidth, height: height + paddingHeight)
            
        case .rounded:
            return CGSize(width: width + paddingWidth, height: height + paddingHeight)
            
        case .circle:
            return CGSize(width: width, height: height + paddingHeight)
        }
        */
        return CGSize(width: -1, height: -1)
    }
    
    override var tintColor: UIColor! {
        didSet {
            p_updateAppearance()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        p_setShape()
    }
    
    // MARK: - Private Methods
    
    private func p_setFilled(oldValue: Bool) {
        if isFilled == oldValue { return }
        p_setFilled()
    }
    
    private func p_setFilled() {
        setNeedsDisplay()
        p_updateAppearance()
    }
    
    private func p_setShape(oldValue: Shape) {
        if shape == oldValue { return }
        p_setShape()
    }
    
    private func p_setShape() {
        switch shape {
            
        case .cornered:
            layer.cornerRadius = 0
            break
            
        case .rounded:
            layer.cornerRadius = 4
            break
            
        case .circle:
            layer.cornerRadius = frame.height / 2
            break
        }
        
        invalidateIntrinsicContentSize()
    }
    
    private func p_setText(oldValue: String?) {
        if title == oldValue { return }
        
        if let textLabel = textLabel, oldValue != nil, title == nil {
            textLabel.removeFromSuperview()
            
            self.textLabel = nil
            self.p_relayout()
            
        } else if oldValue == nil && title != nil {
            let textLabel = createTextLabelIfNecessary()
            addSubview(textLabel)
            
            self.textLabel = textLabel
            self.p_relayout()
        }
        
        p_setText()
    }
    
    private func p_setText() {
        textLabel?.text = title
    }
    
    private func p_setImage(oldValue: UIImage?) {
        if icon == oldValue { return }
        
        if let imageView = imageView, oldValue != nil, icon == nil {
            imageView.removeFromSuperview()
    
            self.imageView = nil
            self.p_relayout()
            
        } else if oldValue == nil && icon != nil {
            let imageView = createImageViewIfNecessary()
            addSubview(imageView)

            self.imageView = imageView
            self.p_relayout()
        }
        
        p_setImage()
    }
    
    private func p_setImage() {
        imageView?.image = icon?.image(color: UIColor.positive)
    }
    
    private func p_updateAppearance() {
        layer.borderColor       = tintColor.cgColor
        layer.backgroundColor   = isFilled ? tintColor.cgColor : UIColor.clear.cgColor
        
        textLabel?.textColor    = isFilled ? UIColor.white : tintColor
        imageView?.image        = icon?.image(color: isFilled ? UIColor.white : tintColor)
    }
    
    private func p_relayout() {
        textLabel?.removeConstraints()
        imageView?.removeConstraints()
        
        if let textLabel = textLabel, let imageView = imageView {
            textLabel.right(of: imageView, constant: UIViewPadding.medium).right(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.medium).apply()
            imageView.left(constant: UIViewPadding.big).centerY().height(constant: 28).widthEqualsHeight().apply()
            
        } else if let textLabel = textLabel {
            textLabel.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.medium).apply()
            
        } else if let imageView = imageView {
            imageView.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).height(constant: 28).widthEqualsHeight().apply()
        }
    }
    
    // MARK: - View Factory
    
    private func createImageViewIfNecessary() -> ImageView {
        if imageView == nil {
            let view = ImageView()
            return view
        }
        return imageView!
    }
    
    private func createTextLabelIfNecessary() -> UILabel {
        if textLabel == nil {
            let view            = UILabel.bodyLabel
            view.textAlignment  = .center
            return view
        }
        return textLabel!
    }
    
    // MARK: - Override Control
    
    override func didChangeTouching(isTouching: Bool) {
        super.didChangeTouching(isTouching: isTouching)
        alpha = isTouching ? 0.3 : 1
    }
    
    // MARK: - Enum Shape
    
    enum Shape {
        case cornered, rounded, circle
    }

}
