//
//  ERNewsTableViewCell.swift
//  EcoRescue
//
//  Created by Birtan on 14.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

let kERNewsTableViewCell = "ERNewsTableViewCell"

class ERNewsTableViewCell: UITableViewCell {
    
    var news: ERNews? { didSet { setNews(oldValue: oldValue) } }
    
    private let kImageViewHeight: CGFloat = 100
    
    private let imgView         = UIView.initImageView()
    
    private let titleLabel      = UILabel.bodyLabel
    private let contentLabel    = UILabel.calloutLabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.clipsToBounds = true
        
        titleLabel.numberOfLines    = 1
        titleLabel.lineBreakMode    = .byTruncatingTail
        
        contentLabel.numberOfLines  = 3
        contentLabel.lineBreakMode  = .byTruncatingTail
        
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(contentLabel)
        
        imgView.left(constant: 0).height(constant: kImageViewHeight).widthEqualsHeight().topbottom().apply()
        
        titleLabel.right(of: imgView, constant: UIViewPadding.medium).top(constant: UIViewPadding.medium).right(constant: UIViewPadding.small).apply()
        contentLabel.left(to: titleLabel, constant: 0).bottom(of: titleLabel, constant: UIViewPadding.small).bottom(constant: UIViewPadding.small).right(constant: UIViewPadding.small).apply()
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
