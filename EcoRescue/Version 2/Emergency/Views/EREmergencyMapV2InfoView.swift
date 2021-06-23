//
//  EREmergencyMapV2InfoView.swift
//  EcoRescueASB
//
//  Created by Birtan on 27.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class EREmergencyMapV2InfoView: UIView {
    
    let distanceLabel    = UILabel.type2SemiBoldLabel()
    let distanceValLabel = UILabel.type2Label()
    let timeValLabel     = UILabel.type2Label()
    let separatorView1   = UIView.seperatorView()
    let separatorView2   = UIView.seperatorView()
    let taskLabel        = UILabel.type2SemiBoldLabel()
    let taskValLabel     = UILabel.type2LightLabel()
    let descriptionLabel = UILabel.type2SemiBoldLabel()
    let descriptionValLabel = UILabel.type2LightLabel()
    let addressLabel = UILabel.type2SemiBoldLabel()
    let addressValLabel = UILabel.type2LightLabel()
    let patientNameLabel = UILabel.type2SemiBoldLabel()
    let patientNameValLabel = UILabel.type2LightLabel()
    let emergencyNumberLabel = UILabel.type2SemiBoldLabel()
    let emergencyNumberValLabel = UILabel.type2LightLabel()
    let keywordLabel = UILabel.type2SemiBoldLabel()
    let keywordValLabel = UILabel.type2LightLabel()
    let indicatorLabel = UILabel.type2SemiBoldLabel()
    let indicatorValLabel = UILabel.type2LightLabel()
    let objectLabel = UILabel.type2SemiBoldLabel()
    let objectValLabel = UILabel.type2LightLabel()
    let geoCoordinationLabel = UILabel.type2SemiBoldLabel()
    let geoCoordinationValLabel = UILabel.type2LightLabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(distanceLabel)
        distanceLabel.top(constant: UIViewPadding.small).left(constant: UIViewPadding.big).apply()
        distanceLabel.text = "\(String.DISTANCE.uppercased()):"
        
        addSubview(separatorView1)
        separatorView1.leftright().bottom(of: distanceLabel, constant: UIViewPadding.small).height(constant: 0.5).apply()
        
        addSubview(timeValLabel)
        timeValLabel.top(constant: UIViewPadding.small).right(constant: UIViewPadding.big).width(multiplier: 0.2).apply()
        timeValLabel.text = "--"
        
        addSubview(separatorView2)
        separatorView2.top().bottom(to: separatorView1, constant: 0).left(of: timeValLabel, constant: UIViewPadding.big).width(constant: 0.5).apply()
        
        addSubview(distanceValLabel)
        distanceValLabel.top(constant: UIViewPadding.small).left(of: separatorView2, constant: UIViewPadding.big).apply()
        distanceValLabel.text = "--"
        
        addSubview(taskLabel)
        taskLabel.bottom(of: separatorView1, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        taskLabel.text = "\(String.TASK.uppercased()):"
        
        addSubview(taskValLabel)
        taskValLabel.bottom(of: taskLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()
        taskValLabel.numberOfLines = 0
        
        addSubview(descriptionLabel)
        descriptionLabel.bottom(of: taskValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        descriptionLabel.text = "\(String.DESCRIPTION.uppercased()):"
        
        
        addSubview(descriptionValLabel)
        descriptionValLabel.bottom(of: descriptionLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()
        descriptionValLabel.numberOfLines = 3
        
        
        addSubview(addressLabel)
        addressLabel.bottom(of: descriptionValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        addressLabel.text = "\(String.ADDRESS):"
        
        
        addSubview(addressValLabel)
        addressValLabel.bottom(of: addressLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()
        addressValLabel.numberOfLines = 0
        
        addSubview(objectLabel)
        objectLabel.bottom(of: addressValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        objectLabel.text = "\(String.OBJECT):"
        
        addSubview(objectValLabel)
        objectValLabel.bottom(of: objectLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()
        
        
        addSubview(patientNameLabel)
        patientNameLabel.bottom(of: objectValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        patientNameLabel.text = "\(String.PATIENT):"
        
        
        addSubview(patientNameValLabel)
        patientNameValLabel.bottom(of: patientNameLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()
        
        
        addSubview(indicatorLabel)
        indicatorLabel.bottom(of: patientNameValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        indicatorLabel.text = "\(String.INDICATOR):"
        
        addSubview(indicatorValLabel)
        indicatorValLabel.bottom(of: indicatorLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()
        
        addSubview(geoCoordinationLabel)
        geoCoordinationLabel.bottom(of: indicatorValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        geoCoordinationLabel.text = "\(String.GEO_COORDINATION):"
        
        
        addSubview(geoCoordinationValLabel)
        geoCoordinationValLabel.bottom(of: geoCoordinationLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()

        
        addSubview(emergencyNumberLabel)
        emergencyNumberLabel.bottom(of: geoCoordinationValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        emergencyNumberLabel.text = "\(String.EMERGENCY_NUMBER):"
        
        
        addSubview(emergencyNumberValLabel)
        emergencyNumberValLabel.bottom(of: emergencyNumberLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()

        
        addSubview(keywordLabel)
        keywordLabel.bottom(of: emergencyNumberValLabel, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        keywordLabel.text = "\(String.KEYWORD):"
        
        
        addSubview(keywordValLabel)
        keywordValLabel.bottom(of: keywordLabel, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let height = distanceLabel.frame.height * 20 + 10 * (UIViewPadding.big + UIViewPadding.tiny) + 2 * UIViewPadding.small
        return CGSize(width: frame.width, height: height)
    }

}
