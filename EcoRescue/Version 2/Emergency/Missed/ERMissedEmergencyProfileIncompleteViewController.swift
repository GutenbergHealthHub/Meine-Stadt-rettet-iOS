//
//  ERMissedEmergencyProfileIncompleteViewController.swift
//  EcoRescue
//
//  Created by Birtan on 14.02.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERMissedEmergencyProfileIncompleteViewController: UIViewController {
    
    private let dateLabel = UILabel.type2LightLabel()
    
    private let dateFormatter = DateFormatter()
    
    var emergencyState: EREmergencyState? { didSet { setEmergencyState(oldValue: oldValue) } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.colorPrimaryBlue
        
        let imageView = UIImageView.imageView()
        view.addSubview(imageView)
        
        imageView.top(constant: 2 * UIViewPadding.large).centerX().height(multiplier: 0.2).widthEqualsHeight().apply()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage.iconLogoV2()
        
        let titleLabel = UILabel.type2BoldLabel(.title2)
        view.addSubview(titleLabel)
        
        titleLabel.bottom(of: imageView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        titleLabel.textColor = UIColor.colorPrimaryRedV2
        titleLabel.textAlignment = .center
        titleLabel.text = String.MISSED_EMERGENCY_PROFILE_INCOMPLETE_TITLE
        
        view.addSubview(dateLabel)
        dateLabel.bottom(of: titleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        dateLabel.textColor = UIColor.colorPrimaryRedV2
        dateLabel.textAlignment = .center
        
        let detailLabel = UILabel.type2Label(.title3)
        view.addSubview(detailLabel)
        detailLabel.bottom(of: dateLabel, constant: UIViewPadding.large).leftright(constant: UIViewPadding.large).apply()
        detailLabel.textColor = UIColor.white
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.text = String.MISSED_EMERGENCY_PROFILE_INCOMPLETE_DETAIL
        
        let button = ERButton()
        view.addSubview(button)
        button.bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.setTitle(String.GO_BACK, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchDown)
    }
    
    private func setEmergencyState(oldValue: EREmergencyState?) {
        guard let state = emergencyState else { return }
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        dateLabel.text = dateFormatter.string(from: state.createdAt!)
    }
    
    func buttonAction(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
