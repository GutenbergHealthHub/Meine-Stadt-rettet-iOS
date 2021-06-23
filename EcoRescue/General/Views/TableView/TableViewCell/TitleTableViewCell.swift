
//
//  HeaderTableViewCell.swift
//  EcoRescue
//
//  Created by Christoph Erl on 28.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class TitleTableViewCell: TableViewCell {

    static let id = "TitleTableViewCell"
    
    private let headerLabel = UILabel.title1Label

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        headerLabel.textAlignment = .center
        headerLabel.numberOfLines = 0
        contentView.addSubview(headerLabel)
        headerLabel.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var title: String? {
        set { headerLabel.text = newValue   }
        get { return headerLabel.text       }
    }

}
