//
//  ERUserIconView.swift
//  EcoRescueASB
//
//  Created by Birtan on 15.10.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERUserIconView: Control {
    
    private let backgroundImageView = UIImageView.imageView()
    
    private let imageView = UIImageView.imageView()
    
    var canAddPicture: Bool = false { didSet { setCanAddPicture(oldValue: oldValue) } }

    override init() {
        super.init()
        
        backgroundColor = UIColor.white
        
        insertSubview(backgroundImageView, at: 0)
        backgroundImageView.match(constant: UIViewPadding.large).apply()
        backgroundImageView.image = UIImage.iconAnonymousUserV2()
        
        insertSubview(imageView, at: 1)
        imageView.match().apply()
        //imageView.contentMode = .scaleAspectFit
        
        layer.masksToBounds = true
        layer.borderWidth   = 2
        layer.borderColor   = UIColor.black.cgColor
        
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addTarget(target: Any?, action: Selector) {
        addTarget(target, action: action, for: .touchUpInside)
    }
    
    func reloadData() {
        
        if let user = ERUser.current(), let profilePicture = user.profilePicture {
            
            ERImageManager.image(from: profilePicture, completion: { (image, error) in
                self.imageView.image = image
            })
        } else {
            imageView.image = nil
        }
    }
    
    private func setCanAddPicture(oldValue: Bool){
        if oldValue == canAddPicture { return }
        
        if canAddPicture {
            backgroundImageView.image = UIImage.iconUserPictureV2()
        }
    }
    
}
