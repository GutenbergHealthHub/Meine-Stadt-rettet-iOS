//
//  CLEventLocationTableViewCell.swift
//  Clubus
//
//  Created by Christoph Erl on 23.04.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class EREventLocationTableViewCell: ERTableViewCell {

    var address:   UCAddress? { didSet { p_setAddress(oldValue: oldValue)  } }
    
    private let iconView    = UIImageView.imageView()
    private let label       = UILabel.bodyLabel
    private let sublabel    = UILabel.calloutLabel
    
    private let dateFormatter       = DateFormatter()
    private let subdateFormatter    = DateFormatter()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        dateFormatter.dateFormat    = DateFormatter.dateFormat(fromTemplate: "EEEEdMMMHmm", options: 0, locale: NSLocale.current)
        subdateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "dMMM' at 'Hmm", options: 0, locale: NSLocale.current)
        
        label.numberOfLines = 0
        sublabel.numberOfLines = 0
        
        iconView.contentMode = UIViewContentMode.scaleAspectFit
        iconView.image = UIImage.iconLocationPin().image(color: UIColor.colorTextSecondary)
        
        let containerView = UIView.view()
        contentView.addSubview(containerView)
        contentView.addSubview(iconView)
        
        iconView.left(constant: UIViewPadding.big).height(constant: 24).widthEqualsHeight().centerY().apply()
        containerView.right(of: iconView, constant: UIViewPadding.medium).right(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
        
        containerView.addSubview(label)
        containerView.addSubview(sublabel)
        
        label.top().leftright().apply()
        sublabel.bottom(of: label, constant: 0).leftright().bottom().apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    override var tintColor: UIColor! {
        didSet {
            
        }
    }
    
    private func p_setAddress(oldValue: UCAddress?) {
        if address == oldValue { return }
        p_updateText()
    }
    
    private func p_updateText() {
        if let address = address {
            label.text      = address.object
            sublabel.text   = address.addressLineString
        } else {
            label.text      = nil
            sublabel.text   = nil
        }
    }

}
