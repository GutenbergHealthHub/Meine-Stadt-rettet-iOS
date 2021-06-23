//
//  ERStandByViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 19.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UserNotifications

class ERStandByViewController: CenterMenuViewController, UIPopoverPresentationControllerDelegate, ERPopOverTableViewControllerDelegate, ERFinalStepViewControllerDelegate {
    
    private let descriptionView = ERDescriptionView()
    
    private let homeCheckbox = ERCheckBoxView()
    
    //private let regionCheckbox = ERCheckBoxView()
    
    //private let criticalAlertCheckbox = ERCheckBoxView()
    
    private let fromRectangleView = ERRectangleTextField()
    
    private let toRectangleView = ERRectangleTextField()
    
    private let daysRectangleView = ERRectangleView()
    
    private let datePicker = UIDatePicker()
    
    private var activeTextfield = UITextField()
    
    private var selectedDays: [String] = []
    
    private let vc =  ERDaysPopOverViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = String.STANDBY_OPTIONS
        view.backgroundColor = UIColor.white
        
        // Description view
        view.addSubview(descriptionView)
        descriptionView.top().leftright().height(multiplier: 0.2).apply()
        descriptionView.image = UIImage.iconStandbyV2().withRenderingMode(.alwaysTemplate)
        descriptionView.text  = String.STANDBY_INFO
        
        // Container view
        let containerView = UIView.view()
        view.addSubview(containerView)
        containerView.bottom(of: descriptionView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.large).bottom(constant: UIViewPadding.big).apply()
        
        // Container view - titleLabel
        let titleLabel = UILabel.type2BoldLabel()
        containerView.addSubview(titleLabel)
        titleLabel.top().left().apply()
        titleLabel.text = String.DUTY_TIME
        
        // Container view - timeSubtitleLabel
        let timeSubtitleLabel = UILabel.type2LightLabel()
        containerView.addSubview(timeSubtitleLabel)
        timeSubtitleLabel.bottom(of: titleLabel, constant: UIViewPadding.small).left().apply()
        timeSubtitleLabel.text = String.SELECT_THE_TIME
        
