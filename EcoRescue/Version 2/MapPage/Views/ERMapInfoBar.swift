//
//  ERMapRouteBar.swift
//  EcoRescue
//
//  Created by Christoph Erl on 10.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import MapKit

@objc protocol ERMapInfoBarDelegate: NSObjectProtocol {
    @objc optional func mapInfoBarDidTapInfo(ERMapInfoBar: ERMapInfoBar, annotation: Annotation)
    @objc optional func mapInfoBarDidTapNavigate(ERMapInfoBar: ERMapInfoBar, annotation: Annotation)
}

class ERMapInfoBar: UCView {
    
    var delegate: ERMapInfoBarDelegate?
    
    // Model
    var annotation: Annotation?   { didSet { p_setAnnotation(oldValue: oldValue) } }
    
    // Attributes
    var infoButtonHidden = false { didSet { p_setInfoButtonHidden(oldValue: oldValue) } }
    
    // Views
    private let toolbar: ERToolbar
    
    private let buttonInfo      = UIView.initButton()
    private let buttonNavigate  = UIView.initButton()
    
    private let titleLabel      = UILabel.bodyLabel
    private let subtitleLabel   = UILabel.footnoteLabel
    private let iconView        = UIView.view()
    
    // Constraints
    private var constraintWidthInfoButton: NSLayoutConstraint!
    
    init(position: UIBarPosition) {
        toolbar = ERToolbar(position: position)
        super.init()
        
        let containerView = UIView.view()
        
        // Labels
        subtitleLabel.textColor = UIColor.separator
        
        // Buttons
        buttonInfo.setImage(UIImage.iconInfoSelected(), for: .normal)
        buttonInfo.addTarget(self, action: #selector(didTapInfo(sender:)), for: .touchUpInside)
        
        buttonNavigate.setImage(UIImage.iconRoadSignSelected(), for: .normal)
        buttonNavigate.addTarget(self, action: #selector(didTapNavigate(sender:)), for: .touchUpInside)
        
        addSubview(toolbar)
        addSubview(buttonInfo)
        addSubview(buttonNavigate)
        addSubview(containerView)
        addSubview(iconView)
        
        toolbar.match().apply()
        buttonNavigate.right().height(multiplier: 1).widthEqualsHeight().centerY().apply()
        buttonInfo.left(of: buttonNavigate, constant: 0).height(multiplier: 1).width(constant: 0, closure: { (con) in self.constraintWidthInfoButton = con }).centerY().apply()
        iconView.left(constant: UIViewPadding.big).height(constant: 32).widthEqualsHeight().centerY().apply()
        containerView.right(of: iconView, constant: UIViewPadding.small).topbottom(constant: UIViewPadding.small).left(of: buttonInfo, constant: 0).apply()
    
        // Container View
        containerView.addSubview(subtitleLabel)
        containerView.addSubview(titleLabel)
        
        subtitleLabel.leftright().bottom().apply()
        titleLabel.leftright().top().top(of: subtitleLabel, constant: 0).apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 44)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Layout
        p_setInfoButtonHidden()
    }
        
    // MARK: - Computed Variables
    
    var title: String? {
        set { titleLabel.text = newValue    }
        get { return titleLabel.text        }
    }
    
    var subtitle: String? {
        set { subtitleLabel.text = newValue    }
        get { return subtitleLabel.text        }
    }
    
    var titleColor: UIColor! {
        set { titleLabel.textColor = newValue    }
        get { return titleLabel.textColor        }
    }
    
    // MARK: - Actions
    
    func didTapInfo(sender: AnyObject) {
        if let annotation = annotation {
            delegate?.mapInfoBarDidTapInfo?(ERMapInfoBar: self, annotation: annotation)
        }
    }
    
    func didTapNavigate(sender: AnyObject) {
        if let annotation = annotation {
            delegate?.mapInfoBarDidTapNavigate?(ERMapInfoBar: self, annotation: annotation)
        }
    }
    
    // MARK: - Private Methods
    
    private func p_setAnnotation(oldValue: Annotation?) {
        iconView.removeSubviews()
        
        if let annotation = annotation  {
            let view = AnnotationIconView.createFrom(annotation: annotation)            
            iconView.addSubview(view)
            view.height(multiplier: 1).widthEqualsHeight().centerXY().apply()
        }
    }
    
    private func p_setInfoButtonHidden(oldValue: Bool) {
        if infoButtonHidden == oldValue { return }
        p_setInfoButtonHidden()
    }
    
    private func p_setInfoButtonHidden() {
        buttonInfo.isHidden = infoButtonHidden
    
        constraintWidthInfoButton.constant = infoButtonHidden ? 0 : frame.height
        layoutIfNeeded()
    }
    


}
