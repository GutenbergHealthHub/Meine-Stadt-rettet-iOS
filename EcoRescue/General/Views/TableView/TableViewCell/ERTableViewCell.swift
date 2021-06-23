//
//  ERTableViewCell.swift
//  EcoRescue
//
//  Created by Christoph Erl on 05.05.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit

class ERTableViewCell: UITableViewCell {
    
    static var paddingTopBottom: CGFloat = kUIPaddingSmall
    static var paddingLeftRight: CGFloat = kUIViewDefaultPaddingLarge
        
    let containerView = UIView.view()
    


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(containerView)
        containerView.topbottom(constant: ERTableViewCell.paddingTopBottom).leftright(constant: ERTableViewCell.paddingLeftRight).apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

