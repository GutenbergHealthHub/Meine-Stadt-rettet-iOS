//
//  SideMenuHeaderView.swift
//  EcoRescue
//
//  Created by Birtan on 11.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

private let kUserIconHeight: CGFloat = 100

class SideMenuHeaderView: UIView {
    
    private let nameLabel      = UILabel.type1MediumLabel()
    private let emailLabel     = UILabel.type1Label()
    private let statusLabel    = UILabel.type2LightLabel(.callout)
    private let statusValLabel = ERStatusLabel()
    
    private let userIcon       = ERUserIconView()
    
    var canAddPicture: Bool = false { didSet { setCanAddPicture(oldValue: oldValue) } }
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor.colorPrimaryBlue
        
        addSubview(userIcon)
        addSubview(nameLabel)
        addSubview(emailLabel)
        addSubview(statusLabel)
        addSubview(statusValLabel)
        
        userIcon.centerY().height(multiplier: 0.5).widthEqualsHeight().left(constant: UIViewPadding.large).apply()
        nameLabel.right(of: userIcon, constant: UIViewPadding.big).top(to: userIcon, constant: 0).right(constant: UIViewPadding.small).apply()
        emailLabel.bottom(of: nameLabel, constant: UIViewPadding.small).left(to: nameLabel, constant: 0).right(constant: UIViewPadding.small).apply()
        statusLabel.bottom(of: emailLabel, constant: UIViewPadding.medium).right(of: userIcon, constant: UIViewPadding.big).apply()
        statusValLabel.right(of: statusLabel, constant: UIViewPadding.small).centerY(to: statusLabel).apply()
        //statusValLabel.bottom(of: statusLabel, constant: UIViewPadding.small).left(to: nameLabel, constant: 0).apply()
        
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCanAddPicture(oldValue: Bool){
        if oldValue == canAddPicture { return }
        
        userIcon.canAddPicture = self.canAddPicture
    }
    
    func reloadData() {
    
        if let user = ERUser.current() {
            nameLabel.text  = user.formattedName
            emailLabel.text = user.username
            ResponderStateManager.shared.getState(completion: { (state) in
                switch state {
                case .active:
                    self.statusValLabel.text = String.ACTIVE
                    self.statusValLabel.textColor = ResponderStateManager.getColor(responderState: .active)
                    break
                case .paused:
                    self.statusValLabel.text = String.PAUSED
                    self.statusValLabel.textColor = ResponderStateManager.getColor(responderState: .paused)
                    break
                case .inactive:
                    self.statusValLabel.text = String.INACTIVE
                    self.statusValLabel.textColor = ResponderStateManager.getColor(responderState: .inactive)
                    break
                case .notComplete:
                    self.statusValLabel.text = String.INCOMPLETE_PROFILE
                    self.statusValLabel.textColor = ResponderStateManager.getColor(responderState: .notComplete)
                    break
                }
            })
        } else {
            nameLabel.text      = nil
            emailLabel.text     = nil
            statusValLabel.text = String.UNREGISTERED
        }
        nameLabel.lineBreakMode = .byTruncatingTail
        nameLabel.textColor = UIColor.white
        emailLabel.lineBreakMode = .byTruncatingTail
        emailLabel.textColor = UIColor.white
        statusLabel.text    = String.STATUS
        statusLabel.textColor = UIColor.white
        statusValLabel.backgroundColor = UIColor.white
        statusValLabel.setTextInsets(left: 2, right: 2, top: 2, bottom: 2)
        statusValLabel.font = UIFont.openSansRegular(textStyle: .callout)
        statusValLabel.minimumScaleFactor = 0.8
        statusValLabel.adjustsFontSizeToFitWidth = true
        
        userIcon.reloadData()
    }
    
    func addUserIconTarget(target: Any?, action: Selector) {
        userIcon.addTarget(target: target, action: action)
    }
    
    override var intrinsicContentSize: CGSize {
        let height = userIcon.frame.height
        let padding = 2 * UIViewPadding.big
        return CGSize(width: 0, height: height + padding)
    }
    
}
