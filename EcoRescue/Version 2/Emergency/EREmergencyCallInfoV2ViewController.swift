//
//  EREmergencyCallInfoV2ViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 18.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class EREmergencyCallInfoV2ViewController: EREmergencyCallStepViewController {
    
    private let tableView = FixedTableView(style: .grouped)
    
    private let titleCellFR           = TitleTableViewCell()
    private let nameCellFR            = InfoUserImageTableViewCell()
    private let addressCellFR         = TitleDetailTableViewCell()
    private let jobCellFR             = TitleDetailTableViewCell()
    private let qualificationCellFR   = TitleDetailTableViewCell()
    private let idCellFR              = TitleDetailTableViewCell()
    private let emergencyNumberCellFR = TitleDetailTableViewCell()
    
    private let titleCellControl      = TitleTableViewCell()
    private let nameCellControl       = TitleDetailTableViewCell()
    private let addressCellControl    = TitleDetailTableViewCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        
        // topView
        let topView = UIView.view()
        view.addSubview(topView)
        topView.top().leftright().height(constant: 44 + statusBarHeight).apply()
        topView.backgroundColor = UIColor.colorPrimaryBlue
        
        // topView - backButton
        let backButton = UIButton.button()
        topView.addSubview(backButton)
        backButton.bottom(constant: UIViewPadding.medium).left(constant: UIViewPadding.small).widthEqualsHeight().width(constant: 25).apply()
        backButton.setImage(UIImage.iconBackWhite(), for: .normal)
        backButton.tintColor = UIColor.white
        backButton.addTarget(self, action: #selector(didTapBack(sender:)), for: .touchDown)
        
        view.addSubview(tableView)
        tableView.bottom(of: topView, constant: 0).leftright().bottom().apply()
        
        titleCellFR.title = String.FIRST_RESPONDER
        titleCellFR.isUserInteractionEnabled = false
        
        nameCellFR.name  = emergencyState?.userRelation.formattedName
        nameCellFR.email = emergencyState?.userRelation.username
        
        addressCellFR.title    = String.ADDRESS
        addressCellFR.subtitle = emergencyState?.userRelation.address.addressLinesString
        addressCellFR.subtitleNumberOfLines = 0
        addressCellFR.isUserInteractionEnabled = false
        
        jobCellFR.title    = String.JOB
        jobCellFR.subtitle = emergencyState?.userRelation.profession
        jobCellFR.isUserInteractionEnabled = false
        
        qualificationCellFR.title    = String.QUALIFICATION
        qualificationCellFR.subtitle = emergencyState?.userRelation.qualificationValue
        qualificationCellFR.isUserInteractionEnabled = false
        
        idCellFR.title    = String.PROFILE_ID
        idCellFR.subtitle = emergencyState?.userRelation.objectId
        idCellFR.isUserInteractionEnabled = false
        
        emergencyNumberCellFR.title    = String.EMERGENCY_NUMBER
        emergencyNumberCellFR.subtitle = emergencyState?.emergencyRelation.emergencyNumberDC
        emergencyNumberCellFR.isUserInteractionEnabled = false
        
        let sectionFR = FixedTableViewSection()
        sectionFR.tableViewCells = [(titleCellFR, nil), (nameCellFR, nil), (addressCellFR, nil), (jobCellFR, nil), (qualificationCellFR, nil), (idCellFR, nil), (emergencyNumberCellFR, nil)]
        
        titleCellControl.title = String.CONTROL_CENTER
        titleCellControl.isUserInteractionEnabled = false
        
        nameCellControl.title = String.EMERGENCY_NAME
        nameCellControl.subtitle = emergencyState?.emergencyRelation.controlCenterRelation?.name
        nameCellControl.isUserInteractionEnabled = false
        
        addressCellControl.title = String.ADDRESS
        addressCellControl.subtitle = String(format: "%@ %@", emergencyState?.emergencyRelation.controlCenterRelation?.formattedStreet ?? "", emergencyState?.emergencyRelation.controlCenterRelation?.formattedCity ?? String.UNKNOWN)
        addressCellControl.subtitleNumberOfLines = 0
        addressCellControl.isUserInteractionEnabled = false
        
        let sectionControlCenter = FixedTableViewSection()
        sectionControlCenter.tableViewCells = [(titleCellControl, nil), (nameCellControl, nil), (addressCellControl, nil)]
        
        tableView.sections = [sectionFR, sectionControlCenter]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
    }
    
    func didTapBack(sender: Any) {
        delegate?.goPreviousStep()
    }

}
