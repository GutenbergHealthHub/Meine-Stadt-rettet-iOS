//
//  ERCoursesTableViewCell.swift
//  EcoRescue
//
//  Created by Birtan on 28.06.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

let kERCoursesTableViewCell = "ERCoursesTableViewCell"

class ERCoursesTableViewCell: UITableViewCell {
    
    var course: ERCourse? { didSet { setCourse(oldValue: oldValue) } }
    
    private let kImageViewHeight: CGFloat = 100
    
    private let imgView        = UIView.initImageView()
    
    private let titleLabel     = UILabel.type2Label()
    private let organizerLabel = UILabel.type2LightLabel()
    //private let dateLabel      = UILabel.type2Label()
    private let addressLabel   = UILabel.type2LightLabel()
    
    private let dateFormatter  = DateFormatter()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        imgView.clipsToBounds = true
        
        titleLabel.numberOfLines    = 1
        titleLabel.lineBreakMode    = .byTruncatingTail
        
        organizerLabel.numberOfLines  = 1
        organizerLabel.lineBreakMode  = .byTruncatingTail
        organizerLabel.adjustsFontSizeToFitWidth = false
        
        //dateLabel.numberOfLines  = 1
        //dateLabel.lineBreakMode  = .byTruncatingTail
        
        addressLabel.numberOfLines  = 1
        addressLabel.lineBreakMode  = .byTruncatingTail
        
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(organizerLabel)
        //addSubview(dateLabel)
        addSubview(addressLabel)
        
        imgView.left(constant: 5).height(constant: kImageViewHeight).widthEqualsHeight().topbottom().apply()
        
        titleLabel.right(of: imgView, constant: UIViewPadding.medium).top(constant: UIViewPadding.medium).right(constant: UIViewPadding.small).apply()
        organizerLabel.bottom(of: titleLabel, constant: UIViewPadding.medium).left(to: titleLabel, constant: 0).right(constant: UIViewPadding.small).top(of: addressLabel, constant: UIViewPadding.tiny).apply()
        addressLabel.bottom(of: organizerLabel, constant: UIViewPadding.tiny).left(to: titleLabel, constant: 0).right(constant: UIViewPadding.small).bottom(constant: UIViewPadding.small, relatedBy: .lessThanOrEqual).apply()
        //dateLabel.bottom(of: addressLabel, constant: UIViewPadding.tiny).left(to: titleLabel, constant: 0).right(constant: UIViewPadding.small).apply()
        
        //dateFormatter.dateFormat    = DateFormatter.dateFormat(fromTemplate: "dd/MM/yy", options: 0, locale: NSLocale.current)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCourse(oldValue: ERCourse?) {
        if course == oldValue { return }
        
        if let course = course {
            titleLabel.text     = course.name
            organizerLabel.text = "-\(String.COMPANY) "  + (course.organizer ?? " -")
            //dateLabel.text      = "-\(String.DATE) "     + dateFormatter.string(from: course.from!)
            addressLabel.text   = "-\(String.LOCATION): " + (course.city ?? " -")
            
            course.getImage(completion: { (image) in
                self.imgView.image = image
            })
            
        } else {
            titleLabel.text     = nil
            organizerLabel.text = nil
            imgView.image       = nil
            //dateLabel.text      = nil
            addressLabel.text   = nil
        }
    }
    
}
