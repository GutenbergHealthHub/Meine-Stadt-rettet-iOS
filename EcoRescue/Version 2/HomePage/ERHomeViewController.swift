//
//  ERHomeViewController.swift
//  EcoRescue
//
//  Created by Birtan on 01.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
// 

import UIKit
import QuartzCore

class ERHomeViewController: CenterMenuViewController, ERDataManagerDelegate {

    private let dataManager = ERDataManager.sharedManager

    private let containerView = UIView.view()
    private let bottomView    = UIView.view()
    private let statusLabel   = UILabel.type2Label()
    
    private let mainContainerView = UIView.view()
    
    private var state: ResponderState?
    
    private var reportView: UIView?
    
    var firstTime: Bool = true
    
    var unfinishedProtocols: Int? { didSet { setUnfinishedProtocols(oldValue: oldValue) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.colorPrimaryBlue

        self.navigationItem.title = String.APP_NAME
        
        // mainContainerView
        self.view.addSubview(mainContainerView)
        mainContainerView.top().leftright().height(multiplier: 0.8).apply()
        
        // mainContainerView - titleLabel
        let titleLabel = UILabel.type1Label()
        mainContainerView.addSubview(titleLabel)
        titleLabel.leftright().top(constant: UIViewPadding.medium).centerX().apply()
        titleLabel.text = String.CALL_EMERGENCY.uppercased()
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
        // mainContainerView - subtitleLabel
        let subtitleLabel = UILabel.type1LightLabel()
        mainContainerView.addSubview(subtitleLabel)
        subtitleLabel.leftright().bottom(of: titleLabel, constant: UIViewPadding.medium).centerX().apply()
        subtitleLabel.text = String.CALL_EMERGENCY_INFO
        subtitleLabel.textColor = UIColor.white
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        
        // mainContainerView - sosButton
        let sosButton = UIButton(type: .custom)
        sosButton.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.addSubview(sosButton)
        sosButton.centerX().bottom(of: subtitleLabel, constant: UIViewPadding.big).width(multiplier: 0.8).heightEqualsWidth().apply()
        sosButton.setImage(UIImage.iconSOS(), for: .normal)
        sosButton.setImage(UIImage.iconSOSHighlighted(), for: .highlighted)
        sosButton.addTarget(self, action: #selector(didTapSOS(sender:)), for: .touchUpInside)
        
        // containerView
        self.view.addSubview(containerView)
        containerView.leftright().bottom(of: mainContainerView, constant: 0).bottom().apply()
        containerView.backgroundColor = UIColor.white
        
        // containerView - bodyLabel
        let bodyLabel = UILabel.type2Label()
        containerView.addSubview(bodyLabel)
        bodyLabel.text = String.STATUS
        bodyLabel.textColor = UIColor.black
        bodyLabel.top(constant: UIViewPadding.medium).left(constant: UIViewPadding.large).apply()
        
        // containerView - statusLabel
        containerView.addSubview(statusLabel)
        statusLabel.right(of: bodyLabel, constant: UIViewPadding.medium).bottom(to: bodyLabel, constant: 0).apply()
        
        // containerView - seperatorView
        let seperatorView = UIView.seperatorView()
        containerView.addSubview(seperatorView)
        seperatorView.leftright().bottom(of: bodyLabel, constant: UIViewPadding.medium).height(constant: 1).apply()
        
        // containerView - bottomView
        containerView.addSubview(bottomView)
        bottomView.bottom(of: seperatorView, constant: 0).leftright().bottom().apply()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.addObserver(self)
        reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Check for First Time
        if UserDefault.isFirstTimeIntro.boolValue {
            UserDefault.isFirstTimeIntro.boolValue = false
            present(ERIntroPageViewController(), animated: true, completion: nil)
            
        } else {
            if firstTime, ERUser.current() == nil {
                firstTime = false
                let vc = ERLoginPageViewController()
                present(vc, animated: true, completion: nil)
            } else {
                StartControllerQueueManager.presentIfFirstTime(parentViewController: self)
                self.unfinishedProtocols = dataManager.finishedExpiredEvaluationsWithProtocolNotDoneArray.count
            }
        }
    }
    
    override func appWillEnterForeground() {
        reloadData()
    }
        
    private func addButtonWith(text: String) {
        bottomView.removeSubviews()
        
        let button = ERButton()
        bottomView.addSubview(button)
        button.centerXY().leftright(constant: UIViewPadding.big).apply()
        button.text = text
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchDown)
        
    }
    
    private func addSwitch(_ dutyOff: Bool) {
        bottomView.removeSubviews()
        
        let toggle = UIView.initSwitch()
        bottomView.addSubview(toggle)
        toggle.left(constant: 1.5 * UIViewPadding.big).centerY().apply()
        toggle.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        
        toggle.onTintColor    = UIColor.colorPrimaryRedV2
        toggle.thumbTintColor = UIColor.colorPrimaryBlue
        
        toggle.isOn = dutyOff
        
        toggle.addTarget(self, action: #selector(switchStateChanged(sender:)), for: .valueChanged)
        
        let bottomContainerView = UIView.view()
        bottomView.addSubview(bottomContainerView)
        bottomContainerView.topbottom().right(of: toggle, constant: UIViewPadding.big).right(constant: UIViewPadding.big).apply()
        
        let descriptionLabel = UILabel.type2Label()
        bottomContainerView.addSubview(descriptionLabel)
        descriptionLabel.leftright().top(constant: UIViewPadding.small).apply()
        descriptionLabel.text = dutyOff ? String.YOU_ARE_OFF_DUTY : String.DEACTIVATE_CALL_ENTRY
        
        let infoLabel = UILabel.type2LightLabel(.callout)
        bottomContainerView.addSubview(infoLabel)
        infoLabel.leftright().bottom(constant: UIViewPadding.small, relatedBy: .lessThanOrEqual).bottom(of: descriptionLabel, constant: 0).apply()
        infoLabel.numberOfLines = 0
        infoLabel.minimumScaleFactor = 0.6
        infoLabel.text = String.DEACTIVATE_CALL_ENTRY_INFO

        
    }
    
    private func setTexts() {
        if let user = ERUser.current(), let state = self.state {
            switch state {
            case .active:
                statusLabel.text = String.ACTIVE_USER
                statusLabel.textColor = UIColor.positive
                addSwitch(user.dutyOff?.boolValue ?? false)
                break
            case .paused:
                //statusLabel.text = String.BEREITSCHAFTSPAUSE
                //button.setTitle("Register", for: UIControlState.normal)
                break
            case .notComplete:
                statusLabel.text = String.PROFILE_INCOMPLETE
                statusLabel.textColor = UIColor.colorPrimaryRedV2
                addButtonWith(text: String.GO_TO_PROFILE)
                break
            case .inactive:
                statusLabel.text = String.INACTIVE_USER
                statusLabel.textColor = UIColor.neutral
                addSwitch(user.dutyOff?.boolValue ?? false)
                break
            }
        } else {
            statusLabel.text = String.UNREGISTERED_USER
            statusLabel.textColor = UIColor.black
            addButtonWith(text: String.REGISTER)
        }
    }
    
    private func setUnfinishedProtocols(oldValue: Int?) {
        if oldValue == unfinishedProtocols { return }
        
        if reportView != nil {
            if let _ = ERUser.current() {
                UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { () -> Void in
                    self.reportView!.frame.origin.y += 50
                }, completion: { (_ : Bool) in
                    self.reportView?.removeFromSuperview()
                    if let count = self.unfinishedProtocols, count > 0 {
                        self.addReportView(withCount: count)
                    }
                })
            } else {
                self.reportView?.removeFromSuperview()
            }
        } else if let count = self.unfinishedProtocols, count > 0 {
            self.addReportView(withCount: count)
        }
        
    }
    
    private func reloadData() {
        ResponderStateManager.shared.getState(completion: { (state) in
            self.state = state
            self.setTexts()
        })
    }
    
    private func reloadEmergencies() {
        let runningEmergenciesCount = dataManager.runningEmergencyStates.count
        
        let acceptedState = dataManager.runningEmergencyStates.first(where: { $0.stateValue == .accepted })
        
        let runningState = acceptedState == nil ? dataManager.runningEmergencyStates.first : acceptedState
        
        if let state = self.state, state == .active || runningState?.emergencyRelation.testEmergencySendBy != nil {
            if runningEmergenciesCount > 0 {
                let vc = EREmergencyCallPageViewController()
                vc.emergencyState = runningState
                present(vc, animated: true, completion: nil)
            } else {
                presentMissedEmergencyViewController()
            }
        } else {
            if runningEmergenciesCount > 0 {
                let vc = ERMissedEmergencyProfileIncompleteViewController()
                vc.emergencyState = runningState
                present(vc, animated: true, completion: nil)
            }
        }
        
        
        self.unfinishedProtocols = dataManager.finishedExpiredEvaluationsWithProtocolNotDoneArray.count

    }
    
    private func presentMissedEmergencyViewController() {
        if dataManager.runningEmergencyStates.count == 0, !ERUserDefaultManager.userDefaultMissedEmergencyId.stringValue.isEmpty {
            let vc = ERMissedEmergencyViewController()
            dataManager.reloadMissedEmergencyState(objectId: ERUserDefaultManager.userDefaultMissedEmergencyId.stringValue) { (state, error) in
                if state?.stateValue == .received {
                    vc.emergencyState = state
                    self.present(vc, animated: true, completion: nil)
                } else {
                    ERUserDefaultManager.userDefaultMissedEmergencyId.stringValue = ""
                }
            }
        }
    }
    
    private func addReportView(withCount: Int) {
        
        //reportView = UIView(frame: CGRect(x: 0, y: mainContainerView.frame.height, width: view.frame.width, height: 50))
        reportView = UIView.view()
        self.mainContainerView.addSubview(reportView!)
        reportView!.leftright().bottom().height(constant: 50).apply()
        
        reportView!.backgroundColor = UIColor.white
        
        let seperatorView = UIView.seperatorView()
        reportView!.addSubview(seperatorView)
        seperatorView.leftright().bottom().height(constant: 1).apply()
        
        let imageView = UIImageView.imageView()
        reportView!.addSubview(imageView)
        imageView.centerY().left(constant: UIViewPadding.big).width(constant: 20).apply()
        imageView.image = UIImage.iconContract().imageWithColor(UIColor.colorPrimaryRedV2)
        
        let label = UILabel.type2LightLabel()
        reportView!.addSubview(label)
        label.right(of: imageView, constant: UIViewPadding.big).centerY().right().apply()
        label.text = withCount == 1 ? "\(withCount) \(String.REPORT_PENDING_TO_COMPLETE)" : "\(withCount) \(String.REPORTS_PENDING_TO_COMPLETE)"
        label.numberOfLines = 1
        
        let indicatorView = UIImageView.imageView()
        reportView!.addSubview(indicatorView)
        indicatorView.centerY().right(constant: UIViewPadding.big).width(constant: 15).widthEqualsHeight().apply()
        indicatorView.image = UIImage.iconBackLightGray()
        indicatorView.contentMode = .scaleAspectFit
        indicatorView.transform = indicatorView.transform.rotated(by: .pi)
        
        let reportViewTap = UITapGestureRecognizer(target: self, action: #selector(reportViewTapHandler(_:)))
        reportView!.addGestureRecognizer(reportViewTap)
        
        UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { () -> Void in
            self.reportView!.frame.origin.y -= 50
        })
        
    
    }
    
    // MARK: - Actions
    
    func didTapButton(sender: Any?) {
        if let _ = ERUser.current(){
            delegate?.changeViewController?(to: 6)
        } else {
            let vc = ERLoginPageViewController()
            present(vc, animated: true, completion: nil)
        }
    }
    
    func didTapSOS(sender: Any) {
        let vc = ERSOSCallPageViewController()
        self.present(vc, animated: true, completion: nil)
    }
    
    func switchStateChanged(sender: UISwitch) {
        //sender.thumbTintColor = sender.isOn ? UIColor.colorPrimaryRedV2  : UIColor.colorPrimaryBlueV2
        if let user = ERUser.current() {
            user.dutyOff = sender.isOn as NSNumber?
            user.saveInBackground(block: { (finished, error) in
                if finished {
                    self.reloadData()
                }
            })
        }
    }
    
    func reportViewTapHandler(_ sender: UITapGestureRecognizer) {
        /*let vc = ERFinalStepViewController()
        vc.delegate = self
        vc.topTitleLabel.text    = "Patient report"
        vc.titleLabel.text       = "Thank you very much for your help."
        vc.descriptionLabel.text = "After taking the emergency call, we will ask you to complete a patient report."
        vc.mainButton.setTitle("Fill report", for: .normal)
        vc.secondaryButton.setTitle("Fill report later", for: .normal)
        vc.isSecondaryButton = true
        vc.titleImage.image = UIImage.iconContract()
        present(vc, animated: true, completion: nil)*/
        
        let vc = ERProtocolOverviewTableViewController()
        vc.emergencyStates = dataManager.finishedExpiredEvaluationsWithProtocolNotDoneArray
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - ERDataManagerDelegate
    
    func dataManagerDidUpdateEmergencyStates(dataManager: ERDataManager, error: Error?) {
        if let _ = ERUser.current() {
            reloadEmergencies()
        }
    }
    
    
}

private class StartControllerQueueManager: NSObject {
    
    class func presentIfFirstTime(parentViewController: UIViewController) {
        
        if UserDefault.isFirstTimeNotificationAuthorization.boolValue {
            UserDefault.isFirstTimeNotificationAuthorization.boolValue = false
            NotificationTransition.present(from: parentViewController, to: NotificationAuthorizationViewController(accessLevel: .guest).pack())
            
        } else if UserDefault.isFirstTimeLocationAuthorization.boolValue {
            UserDefault.isFirstTimeLocationAuthorization.boolValue = false
            NotificationTransition.present(from: parentViewController, to: LocationAuthorizationViewController(accessLevel: .guest).pack())
        }
    }
    
}
