//
//  ERIntroFirstViewController.swift
//  EcoRescue
//
//  Created by Birtan on 05.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERIntroStepViewController: UIViewController {
    
    weak var delegate: StepsViewControllerDelegate?
    
    let topContainerView = UIView.view()
    let titleLabel    = UILabel.type1BoldLabel(.title1)
    let progressView  = UIProgressView(progressViewStyle: .default)
    
    let containerView = UIView.view()
    
    let bottomContainerView = UIView.view()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.colorPrimaryBlue
        
        // Top Container View
        view.addSubview(topContainerView)
        topContainerView.top().leftright().height(multiplier: 0.3).apply()
        
        // ImageView
        let imageView = UIImageView.imageView()
        topContainerView.addSubview(imageView)
        imageView.centerX().top(constant: 25).height(multiplier: 0.5).widthEqualsHeight().apply()
        imageView.image = UIImage.iconLogoV2()
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        
        //Progress View
        topContainerView.addSubview(progressView)
        progressView.bottom().leftright().height(constant: 5).apply()
        progressView.translatesAutoresizingMaskIntoConstraints  = false
        progressView.isUserInteractionEnabled  = false
        progressView.progressTintColor = UIColor.colorIntroProgressBarV2
        progressView.trackTintColor = UIColor.colorIntroProgressBarBackgroundV2
        
        // TitleLabel
        topContainerView.addSubview(titleLabel)
        titleLabel.top(of: progressView, constant: UIViewPadding.medium).leftright(constant: UIViewPadding.big).bottom(of: imageView, constant: UIViewPadding.large).apply()
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.minimumScaleFactor = 0.5
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.textColor = .white
        
        // Bottom Container View
        view.addSubview(bottomContainerView)
        bottomContainerView.bottom().leftright().height(multiplier: 0.2).apply()
        
        // Skip Button
        let skipButton = UIButton.button()
        bottomContainerView.addSubview(skipButton)
        skipButton.bottom(constant: UIViewPadding.big).leftright().apply()
        skipButton.setTitle(String.SKIP_INTRODUCTION, for: .normal)
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.addTarget(self, action: #selector(didTapSkip(sender:)), for: .touchUpInside)
        
        // Next Button
        let nextButton = ERButton()
        bottomContainerView.addSubview(nextButton)
        nextButton.top(of: skipButton, constant: UIViewPadding.medium).leftright(constant: UIViewPadding.big).top(constant: UIViewPadding.medium).apply()
        nextButton.backgroundColor = UIColor.white
        nextButton.setTitle(String.CONTINUE, for: .normal)
        nextButton.setTitleColor(UIColor.colorPrimaryRedV2, for: UIControlState.normal)
        nextButton.addTarget(self, action: #selector(didTapNext(sender:)), for: .touchUpInside)
        
        // Container View
        view.addSubview(containerView)
        containerView.bottom(of: topContainerView, constant: 0).leftright(constant: UIViewPadding.big).top(of: bottomContainerView, constant: 0).apply()
        
        
    }
    
    func didTapSkip(sender: Any) {
        delegate?.finalizeSteps()
    }
    
    func didTapNext(sender: Any) {
        delegate?.goNextStep()
    }
    
    func fixText(inputText: NSMutableAttributedString, attributeName: AnyObject, attributeValue: AnyObject, propsIndicator: String, propsEndIndicator: String) -> NSMutableAttributedString {
        var r1 = (inputText.string as NSString).range(of: propsIndicator)
        while r1.location != NSNotFound {
            let r2 = (inputText.string as NSString).range(of: propsEndIndicator)
            if r2.location != NSNotFound  && r2.location > r1.location {
                let r3 = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length)
                inputText.addAttribute(attributeName as! String, value: attributeValue, range: r3)
                inputText.replaceCharacters(in: r2, with: "")
                inputText.replaceCharacters(in: r1, with: "")
            } else {
                break
            }
            r1 = (inputText.string as NSString).range(of: propsIndicator)
        }
        return inputText
    }
    
    
}
