//
//  TitleDetailTableViewCell.swift
//  EcoRescueASB
//
//  Created by Birtan on 19.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class TitleDetailTableViewCell: TableViewCell {

    static let id = "TitleDetailTableViewCell"
    
    private let titleLabel = UILabel.type2Label()
    private let subtitleLabel = UILabel.type2LightLabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        
        titleLabel.left(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).width(multiplier: 0.4).apply()
        subtitleLabel.right(constant: UIViewPadding.small).topbottom(constant: UIViewPadding.big).right(of: titleLabel, constant: UIViewPadding.small).apply()

        subtitleLabel.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var title: String? {
        set { titleLabel.text = newValue   }
        get { return titleLabel.text       }
    }
    
    override var subtitle: String? {
        set { subtitleLabel.text = newValue   }
        get { return subtitleLabel.text       }
    }

}
