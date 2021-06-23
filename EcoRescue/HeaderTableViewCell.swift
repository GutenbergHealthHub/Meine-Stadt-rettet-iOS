
//
//  HeaderTableViewCell.swift
//  EcoRescue
//
//  Created by Christoph Erl on 28.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class TitleTableViewCell: TableViewCell {
    
    private let headerLabel = UILabel.title1BoldLabel

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(headerLabel)
        headerLabel.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
    }
    
    var

}
