//
//  ERProtocolFinishPageViewController.swift
//  EcoRescue
//
//  Created by Birtan on 09.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolFinishPageViewController: StepsPageViewController, ERFinalStepViewControllerDelegate {
    
    private let arrivedAtPage        = ERProtocolArrivedAtViewController()
    private let arrivalTimePage      = ERProtocolArrivalTimeViewController()
    private let agePage              = ERProtocolAgeViewController()
    private let sexPage              = ERProtocolSexViewController()
    private let resuscitationPage    = ERProtocolResuscitationViewController()
    private let locationPage         = ERProtocolLocationViewController()
    private let schoolBuildingPage   = ERProtocolSchoolBuildingViewController()
    private let startDiagnosisPage   = ERProtocolStartDiagnosisViewController()
    private let startOrientationPage = ERProtocolStartOrientationViewController()
    private let consciousnessPage    = ERProtocolConsciousnessViewController()
    private let startBreathingPage   = ERProtocolStartBreathingViewController()
    private let sportstRelationPage  = ERProtocolSportsRelationViewController()
    private let collapseObservedPage = ERProtocolCollapseObservedViewController()
    private let cardiacMassagePage   = ERProtocolCardiacMassageViewController()
    private let ventilationPage      = ERProtocolVentilationViewController()
    private let telemedicinePage     = ERProtocolTelemedicineViewController()
    private let defiPage             = ERProtocolDefiViewController()
    private let defi2Page            = ERProtocolDefi2ViewController()
    private let defi3Page            = ERProtocolDefi3ViewController()
    private let defi4Page            = ERProtocolDefi4ViewController()
    private let endConsciousnessPage = ERProtocolEndConsciousnessViewController()
    private let endBreathingPage     = ERProtocolEndBreathingViewController()
    private let remarksPage          = ERProtocolRemarksViewController()
    
    private var alertController: ERAlertV2ViewController?
    
    var emergencyState: EREmergencyState? { didSet { setEmergencyState(oldValue: oldValue) } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.colorPrimaryBlue
        self.navigationController?.navigationBar.shadowImage = UIColor.white.as1ptImage()
        
        let saveButton = UIButton(type: .custom)
        saveButton.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.white.cgColor
        saveButton.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        saveButton.titleLabel?.adjustsFontSizeToFitWidth = true
        saveButton.setTitle(String.SAVE.lowercased(), for: .normal)
        saveButton.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        saveButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        saveButton.addTarget(self, action: #selector(didTapSave(sender:)), for: .touchDown)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        let label = UILabel.type1Label()
        label.text = String.PATIENT_REPORT_PROTOCOLS
        label.textColor = UIColor.white
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: label)
        
        addPages()
        
        
        
    }
    
    private func addPages() {
        
        if emergencyState?.arrivedAt == nil {
            pages = [arrivedAtPage, arrivalTimePage, agePage, sexPage, resuscitationPage, locationPage, schoolBuildingPage, startDiagnosisPage, startOrientationPage, consciousnessPage, startBreathingPage, sportstRelationPage, collapseObservedPage, cardiacMassagePage, ventilationPage, telemedicinePage, defiPage, defi2Page, defi3Page, defi4Page, endConsciousnessPage, endBreathingPage, remarksPage]
            arrivedAtPage.backButton.isHidden = true
        } else {
            pages = [arrivalTimePage, agePage, sexPage, resuscitationPage, locationPage, schoolBuildingPage, startDiagnosisPage, startOrientationPage, consciousnessPage, startBreathingPage, sportstRelationPage, collapseObservedPage, cardiacMassagePage, ventilationPage, telemedicinePage, defiPage, defi2Page, defi3Page, defi4Page, endConsciousnessPage, endBreathingPage, remarksPage]
            arrivalTimePage.backButton.isHidden = true
        }
        
        remarksPage.nextButton.isHidden     = true
        
        updateSteps()
    }
    
    private func setPageViews() {
        for (index, vc) in pages.enumerated() {
            (vc as! StepsViewController).delegate = self
            (vc as! StepsViewController).setProgressViews(progress: Float(index+1)/Float(pages.count))
            (vc as! StepsViewController).progressLabel.text = "\(index+1)/\(pages.count)"
        }
    }
    
    private func setEmergencyState(oldValue: EREmergencyState?) {
        if oldValue == emergencyState { return }
        
        if emergencyState?.arrivedAt == nil, let acceptedAt = emergencyState?.acceptedAt, let endedAt = emergencyState?.endedAt {
            arrivedAtPage.acceptedAt = acceptedAt
            arrivedAtPage.endedAt   = endedAt
        }
        
        if let prot = emergencyState?.protocolRelation {
            
            arrivalTimePage.later = prot.startLaterRelAmbulance?.boolValue
            arrivalTimePage.time  = prot.startMinutesRelAmbulance?.intValue
            
            agePage.age = prot.age?.intValue
            agePage.ageCategory = prot.ageCategory?.intValue
            
            sexPage.sex = prot.sex
            
            resuscitationPage.setSelectedTextWithKey(prot.reanimationValue)
            
            locationPage.setSelectedTextWithKey(prot.startLocationValueN)
            
            schoolBuildingPage.setSelectedTextWithKey(prot.schoolBuilding)
            
            startDiagnosisPage.setSelectedTextWithKeys(prot.startDiagnoseValue)
            
            startOrientationPage.setSelectedTextWithKey(prot.startOrientationValueN)
            
            consciousnessPage.setSelectedTextWithKeys(prot.startReactionValue)
            
            startBreathingPage.setSelectedTextWithKeys(prot.startRespirationValue)
            
            sportstRelationPage.setSelectedTextWithKey(prot.relationWithSport)
            
            collapseObservedPage.setSelectedTextWithKey(prot.collapseObserved)
            
            cardiacMassagePage.setSelectedTextWithKey(prot.measureChestCompressionValueN)
            
            ventilationPage.setSelectedTextWithKey(prot.measureRespirationValue)
            
            telemedicinePage.setSelectedTextWithKey(prot.telemedicin)
            
            defiPage.setSelectedTextWithKey(prot.measureDefiValueN)
            
            defi2Page.setSelectedTextWithKey(prot.measureDefiShockCount)
            
            defi3Page.setSelectedTextWithKey(prot.producerDefiValue)
            
            defi4Page.setSelectedTextWithKey(prot.publicDefi)
            
            endConsciousnessPage.setSelectedTextWithKeys(prot.endStatusA)
            
            endBreathingPage.setSelectedTextWithKeys(prot.endRespirationValue)
            
            remarksPage.textView.text = prot.endComment
            
        } else {
            
            arrivalTimePage.later = false
            arrivalTimePage.time  = 3
            
            agePage.age = 30
            agePage.ageCategory = 4
            
            resuscitationPage.setSelectedTextWithKey(99)
            
            locationPage.setSelectedTextWithKey(0)
            
            schoolBuildingPage.setSelectedTextWithKey(0)
            
            startDiagnosisPage.setSelectedTextWithKeys([99])
            
            startOrientationPage.setSelectedTextWithKey(99)
            
            consciousnessPage.setSelectedTextWithKeys([0])
            
            startBreathingPage.setSelectedTextWithKeys([0])
            
            sportstRelationPage.setSelectedTextWithKey(0)
            
            collapseObservedPage.setSelectedTextWithKey(99)
            
            cardiacMassagePage.setSelectedTextWithKey(98)
            
            ventilationPage.setSelectedTextWithKey(98)
            
            telemedicinePage.setSelectedTextWithKey(0)
            
            defiPage.setSelectedTextWithKey(98)
            
            defi2Page.setSelectedTextWithKey(0)
            
            defi3Page.setSelectedTextWithKey(0)
            
            endConsciousnessPage.setSelectedTextWithKeys([0])
            
            endBreathingPage.setSelectedTextWithKeys([0])
            
            
        }
        
    }
    
    
    private func saveProtocol(done: Bool) {
        guard let emergencyState = emergencyState else {
            return
        }
        
        var prot: ERProtocol! = emergencyState.protocolRelation
        if prot == nil {
            prot = ERProtocol()
            prot.isDone = false
            
            emergencyState.protocolRelation = prot
        }
        
        if emergencyState.arrivedAt == nil {
            emergencyState.arrivedAt = arrivedAtPage.arrivedAt
        }
        
        prot.startLaterRelAmbulance   = arrivalTimePage.later as NSNumber?
        prot.startMinutesRelAmbulance = arrivalTimePage.time  as NSNumber?
        
        prot.age = agePage.age as NSNumber?
        prot.ageCategory = agePage.ageCategory as NSNumber?
        
        prot.sex = sexPage.sex
        
        prot.reanimationValue = resuscitationPage.selectedItem?.key as NSNumber?
        
        prot.startLocationValueN = locationPage.selectedItem?.key as NSNumber?
        
        prot.schoolBuilding = schoolBuildingPage.getResult() as NSNumber?
        
        prot.startDiagnoseValue = ERReportData.keys(startDiagnosisPage.selectedItems) as NSArray?
        
        prot.startOrientationValueN = (startOrientationPage.selectedItem?.key as NSNumber?) ?? 99 as NSNumber
        
        prot.startReactionValue = ERReportData.keys(consciousnessPage.selectedItems) as NSArray?
        
        prot.startRespirationValue = ERReportData.keys(startBreathingPage.selectedItems) as NSArray?
        
        prot.relationWithSport = sportstRelationPage.getResult() as NSNumber?
        
        prot.collapseObserved = (collapseObservedPage.selectedItem?.key as NSNumber?) ?? 99 as NSNumber
        
        prot.measureChestCompressionValueN = (cardiacMassagePage.selectedItem?.key as NSNumber?) ?? 98 as NSNumber
        
        prot.measureRespirationValue = (ventilationPage.selectedItem?.key as NSNumber?) ?? 98 as NSNumber
        
        prot.telemedicin = telemedicinePage.getResult() as NSNumber?
        
        prot.measureDefiValueN = (defiPage.selectedItem?.key as NSNumber?) ?? 98 as NSNumber
        
        prot.measureDefiShockCount = (defi2Page.selectedItem?.key as NSNumber?) ?? 99 as NSNumber
        
        prot.producerDefiValue = (defi3Page.selectedItem?.key as NSNumber?) ?? 99 as NSNumber
        
        prot.publicDefi = defi4Page.getResult() as NSNumber?
        
        prot.endStatusA = ERReportData.keys(endConsciousnessPage.selectedItems) as NSArray?
        
        prot.endRespirationValue = ERReportData.keys(endBreathingPage.selectedItems) as NSArray?
        
        prot.isDone = done
        
        prot.endComment = remarksPage.textView.text
        
        emergencyState.saveInBackground()
    }
    
    private func dismissAlertController() {
        if let vc = alertController {
            vc.dismiss(animated: true, completion: nil)
            alertController = nil
        }
    }
    
    // MARK: Actions
    
    func didTapSave(sender: Any) {
        saveProtocol(done: false)
        
        alertController = ERAlertV2ViewController()
        
        alertController?.alertLabel.text = String.REPORT_SAVE_ALERT
        alertController?.alertLabel.textColor = UIColor.white
        
        let btn1 = UIButton.button()
        btn1.backgroundColor = UIColor.clear
        btn1.layer.cornerRadius = 5
        btn1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn1.setTitle(String.CONTINUE_FILLING_REPORT, for: .normal)
        btn1.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn1.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn1.layer.borderColor = UIColor.white.cgColor
        btn1.layer.borderWidth = 2
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(didTapContinue(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn1)
        
        let btn2 = UIButton.button()
        btn2.layer.cornerRadius = 5
        btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn2.setTitle(String.GO_TO_HOME_PAGE, for: .normal)
        btn2.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn2.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn2.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderWidth = 2
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.addTarget(self, action: #selector(didTapGoHome(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn2)
        
        alertController!.providesPresentationContextTransitionStyle = true
        alertController!.definesPresentationContext = true
        alertController!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func didTapContinue(sender: Any) {
        dismissAlertController()
    }
    
    func didTapGoHome(sender: Any) {
        dismissAlertController()
        self.dismiss(animated: true, completion: {
            if let vcs = AppDelegate.topViewController?.childViewControllers{
                for vc in vcs {
                    if vc is UINavigationController {
                        (vc as! UINavigationController).popToRootViewController(animated: true)
                    }
                }
            }
            })
    }
    
    // MARK: StepsPageViewController functions
    
    override func goNextStep() {
        updateSteps()
        super.goNextStep()
    }
    
    override func goPreviousStep() {
        updateSteps()
        super.goPreviousStep()
    }
    
    override func finalizeSteps() {
        saveProtocol(done: true)
        
        let vcFinal = ERFinalStepViewController()
        vcFinal.delegate = self
        vcFinal.topTitleLabel.text    = String.PATIENT_REPORT_PROTOCOLS
        vcFinal.topTitleLabel.textColor = .white
        vcFinal.titleLabel.text       = String.REPORT_SUCCESS_TITLE
        vcFinal.descriptionLabel.text = String.REPORT_SUCCESS_DESCRIPTION
        vcFinal.mainButton.setTitle(String.GO_TO_HOME_PAGE, for: .normal)
        vcFinal.titleImage.image = UIImage.iconTickWhite().imageWithColor(UIColor.black)
        
        present(vcFinal, animated: true, completion: nil)
    }
    
    private func updateSteps() {
        if defiPage.wasDefiUsed {
            if !contains(defi2Page) {
                insert(defi2Page, after: defiPage)
            }
            if !contains(defi3Page) {
                insert(defi3Page, after: defi2Page)
            }
            if !contains(defi4Page) {
                insert(defi4Page, after: defi3Page)
            }
        } else {
            if contains(defi2Page) {
                remove(defi2Page)
            }
            if contains(defi3Page) {
                remove(defi3Page)
            }
            if contains(defi4Page) {
                remove(defi4Page)
            }
        }
        setPageViews()
    }
    
    //MARK: ERFinalStepViewControllerDelegate
    func tapped(mainButton: Bool) {
        self.dismiss(animated: true, completion: {
            if let vcs = AppDelegate.topViewController?.childViewControllers{
                for vc in vcs {
                    if vc is UINavigationController {
                        (vc as! UINavigationController).popToRootViewController(animated: true)
                    }
                }
            }
        })
    }


}
