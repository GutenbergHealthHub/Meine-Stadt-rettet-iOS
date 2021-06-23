//
//  ERMapV2DefibrillatorsTableViewCell.swift
//  EcoRescue
//
//  Created by Birtan on 13.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

let kERMapV2DefibrillatorsTableViewCell = "ERMapV2DefibrillatorsTableViewCell"

class ERMapV2DefibrillatorsTableViewCell: UITableViewCell {
    
    var defibrillator: ERDefibrillator? { didSet { p_setDefibrillator(defibrillator: defibrillator) } }
    
    private let containerView = UIView.view()
    
    private let imgView = UIImageView.imageView()
    
    private let addressLabel = UILabel.type2Label()
    private let statusLabel  = UILabel.type2Label()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // containerView
        contentView.addSubview(containerView)
        containerView.match(constant: UIViewPadding.big).apply()
        
        //imgView
        containerView.addSubview(imgView)
        imgView.left().centerY().width(constant: 33).widthEqualsHeight().apply()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage.iconDefiGray()
        
        //statusLabel
        containerView.addSubview(statusLabel)
        statusLabel.right().centerY().apply()
        statusLabel.numberOfLines = 1
        
        //addressLabel
        containerView.addSubview(addressLabel)
        addressLabel.topbottom().right(of: imgView, constant: UIViewPadding.big).width(constant: 200).apply()
        addressLabel.numberOfLines = 2
        addressLabel.lineBreakMode = .byTruncatingTail
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func p_setDefibrillator(defibrillator: ERDefibrillator?) {
        if let defibrillator = defibrillator {
            addressLabel.text = defibrillator.address?.addressLineString
            statusLabel.text = defibrillator.stateValue?.0
            statusLabel.textColor = defibrillator.stateValue?.1
            imgView.image = imgView.image?.imageWithColor(defibrillator.stateValue?.1 ?? UIColor.gray)
        }
    }

}
