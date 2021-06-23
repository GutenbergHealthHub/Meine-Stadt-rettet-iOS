//
//  ERNewEventHeaderView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 02.05.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class ERNewEventHeaderView: UCView {
    
    // Views
    private let imageView = UIView.initImageView()
    
    override init() {
        super.init()
        clipsToBounds = true
        
        // Do any additional setup after loading the view.
        imageView.contentMode = UIViewContentMode.scaleAspectFill
    
        addSubview(imageView)
        imageView.match().apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    var image: UIImage? {
        set { imageView.image = newValue    }
        get { return imageView.image        }
    }

    
    // MARK: - Touching
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        touching = true
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        touching = false
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        touching = false
    }
    
    private var touching: Bool = false { didSet { p_setTouching() } }
    
    private func p_setTouching() {
        alpha = touching ? 0.3 : 1.0
    }
    
}
