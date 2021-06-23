//
//  InfoUserImageTableViewCell.swift
//  EcoRescueASB
//
//  Created by Birtan on 18.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class InfoUserImageTableViewCell: TableViewCell {

    private let userImageView = ERUserIconView()
    
    private let nameLabel      = UILabel.type2Label()
    private let nameValueLabel = UILabel.type2LightLabel()
    
    private let emailLabel      = UILabel.type2Label()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userImageView)
        userImageView.left(constant: UIViewPadding.small).topbottom(constant: UIViewPadding.small).height(constant: 80).widthEqualsHeight().apply()

        contentView.addSubview(nameLabel)
        nameLabel.right(of: userImageView, constant: UIViewPadding.tiny).top(to: userImageView, constant: UIViewPadding.tiny).apply()
        nameLabel.text = String.EMERGENCY_NAME
        
        contentView.addSubview(nameValueLabel)
        nameValueLabel.right(of: nameLabel, constant: UIViewPadding.medium).top(to: nameLabel, constant: 0).apply()
        
        contentView.addSubview(emailLabel)
        emailLabel.right(of: userImageView, constant: UIViewPadding.tiny).bottom(of: nameLabel, constant: UIViewPadding.small).apply()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var name: String? {
        set { nameValueLabel.text = newValue   }
        get { return nameValueLabel.text       }
    }
    
    public var email: String? {
        set { emailLabel.text = newValue   }
        get { return emailLabel.text       }
    }

}
