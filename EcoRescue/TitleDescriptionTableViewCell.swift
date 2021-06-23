//
//  TitleDescriptionTableViewCell.swift
//  EcoRescue
//
//  Created by Christoph Erl on 28.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class TitleTextTableViewCell: TableViewCell {

    static let id = "TitleTableViewCell"
    
    private let headerLabel         = UILabel.title2BoldLabel
    private let descriptionLabel    = UILabel.bodyLabel
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        headerLabel.textAlignment = .left
        headerLabel.numberOfLines = 1
        
        descriptionLabel.textAlignment = .left
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(headerLabel)
        contentView.addSubview(descriptionLabel)
        headerLabel.leftright(constant: UIViewPadding.big).top(constant: UIViewPadding.big).apply()
        descriptionLabel.leftright(constant: UIViewPadding.big).bottom(of: headerLabel, constant: UIViewPadding.medium).bottom(constant: UIViewPadding.big).apply()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var title: String? {
        set { headerLabel.text = newValue   }
        get { return headerLabel.text       }
    }


}
