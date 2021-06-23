//
//  ERSuccessPageViewController.swift
//  EcoRescue
//
//  Created by Birtan on 03.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

protocol ERFinalStepViewControllerDelegate: NSObjectProtocol {
    func tapped(mainButton: Bool)
}

class ERFinalStepViewController: UIViewController {
    
    weak var delegate: ERFinalStepViewControllerDelegate?
    
    let topTitleLabel    = UILabel.type1BoldLabel(.headline)
    
    let titleImage       = UIImageView.imageView()
    let titleLabel       = UILabel.type2BoldLabel(.title3)
    let descriptionLabel = UILabel.type2Label()
    let detailLabel      = UILabel.type2Label()
    
    let mainButton      = ERButton()
    let secondaryButton = ERButton()
    
    var isSecondaryButton: Bool = false
    
    var viewColor: UIColor? = UIColor.colorPrimaryBlue

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        //TopView
        let topView = UIView.view()
        view.addSubview(topView)
        
        topView.top().leftright().height(multiplier: 0.1).apply()
        topView.backgroundColor = viewColor
        
        //TopView - topTitleLabel
        topView.addSubview(topTitleLabel)
        topTitleLabel.centerX().bottom(constant: UIViewPadding.medium).apply()
        topTitleLabel.textAlignment = .center
        
        //ContainerView
        let containerView = UIView.view()
        view.addSubview(containerView)
        
        containerView.bottom(of: topView, constant: UIViewPadding.big).bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        
        //ContainerView - titleImage
        containerView.addSubview(titleImage)
        titleImage.top(constant: UIViewPadding.big).centerX().width(constant: 50).widthEqualsHeight().apply()
        titleImage.contentMode = .scaleAspectFit
        
        //ContainerView - titleLabel
        containerView.addSubview(titleLabel)
        titleLabel.bottom(of: titleImage, constant: 2 * UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        //ContainerView - descriptionLabel
        containerView.addSubview(descriptionLabel)
        descriptionLabel.bottom(of: titleLabel, constant: 2 * UIViewPadding.big).leftright(constant: 2 * UIViewPadding.big).apply()
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        //ContainerView - detailLabel
        containerView.addSubview(detailLabel)
        detailLabel.bottom(of: descriptionLabel, constant: UIViewPadding.big).leftright(constant: 2 * UIViewPadding.big).apply()
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        
        //ContainerView - mainButton
        containerView.addSubview(mainButton)
        mainButton.bottom().leftright(constant: UIViewPadding.big).apply()
        mainButton.backgroundColor = viewColor
        mainButton.setTitleColor(viewColor == UIColor.colorPrimaryBlue ? .white : .black, for: .normal)
        mainButton.addTarget(self, action: #selector(didTapAnyButton(sender:)), for: .touchUpInside)
        
        //ContainerView - secondaryButton
        containerView.addSubview(secondaryButton)
        secondaryButton.top(of: mainButton, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        secondaryButton.backgroundColor = UIColor.gray
        secondaryButton.setTitleColor(UIColor.white, for: .normal)
        secondaryButton.addTarget(self, action: #selector(didTapAnyButton(sender:)), for: .touchUpInside)
        secondaryButton.alpha = isSecondaryButton ? 1 : 0
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func didTapAnyButton(sender: UIButton) {
        dismiss(animated: sender == self.secondaryButton, completion: {
            self.delegate?.tapped(mainButton: sender == self.mainButton)
        })
    }

    

}
