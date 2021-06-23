//
//  StepsViewController.swift
//  EcoRescue
//
//  Created by Birtan on 30.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

protocol StepsViewControllerDelegate: NSObjectProtocol {
    func goNextStep()
    func goPreviousStep()
    func finalizeSteps()
    func finalizeSteps(with: EREmergencyState?, cancel: Bool, expired: Bool)
}

class StepsViewController: UIViewController {
    
    weak var delegate: StepsViewControllerDelegate?
    
    let headerView    = UIView.view()
    let bottomView    = UIView.view()
    
    let progressView  = UIProgressView(progressViewStyle: .default)
    let progressView2 = UIProgressView(progressViewStyle: .default)
    let progressLabel = UILabel.type2LightLabel()
    
    let backButton = UIButton.button()
    let nextButton = UIButton.button()
    
    let headerTitleLabel    = UILabel.type2Label()
    let headerSubtitleLabel = UILabel.type2LightLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        //Header View
        view.addSubview(headerView)
        headerView.top().leftright().height(multiplier: 0.2).apply()
        headerView.backgroundColor = UIColor.colorPrimaryBlue
        
        //Header View - titleLabel
        headerView.addSubview(headerTitleLabel)
        headerTitleLabel.top(constant: UIViewPadding.big).left(constant: UIViewPadding.big).right(constant: UIViewPadding.big).apply()
        headerTitleLabel.textColor = UIColor.white
        
        
        //Header View - subtitleLabel
        headerView.addSubview(headerSubtitleLabel)
        headerSubtitleLabel.bottom(of: headerTitleLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.big).right(constant: UIViewPadding.big).bottom(constant: UIViewPadding.small, relatedBy: .lessThanOrEqual).apply()
        headerSubtitleLabel.textColor     = UIColor.white
        headerSubtitleLabel.numberOfLines = 0
        headerSubtitleLabel.minimumScaleFactor = 0.6
        
        //Bottom View
        view.addSubview(bottomView)
        bottomView.bottom().leftright().height(multiplier: 0.1).apply()
        bottomView.backgroundColor = UIColor.colorPrimaryBlue
        
        //Progress View
        progressView.translatesAutoresizingMaskIntoConstraints  = false
        progressView2.translatesAutoresizingMaskIntoConstraints = false
        progressView.isUserInteractionEnabled  = false
        progressView2.isUserInteractionEnabled = false
        progressView.progressTintColor = UIColor.colorProgressBarV2
        progressView.trackTintColor = UIColor.colorProgressBarBackgroundV2
        progressView2.progressTintColor = UIColor.colorProgressBarV2
        progressView2.trackTintColor = UIColor.colorProgressBarBackgroundV2
        view.addSubview(progressView)
        view.addSubview(progressView2)
        progressView.bottom(of: headerView, constant: 0).leftright().height(constant: 5).apply()
        progressView2.top(of: bottomView, constant: 0).leftright().height(constant: 5).apply()
        
        //Bottom View - Buttons
        bottomView.addSubview(backButton)
        backButton.topbottom().left(constant: UIViewPadding.big).apply()
        backButton.setTitle(String.BACK, for: .normal)
        backButton.setTitleColor(UIColor.white, for: .normal)
        backButton.addTarget(self, action: #selector(didTapPrevious(sender:)), for: .touchUpInside)
        
        bottomView.addSubview(nextButton)
        nextButton.topbottom().right(constant: UIViewPadding.big).apply()
        nextButton.setTitle(String.NEXT, for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.addTarget(self, action: #selector(didTapNext(sender:)), for: .touchUpInside)
        
        //Bottom View - Progress Label
        bottomView.addSubview(progressLabel)
        progressLabel.centerXY().apply()
        progressLabel.textColor = UIColor.white
        progressLabel.textAlignment = .center

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func didTapNext(sender: Any) {
        delegate?.goNextStep()
    }
    
    func didTapPrevious(sender: Any) {
        delegate?.goPreviousStep()
    }
    
    func setProgressViews(progress: Float) {
        progressView.progress  = progress
        progressView2.progress = progress
    }

}
