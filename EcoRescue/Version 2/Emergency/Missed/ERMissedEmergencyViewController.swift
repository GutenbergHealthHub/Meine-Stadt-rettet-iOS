//
//  ERMissedEmergencyViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 23.01.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERMissedEmergencyViewController: UIViewController {
    
    private let dateLabel = UILabel.type2LightLabel()
    
    private let addressLabel = UILabel.type2Label(.title3)
    
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
        titleLabel.text = String.MISSED_EMERGENCY_TITLE
        
        view.addSubview(dateLabel)
        dateLabel.bottom(of: titleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        dateLabel.textColor = UIColor.colorPrimaryRedV2
        dateLabel.textAlignment = .center
        
        view.addSubview(addressLabel)
        addressLabel.bottom(of: dateLabel, constant: UIViewPadding.large).leftright(constant: UIViewPadding.large).apply()
        addressLabel.numberOfLines = 0
        addressLabel.textColor = UIColor.white
        addressLabel.textAlignment = .center
        
        let detailLabel = UILabel.type2Label(.title3)
        view.addSubview(detailLabel)
        detailLabel.bottom(of: addressLabel, constant: UIViewPadding.large).leftright(constant: UIViewPadding.large).apply()
        detailLabel.textColor = UIColor.white
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.text = String.MISSED_EMERGENCY_DETAIL
        
        let button = ERButton()
        view.addSubview(button)
        button.bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).apply()
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.setTitle(String.GO_BACK, for: .normal)
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchDown)
        
        
        
        
        ERUserDefaultManager.userDefaultMissedEmergencyId.stringValue = ""
    }
    
    private func setEmergencyState(oldValue: EREmergencyState?) {
        guard let state = emergencyState else { return }
       
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        dateLabel.text = dateFormatter.string(from: state.createdAt!)
        
    
        let attrs1 = NSAttributedString(string: dateDifference(from: state.createdAt!), attributes: [NSFontAttributeName: UIFont.openSansBold(textStyle: .body)])
        
        let attrs = NSAttributedString(string: String(format: String.MISSED_EMERGENCY_ADDRESS, attrs1.string))

        addressLabel.attributedText = attrs
    }
    
    private func dateDifference(from: Date) -> String {
        let components = Set<Calendar.Component>([.minute, .hour, .day])
        let differenceOfDate = Calendar.current.dateComponents(components, from: from, to: Date())
    
        var str: String = ""
        
        if let days = differenceOfDate.day, days > 0 {
            str.append(" \(days) ")
            if days == 1 {
                str.append(String.DAY)
            } else if days > 1 {
                str.append(String.DAYS)
            }
        }
        
        if let hours = differenceOfDate.hour, hours > 0 {
            str.append(" \(hours) ")
            if hours == 1 {
                str.append(String.HOUR)
            } else if hours > 1 {
                str.append(String.HOURS)
            }
        }
        
        if let minutes = differenceOfDate.minute {
            str.append(" \(minutes) ")
            if minutes == 1 {
                str.append(String.MINUTE)
            } else if minutes > 1 {
                str.append(String.MINUTES)
            }
        }
        
        return str
    }
    
    func buttonAction(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
