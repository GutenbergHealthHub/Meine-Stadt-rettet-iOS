//
//  EREventsHeaderView.swift
//  EcoRescue
//
//  Created by Birtan on 16.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

let kEREventsHeaderTableViewCell = "EREventsHeaderTableViewCell"

class EREventsHeaderTableViewCell: UITableViewCell {

    var event: EREvent? { didSet { setEvent (oldValue: oldValue) } }
    
    private let kImageViewHeight: CGFloat = 160
    
    private let imgView         = UIView.initImageView()
    
    private let titleLabel      = UILabel.bodyLabel
    private let organizerLabel  = UILabel.calloutLabel
    private let dateLabel       = UILabel.calloutLabel
    private let addressLabel    = UILabel.calloutLabel
    
    private let dateFormatter       = DateFormatter()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.white
        layer.shadowColor = UIColor.separator.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4.5)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.99
        layer.masksToBounds = false
        
        imgView.contentMode = UIViewContentMode.scaleAspectFill
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
        
        imgView.leftright().top().height(constant: kImageViewHeight).apply()
        titleLabel.bottom(of: imgView, constant: UIViewPadding.small).left(constant: UIViewPadding.medium).right(constant: UIViewPadding.small).apply()
        organizerLabel.bottom(of: titleLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.medium).right(constant: UIViewPadding.small).apply()
        dateLabel.bottom(of: organizerLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.medium).bottom(constant: UIViewPadding.small).apply()
        addressLabel.top(to: dateLabel, constant: 0).right(of: dateLabel, constant: UIViewPadding.big).bottom(constant: UIViewPadding.small).apply()
        
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
