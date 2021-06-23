//
//  ERNewsHeaderView.swift
//  EcoRescue
//
//  Created by Birtan on 14.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

let kERNewsHeaderTableViewCell = "ERNewsHeaderTableViewCell"

class ERNewsHeaderTableViewCell: UITableViewCell {
    
    var news: ERNews? { didSet { setNews(oldValue: oldValue) } }
    
    private let kImageViewHeight: CGFloat = 160
    
    private let imgView         = UIView.initImageView()
    
    private let titleLabel      = UILabel.bodyLabel
    private let contentLabel    = UILabel.calloutLabel

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
        
        contentLabel.numberOfLines  = 2
        contentLabel.lineBreakMode  = .byTruncatingTail
        
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        imgView.leftright().top().height(constant: kImageViewHeight).apply()
        titleLabel.bottom(of: imgView, constant: UIViewPadding.medium).left(constant: UIViewPadding.medium).right(constant: UIViewPadding.small).apply()
        contentLabel.bottom(of: titleLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.medium).bottom(constant: UIViewPadding.small).right(constant: UIViewPadding.small).apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setNews(oldValue: ERNews?) {
        if news == oldValue { return }
        
        if let news = news {
            titleLabel.text   = news.title
            contentLabel.text = news.abstract
            
            news.getImage(completion: { (image) in
                self.imgView.image = image
            })
            
        } else {
            titleLabel.text     = nil
            contentLabel.text   = nil
            imgView.image       = nil
        }
    }
    
}