        // Container view - fromRectangleView
        containerView.addSubview(fromRectangleView)
        fromRectangleView.bottom(of: timeSubtitleLabel, constant: UIViewPadding.small).left().width(constant: (view.frame.width - 3 * UIViewPadding.large) / 2).apply()
        fromRectangleView.placeholder = String.FROM
        fromRectangleView.inputView   = datePicker
        fromRectangleView.addClearAndDoneToolbar()
        fromRectangleView.addTarget(self, action: #selector(textFieldChanged(_:)), for: UIControlEvents.touchDown)
        
        // Container view - toRectangleView
        containerView.addSubview(toRectangleView)
        toRectangleView.bottom(of: timeSubtitleLabel, constant: UIViewPadding.small).right(of: fromRectangleView, constant: UIViewPadding.large).width(constant: (view.frame.width - 3 * UIViewPadding.large) / 2).apply()
        toRectangleView.placeholder = String.TO
        toRectangleView.inputView   = datePicker
        toRectangleView.addClearAndDoneToolbar()
        toRectangleView.addTarget(self, action: #selector(textFieldChanged(_:)), for: UIControlEvents.touchDown)
        
        // Container view - daysSubtitleLabel
        let daysSubtitleLabel = UILabel.type2LightLabel()
        containerView.addSubview(daysSubtitleLabel)
        daysSubtitleLabel.bottom(of: fromRectangleView, constant: UIViewPadding.medium).leftright().apply()
        daysSubtitleLabel.text = String.SELECT_THE_DAYS_YOU_ARE_AVAILABLE
        daysSubtitleLabel.numberOfLines = 0
        
        // Container view - daysRectangleView
        containerView.addSubview(daysRectangleView)
        daysRectangleView.bottom(of: daysSubtitleLabel, constant: UIViewPadding.small).leftright().apply()
        daysRectangleView.addTarget(target: self, action: #selector(didTapDays(sender:)))
        
        // Container view - homeCheckbox
        containerView.addSubview(homeCheckbox)
        homeCheckbox.bottom(of: daysRectangleView, constant: UIViewPadding.big).left().width(constant: 20).heightEqualsWidth().apply()
        homeCheckbox.addTarget(target: self, action: #selector(didTapCheckbox(sender:)))
        
        // Container view - homeTitleLabel
        let homeTitleLabel = UILabel.type2BoldLabel()
        containerView.addSubview(homeTitleLabel)
        homeTitleLabel.bottom(of: daysRectangleView, constant: UIViewPadding.big).right(of: homeCheckbox, constant: UIViewPadding.medium).right().apply()
        homeTitleLabel.text = String.HOME
        homeTitleLabel.numberOfLines = 1
        
        // Container view - homeSubtitleLabel
        let homeSubtitleLabel = UILabel.type2LightLabel()
        containerView.addSubview(homeSubtitleLabel)
        homeSubtitleLabel.bottom(of: homeTitleLabel, constant: UIViewPadding.small).left(to: homeCheckbox, constant: 0).right().apply()
        homeSubtitleLabel.text = String.HOME_STANDBY_INFO
        homeSubtitleLabel.numberOfLines = 0
        
        /*
        if #available(iOS 12.0, *) {
            // Container view - criticalAlertCheckbox
            containerView.addSubview(criticalAlertCheckbox)
            criticalAlertCheckbox.bottom(of: homeSubtitleLabel, constant: UIViewPadding.big).left().width(constant: 20).heightEqualsWidth().apply()
            criticalAlertCheckbox.addTarget(target: self, action: #selector(didTapCheckbox(sender:)))
            
            // Container view - criticalAlertTitleLabel
            let criticalAlertTitleLabel = UILabel.type2BoldLabel()
            containerView.addSubview(criticalAlertTitleLabel)
            criticalAlertTitleLabel.bottom(of: homeSubtitleLabel, constant: UIViewPadding.big).right(of: criticalAlertCheckbox, constant: UIViewPadding.medium).right().apply()
            criticalAlertTitleLabel.text = "Critical Alert"
            criticalAlertTitleLabel.numberOfLines = 1
            
            // Container view - criticalAlertSubtitleLabel
            let criticalAlertSubtitleLabel = UILabel.type2LightLabel()
            containerView.addSubview(criticalAlertSubtitleLabel)
            criticalAlertSubtitleLabel.bottom(of: criticalAlertTitleLabel, constant: UIViewPadding.small).left(to: homeCheckbox, constant: 0).right().apply()
            criticalAlertSubtitleLabel.text = String.HOME_STANDBY_INFO
            criticalAlertSubtitleLabel.numberOfLines = 0
        }*/
        
        /*
        // Container view - regionCheckbox
        containerView.addSubview(regionCheckbox)
        regionCheckbox.bottom(of: homeSubtitleLabel, constant: UIViewPadding.big).left().width(constant: 20).heightEqualsWidth().apply()
        regionCheckbox.addTarget(target: self, action: #selector(didTapCheckbox(sender:)))
        
        // Container view - regionTitleLabel
        let regionTitleLabel = UILabel.type2BoldLabel()
        containerView.addSubview(regionTitleLabel)
        regionTitleLabel.bottom(of: homeSubtitleLabel, constant: UIViewPadding.big).right(of: regionCheckbox, constant: UIViewPadding.medium).right().apply()
        regionTitleLabel.text = "Region area"
        regionTitleLabel.numberOfLines = 1
        
        // Container view - regionSubtitleLabel
        let regionSubtitleLabel = UILabel.type2LightLabel()
        containerView.addSubview(regionSubtitleLabel)
        regionSubtitleLabel.bottom(of: regionTitleLabel, constant: UIViewPadding.small).left(to: homeCheckbox, constant: 0).right().apply()
        regionSubtitleLabel.text = "You won't receive any emergency calls if you are outside of your emergency region"
        regionSubtitleLabel.numberOfLines = 0*/
        
        // Container view - saveButton
        let saveButton = ERButton()
        containerView.addSubview(saveButton)
        saveButton.centerX().bottom().leftright().apply()
        saveButton.text = String.SAVE
        saveButton.addTarget(self, action: #selector(didTapSave(sender:)), for: .touchDown)
        
        // datePicker
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        reloadData()
    }
    
    
    private func reloadData() {
        if let user = ERUser.current() {
            homeCheckbox.check = user.dutyHome?.boolValue ?? false
            
            let dateFormatter        = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            if let from = user.dutyFrom {
                fromRectangleView.text = dateFormatter.string(from: from)
            }
            
            if let to = user.dutyTo {
                toRectangleView.text = dateFormatter.string(from: to)
            }
            if let dutyDays = user.dutyDays {
                vc.selectedDays = dutyDays.flatMap({ $0 as? Int })
                selectedDays    = user.dutyDaysValue.map({ $0 })
                daysRectangleView.label.text = selectedDays.joined(separator: ", ")
            }
            /*
            if #available(iOS 12.0, *) {
                UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                    DispatchQueue.main.async {
                        self.criticalAlertCheckbox.check = settings.criticalAlertSetting == .enabled
                    }
                }
            }*/
        }
    }
    
    private func showFinalViewController() {
        let vcFinal = ERFinalStepViewController()
        vcFinal.delegate = self
        
        vcFinal.topTitleLabel.text    = String.STANDBY_OPTIONS
        vcFinal.topTitleLabel.textColor = .white
        vcFinal.titleLabel.text       = String.STANDBY_OPTIONS
        vcFinal.descriptionLabel.text = String.STANDBY_SUCCESS_DESCRIPTION
        vcFinal.mainButton.setTitle(String.BACK, for: .normal)
        vcFinal.titleImage.image = UIImage.iconStandbyV2()
        
        self.present(vcFinal, animated: true, completion: nil)
    }
    
    private func openSettings() {
        if let url = URL(string: UIApplicationOpenSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: Actions
    
    func didTapSave(sender: Any) {
        if let user = ERUser.current() {
            user.dutyHome = homeCheckbox.check as NSNumber?
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
            
            if let from = fromRectangleView.text {
                let date = "9999/12/31 " + from
                user.dutyFrom = dateFormatter.date(from: date)
            }
            
            if let to = toRectangleView.text {
                let date = "9999/12/31 " + to
                user.dutyTo = dateFormatter.date(from: date)
            }
            

            user.dutyDays = vc.selectedDays.sorted() as NSArray?
            
            if let dutyDays = user.dutyDays, dutyDays.count == 0 {
                user.dutyDays = nil
            }
             
            user.saveInBackground()
            
            showFinalViewController()
        }
    }
    
    func didTapCheckbox(sender: ERCheckBoxView) {
        sender.check = !sender.check
    }
    
    func didTapDays(sender: ERRectangleView) {
        vc.delegate = self
        vc.popOverData = ERUser.daysTuple.map( { $1 } )
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize   = CGSize(width: (sender).frame.width, height: 300)
        
        if let pres = vc.presentationController {
            pres.delegate = self
        }
        
        self.present(vc, animated: true)
        if let ppc = vc.popoverPresentationController {
            ppc.sourceView = (sender)
            ppc.sourceRect = (sender).bounds
            ppc.permittedArrowDirections = .up
        }
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        activeTextfield.text     = dateFormatter.string(from: sender.date)

    }
    
    func textFieldChanged(_ sender: UITextField) {
        self.activeTextfield = sender
    }
    //MARK: UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK: ERPopOverTableViewControllerDelegate
    func selectedText(text: String, index: Int) {
        if selectedDays.contains(text) {
            selectedDays = selectedDays.filter { $0 != text}
        } else {
            selectedDays.append(text)
        }
        
        daysRectangleView.label.text = selectedDays.map({ $0 }).joined(separator: ", ")
    }
    
    //MARK: ERFinalStepViewControllerDelegate
    func tapped(mainButton: Bool) {
        //self.delegate?.changeViewController!(to: 1)
    }

}
