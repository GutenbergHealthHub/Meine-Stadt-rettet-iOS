//
//  EREventsTableViewCell.swift
//  EcoRescue
//
//  Created by Birtan on 16.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

let kEREventsTableViewCell = "EREventsTableViewCell"

class EREventsTableViewCell: UITableViewCell {

    var event: EREvent? { didSet { setEvent (oldValue: oldValue) } }
    
    private let kImageViewHeight: CGFloat = 100
    
    private let imgView         = UIView.initImageView()
    
    private let titleLabel     = UILabel.type2Label()
    private let organizerLabel = UILabel.type2LightLabel()
    private let dateLabel      = UILabel.type2LightLabel()
    private let addressLabel   = UILabel.type2LightLabel()
    
    private let dateFormatter  = DateFormatter()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        imgView.clipsToBounds = true
        
        titleLabel.numberOfLines    = 1
        titleLabel.lineBreakMode    = .byTruncatingTail
        
        organizerLabel.numberOfLines = 1
        organizerLabel.lineBreakMode = .byTruncatingTail
        
        addressLabel.numberOfLines = 1
        addressLabel.lineBreakMode = .byTruncatingTail
        
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(organizerLabel)
        addSubview(dateLabel)
        addSubview(addressLabel)
        
        imgView.left(constant: 0).height(constant: kImageViewHeight).widthEqualsHeight().topbottom().apply()
        
        titleLabel.right(of: imgView, constant: UIViewPadding.medium).top(constant: UIViewPadding.medium).right(constant: UIViewPadding.small).apply()
        organizerLabel.left(to: titleLabel, constant: 0).bottom(of: titleLabel, constant: UIViewPadding.small).right(constant: UIViewPadding.small).apply()
        dateLabel.bottom(of: organizerLabel, constant: UIViewPadding.small).left(to: titleLabel, constant: 0).bottom(constant: UIViewPadding.small).apply()
        addressLabel.top(to: dateLabel, constant: 0).right(of: dateLabel, constant: UIViewPadding.small).right(constant: UIViewPadding.small).bottom(constant: UIViewPadding.small).apply()
        
        dateFormatter.dateFormat    = DateFormatter.dateFormat(fromTemplate: "EEEEdMMMHmm", options: 0, locale: NSLocale.current)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setEvent(oldValue: EREvent?) {
        if event == oldValue { return }
        
        if let event = event, let from = event.from {
            titleLabel.text     = event.title
            organizerLabel.text = event.organizer
            dateLabel.text      = dateFormatter.string(from: from)
            addressLabel.text   = event.object
            
            event.getImage(completion: { (image) in
                self.imgView.image = image
            })
            
        } else {
            titleLabel.text     = nil
            organizerLabel.text = nil
            imgView.image       = nil
            addressLabel.text   = nil
            dateLabel.text      = nil
        }
    }

}
