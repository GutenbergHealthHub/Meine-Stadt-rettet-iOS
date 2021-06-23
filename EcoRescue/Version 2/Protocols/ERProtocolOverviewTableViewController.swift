//
//  ERProtocolOverviewTableViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 27.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit

class ERProtocolOverviewTableViewController: UIViewController, UCTableViewDataSource, UCTableViewDelegate {
    
    private let tableView = UCTableView(style: .plain)
    
    private var alertController: ERAlertV2ViewController?
    
    var emergencyStates = [EREmergencyState]()
    
    var acceptedStateIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        view.addSubview(tableView)
        tableView.match().apply()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerClass(ERProtocolOverviewTableViewCell.self, forCellReuseIdentifier: ERProtocolOverviewTableViewCell.id)

    }
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return emergencyStates.count
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ERProtocolOverviewTableViewCell.id) as! ERProtocolOverviewTableViewCell
        cell.emergencyState = emergencyStates[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if emergencyStates[indexPath.row].stateValue == .finished {
            let protocolFinishedVC = ERProtocolFinishPageViewController()
            protocolFinishedVC.emergencyState = emergencyStates[indexPath.row]
            self.present(UINavigationController(rootViewController: protocolFinishedVC), animated: true, completion: nil)
        } else if emergencyStates[indexPath.row].stateValue == .cancelled {
            let protocolFinishedVC = ERProtocolCancelPageViewController()
            protocolFinishedVC.emergencyState = emergencyStates[indexPath.row]
            self.present(UINavigationController(rootViewController: protocolFinishedVC), animated: true, completion: nil)
        } else if emergencyStates[indexPath.row].stateValue == .accepted {
            self.acceptedStateIndex = indexPath.row
            presentAlertView()
        }
    }
    
    private func presentAlertView() {
        alertController = ERAlertV2ViewController()
        alertController?.alertLabel.textColor = .white
        alertController?.alertLabel.text = String.FINISH_EMERGENCY_REASON
        
        let btn1 = UIButton.button()
        btn1.backgroundColor = UIColor.clear
        btn1.layer.cornerRadius = 5
        btn1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn1.setTitle(String.PATIENT_REACHED, for: .normal)
        btn1.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn1.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn1.layer.borderColor = UIColor.white.cgColor
        btn1.layer.borderWidth = 2
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(didTapPatientReached(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn1)
        
        let btn2 = UIButton.button()
        btn2.layer.cornerRadius = 5
        btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn2.setTitle(String.CANCEL_EMERGENCY, for: .normal)
        btn2.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn2.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn2.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderWidth = 2
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.addTarget(self, action: #selector(didTapCancel(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn2)
        
        let btn3 = UIButton.button()
        btn3.layer.cornerRadius = 5
        btn3.setTitle(String.BACK, for: .normal)
        btn3.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn3.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn3.layer.borderColor = UIColor.white.cgColor
        btn3.layer.borderWidth = 2
        btn3.addTarget(self, action: #selector(didTapBack(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn3)
        
        alertController!.providesPresentationContextTransitionStyle = true
        alertController!.definesPresentationContext = true
        alertController!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertController!, animated: true, completion: nil)
    }
    
    private func dismissAlertController() {
        if let vc = alertController {
            vc.dismiss(animated: true, completion: nil)
            alertController = nil
        }
    }
    
    // MARK: Actions
    
    func didTapBack(sender: Any) {
        self.dismissAlertController()
    }
    
    func didTapPatientReached(sender: Any) {
        self.dismissAlertController()
        
        if let index = acceptedStateIndex{
            emergencyStates[index].stateValue = .finished
            emergencyStates[index].saveInBackground()
        }
        
        self.tableView.reloadData()
    }
    
    func didTapCancel(sender: Any) {
        self.dismissAlertController()
        
        if let index = acceptedStateIndex {
            emergencyStates[index].stateValue = .cancelled
            emergencyStates[index].saveInBackground()
        }
        
        self.tableView.reloadData()
    }

}
