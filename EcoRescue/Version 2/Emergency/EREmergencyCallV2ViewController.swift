//
//  EREmergencyCallV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 26.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import MapKit

class EREmergencyCallV2ViewController: EREmergencyCallStepViewController {
    
    private let numberFormatter = NumberFormatter()
    
    private let timerLabel = UILabel.type1Label()
    
    private let distanceLabel = UILabel.type1Label()
    
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.colorPrimaryBlue
        
        // containerView
        let containerView = UIView.view()
        view.addSubview(containerView)
        containerView.match(constant: UIViewPadding.big + statusBarHeight).apply()
        
        // containerView - logoImageView
        let logoImageView = UIImageView.imageView()
        containerView.addSubview(logoImageView)
        logoImageView.top(constant: UIViewPadding.big).centerX().height(constant: 50).widthEqualsHeight().apply()
        logoImageView.image = UIImage.iconLogoV2()
        logoImageView.contentMode = .scaleAspectFit
        
        // containerView - separatorView1 - separatorView2
        let separatorView1 = UIView.seperatorView()
        containerView.addSubview(separatorView1)
        separatorView1.centerY(to: logoImageView).left().left(of: logoImageView, constant: UIViewPadding.big).height(constant: 1).apply()
        separatorView1.backgroundColor = UIColor.white
        
        let separatorView2 = UIView.seperatorView()
        containerView.addSubview(separatorView2)
        separatorView2.centerY(to: logoImageView).right().right(of: logoImageView, constant: UIViewPadding.big).height(constant: 1).apply()
        separatorView2.backgroundColor = UIColor.white
        
        // containerView - emergencyCallImageView
        let emergencyCallImageView = UIImageView.imageView()
        containerView.addSubview(emergencyCallImageView)
        emergencyCallImageView.centerX().bottom(of: logoImageView, constant: UIViewPadding.large + UIViewPadding.medium).leftright(constant: UIViewPadding.large).height(constant: UIScreen.main.bounds.width * 0.5).apply()
        
        if emergencyState?.emergencyTaskValue == .firstResponder {
            emergencyCallImageView.image = UIImage.iconEmergencyCallV2().imageWithColor(UIColor.colorPrimaryRedV2)
        } else if emergencyState?.emergencyTaskValue == .getAED {
            emergencyCallImageView.image = UIImage.iconAEDTask().imageWithColor(UIColor.colorPrimaryRedV2)
        }
        emergencyCallImageView.contentMode = .scaleAspectFit
        
        // containerView - titleLabel
        let titleLabel = UILabel.type1BoldLabel()
        containerView.addSubview(titleLabel)
        titleLabel.centerX().bottom(of: emergencyCallImageView, constant: UIViewPadding.large + UIViewPadding.medium).apply()
        titleLabel.text = String.EMERGENCY_CALL.uppercased()
        titleLabel.textColor = UIColor.white
        
        // containerView - taskLabel
        let taskLabel = UILabel.type1BoldLabel()
        containerView.addSubview(taskLabel)
        taskLabel.centerX().bottom(of: titleLabel, constant: UIViewPadding.small).apply()
        if emergencyState?.emergencyTaskValue == .firstResponder {
            taskLabel.text = "\(String.TASK): \(String.FIRST_RESPONDER_TASK)"
        } else if emergencyState?.emergencyTaskValue == .getAED {
            taskLabel.text = "\(String.TASK): \(String.GET_AED_TASK)"
        }
        taskLabel.textColor = UIColor.colorPrimaryRedV2
        
        // containerView - detailLabel
        let detailLabel = UILabel.type1Label()
        containerView.addSubview(detailLabel)
        detailLabel.centerX().bottom(of: taskLabel, constant: UIViewPadding.large).leftright(constant: UIViewPadding.large).apply()
        detailLabel.text = String.ARE_YOU_READY_TO_ANSWER_THE_CALL
        detailLabel.textAlignment = .center
        detailLabel.numberOfLines = 0
        detailLabel.textColor = UIColor.white
        
