//
//  ERMapV2DefibrillatorsViewController.swift
//  EcoRescue
//
//  Created by Birtan on 10.09.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import MapKit

class ERMapV2DefibrillatorsViewController: UIViewController, MKMapViewDelegate, UCTableViewDataSource, UCTableViewDelegate {
    
    var userDefibrillators = [ERDefibrillator]()
    
    private let emptyView = ERDefaultEmptyView()
    
    private let tableView = UCTableView(style: .grouped)
    
    private let addButton = ERButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        view.backgroundColor = UIColor.background
        title = String.DEFIBRILLATORS
        
        //topView
        let topView = UIView.view()
        view.addSubview(topView)
        topView.leftright().top().height(multiplier: 0.1).apply()
        topView.backgroundColor = UIColor.colorPrimaryBlue
        
        //topView - titleLabel
        let titleLabel = UILabel.type2SemiBoldLabel()
        topView.addSubview(titleLabel)
        titleLabel.centerY().left(constant: UIViewPadding.big).apply()
        titleLabel.text = String.YOUR_ADDED_DEFIBRILLATORS
        titleLabel.textColor = UIColor.white
        
        //addButton
        view.addSubview(addButton)
        addButton.bottom(constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).height(constant: 44).apply()
        addButton.text = String.ADD_NEW_DEFIBRILLATOR
        addButton.addTarget(self, action: #selector(didTapAddNew(sender:)), for: .touchDown)
        
        //tableView
        view.addSubview(tableView)
        tableView.leftright().bottom(of: topView, constant: 0).top(of: addButton, constant: UIViewPadding.big).apply()
        
        tableView.dataSource        = self
        tableView.delegate          = self
        
        tableView.estimatedRowHeight = UIViewRowHeight.large
        tableView.registerClass(ERMapV2DefibrillatorsTableViewCell.self, forCellReuseIdentifier: kERMapV2DefibrillatorsTableViewCell)
        
        // Empty Views
        emptyView.icon      = UIImage.iconDefiGray()
        emptyView.title     = String.DEFIBRILLATOR
        emptyView.subtitle  = String.USER_DEFIBRILLATOR_EMPTY_VIEW_SUBTITLE
        
        tableView.emptyView = emptyView
        
        //tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ERCommunicationManager.sharedManager.findUserDefibrillators{ (defibrillators, error) in
            
            if let error = error {
                
            }
            
            if let defibrillators = defibrillators {
                self.userDefibrillators = defibrillators
                self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(kERMapV2DefibrillatorsTableViewCell) as! ERMapV2DefibrillatorsTableViewCell
        cell.defibrillator = userDefibrillators[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return userDefibrillators.count
    }
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let vc = ERMapV2AddDefibrillatorViewController()
        vc.defibrillator = userDefibrillators[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapAddNew(sender: Any) {
        let addDefibrillatorViewController = ERMapV2AddDefibrillatorViewController()
        self.navigationController?.pushViewController(addDefibrillatorViewController, animated: true)
        
    }


}
