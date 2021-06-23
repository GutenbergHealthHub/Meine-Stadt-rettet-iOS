//
//  ERMapV2TableViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 08.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit

class ERMapV2FilterTableViewController: UIViewController, UCTableViewDataSource, UCTableViewDelegate {
    
    private let tableView = UCTableView(style: .grouped)
    
    private let defibrillatorCell = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let hospitalCell      = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let firehouseCell     = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let doctorCell        = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let dentistCell       = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let pharmacyCell      = UITableViewCell(style: .default, reuseIdentifier: nil)
    
    private var tableViewCells = [UITableViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        self.view.backgroundColor = UIColor.background
        self.view.addSubview(tableView)

        tableView.top(constant: UIViewPadding.big).leftright().bottom().apply()
        
        tableView.dataSource    = self
        tableView.delegate      = self
        
        tableView.scrollEnabled = false
        tableView.rowHeight     = UIViewRowHeight.small
        
        defibrillatorCell.textLabel?.text   = String.DEFIBRILLATOR
        defibrillatorCell.imageView?.image  = UIImage.iconMapDefibrillatorV2()
        tableViewCells.append(defibrillatorCell)
        
        hospitalCell.textLabel?.text        = String.HOSPITAL
        hospitalCell.imageView?.image       = UIImage.iconHospitalV2()
        tableViewCells.append(hospitalCell)
        
        firehouseCell.textLabel?.text       = String.FIRE_DEPARTMENT
        firehouseCell.imageView?.image      = UIImage.iconFireStationV2()
        tableViewCells.append(firehouseCell)
        
        doctorCell.textLabel?.text          = String.DOCTOR
        doctorCell.imageView?.image         = UIImage.iconDoctorV2()
        tableViewCells.append(doctorCell)
        
        dentistCell.textLabel?.text         = String.DENTIST
        dentistCell.imageView?.image        = UIImage.iconDentistV2()
        tableViewCells.append(dentistCell)
        
        pharmacyCell.textLabel?.text        = String.PHARMACY
        pharmacyCell.imageView?.image       = UIImage.iconPharmacyV2()
        tableViewCells.append(pharmacyCell)
        
        reloadData()
    }
    
    private func reloadData() {
        defibrillatorCell.accessoryType = ERUserDefaultManager.userDefaultMapShowDefi.boolValue ? .checkmark : .none
        hospitalCell.accessoryType     = ERUserDefaultManager.userDefaultMapShowHospitals.boolValue ? .checkmark : .none
        firehouseCell.accessoryType    = ERUserDefaultManager.userDefaultMapShowFirehouses.boolValue ? .checkmark : .none
        doctorCell.accessoryType       = ERUserDefaultManager.userDefaultMapShowDoctors.boolValue ? .checkmark : .none
        dentistCell.accessoryType      = ERUserDefaultManager.userDefaultMapShowDentists.boolValue ? .checkmark : .none
        pharmacyCell.accessoryType    = ERUserDefaultManager.userDefaultMapShowPharmacies.boolValue ? .checkmark : .none
    }
    
    // MARK: - UCTableViewDataSource
    
    func tableView(tableView: UCTableView, titleForHeaderInSection section: Int) -> String? {
        return String.FILTER_ANNOTATIONS
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return tableViewCells[indexPath.row]
    }
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(tableView: UCTableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UCTableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIViewRowHeight.tiny
    }
    
    // MARK: - UCTableViewDelegate
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {

        switch indexPath.row {
            case 0: ERUserDefaultManager.userDefaultMapShowDefi.toggle();       break
            case 1: ERUserDefaultManager.userDefaultMapShowHospitals.toggle();  break
            case 2: ERUserDefaultManager.userDefaultMapShowFirehouses.toggle(); break
            case 3: ERUserDefaultManager.userDefaultMapShowDoctors.toggle();    break
            case 4: ERUserDefaultManager.userDefaultMapShowDentists.toggle();   break
            case 5: ERUserDefaultManager.userDefaultMapShowPharmacies.toggle(); break
            default: break
        }
        
        reloadData()
    }


}