        // containerView - distanceLabel
        containerView.addSubview(distanceLabel)
        distanceLabel.centerX().bottom(of: detailLabel, constant: UIViewPadding.big).leftright(constant: UIViewPadding.large).apply()
        distanceLabel.textAlignment = .center
        distanceLabel.numberOfLines = 0
        distanceLabel.textColor = UIColor.white
        
        // containerView - takeEmergencyButton
        let takeEmergencyButton = ERButton()
        containerView.addSubview(takeEmergencyButton)
        takeEmergencyButton.centerX().bottom(constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).apply()
        takeEmergencyButton.text = String.TAKE_EMERGENCY
        takeEmergencyButton.backgroundColor = UIColor.colorPrimaryRedV2
        takeEmergencyButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        takeEmergencyButton.addTarget(self, action: #selector(didTapTakeEmergency(sender:)), for: .touchDown)
        
        // containerView - timerLabel
        containerView.addSubview(timerLabel)
        timerLabel.centerX().top(of: takeEmergencyButton, constant: UIViewPadding.large + UIViewPadding.medium).apply()
        timerLabel.text = "-- : --"
        timerLabel.textColor = UIColor.colorPrimaryRedV2
        
        // containerView - separatorView3 - separatorView4
        let separatorView3 = UIView.seperatorView()
        containerView.addSubview(separatorView3)
        separatorView3.centerY(to: timerLabel).left().left(of: timerLabel, constant: UIViewPadding.big).height(constant: 1).apply()
        separatorView3.backgroundColor = UIColor.white
        
        let separatorView4 = UIView.seperatorView()
        containerView.addSubview(separatorView4)
        separatorView4.centerY(to: timerLabel).right().right(of: timerLabel, constant: UIViewPadding.big).height(constant: 1).apply()
        separatorView4.backgroundColor = UIColor.white
        
        // Number Formatter
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        
        setEmergencyDistance()
        
        startTimer()
        
        // Set Emergency State Ready
        if let emergencyState = emergencyState {
            emergencyState.stateValue = .ready
            emergencyState.saveInBackground()
            
            dataManager.setEmergencyState(emergencyState)
        }
        
    }
    
    func didTapTakeEmergency(sender: Any) {
        
        stopTimer()
        delegate?.goNextStep()
    }
    
    func timerTask(sender: AnyObject) {
        reloadTimerLabel()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerTask(sender:)), userInfo: nil, repeats: true)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func reloadTimerLabel() {
        if let emergencyState = emergencyState {
            
            let difference = emergencyState.timeIntervalUntilExpired
            if difference >= 0 {
                let s: Int = Int(difference) % 60
                let m: Int = Int(difference) / 60
                
                let numberString = String(format: "%02d : %02d", m, s)
                timerLabel.text = numberString
            } else {
                delegate?.finalizeSteps(with: emergencyState, cancel: false, expired: true)
                timerLabel.text = "-- : --"
            }
            
        } else {
            delegate?.finalizeSteps()
            timerLabel.text = "-- : --"
        }
    }
    
    private func setEmergencyDistance() {
        if let emergencyState = emergencyState, let loc = ERUser.current()?.location, let emergencyLoc = emergencyState.emergencyRelation.locationPoint {
            MKMapView.route(from: loc.coordinate, to: emergencyLoc.coordinate, transportType: .walking) { (route, error) in
                if let route = route {
                    self.distanceLabel.text = String(format: "\(String.EMERGENCY) in %.02fm", route.distance)
                } else {
                    self.distanceLabel.text = String.UNKNOWN
                }
            }
            //return loc.distanceInKilometers(to: emergencyState.emergencyRelation.locationPoint) * 1000
        }
        self.distanceLabel.text = String.UNKNOWN
    }
    
}
