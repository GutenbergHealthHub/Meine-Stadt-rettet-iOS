//
//  ERImagePreviewViewController.swift
//  EcoRescue
//
//  Created by Birtan on 25.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

protocol ERImagePreviewViewControllerDelegate: NSObjectProtocol {
    func save(image: UIImage)
}

class ERImagePreviewViewController: UIViewController {
    
    weak var delegate: ERImagePreviewViewControllerDelegate?
    
    private let infoLabel    = UILabel.calloutLabel
    private let imageView    = UIImageView.imageView()
    private let retakeButton = UIButton.button()
    private let saveButton   = UIButton.button()
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        view.addSubview(infoLabel)
        view.addSubview(imageView)
        view.addSubview(retakeButton)
        view.addSubview(saveButton)
        
        infoLabel.top().leftright().height(constant: 40).apply()
        imageView.bottom(of: infoLabel, constant: 0).bottom(constant: 50).leftright().apply()
        retakeButton.bottom().left(constant: UIViewPadding.big).height(constant: 50).apply()
        saveButton.bottom().right(constant: UIViewPadding.big).height(constant: 50).apply()
        
        infoLabel.text = String.PREVIEW_OF_THE_CERTIFICATE
        infoLabel.textAlignment = .center
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        imageView.clipsToBounds = true
        
        retakeButton.setTitle(String.RETAKE, for: .normal)
        saveButton.setTitle(String.SAVE, for: .normal)
        
        retakeButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        saveButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        
        retakeButton.setTitleColor(UIColor.black, for: .normal)
        saveButton.setTitleColor(UIColor.black, for: .normal)
        
        retakeButton.addTarget(self, action: #selector(didTapRetake(sender:)), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave(sender:)), for: .touchUpInside)
    }
    
    func didTapRetake(sender: Any) {
        self.navigationController?.pop(animated: false)
    }
    
    func didTapSave(sender: Any) {
        self.navigationController?.pop(animated: false)
        delegate?.save(image: image!)
    }


}
