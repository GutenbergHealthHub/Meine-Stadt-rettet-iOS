//
//  EREventsV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 15.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class EREventsV2ViewController: CenterMenuViewController, ERDataManagerDelegate, UCTableViewDataSource, UCTableViewDelegate {
    
    private let kHeaderHeight: CGFloat = 250

    private let dataManager    = ERDataManager.sharedManager
    
    private let tableView      = UCTableView(style: .plain)
    
    private let emptyViewEvents  = ERDefaultEmptyView()
    
    private let refreshControl = UIView.initRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.EVENTS
        view.backgroundColor = UIColor.background
        
        view.addSubview(tableView)
        tableView.match().apply()
        
        // Refresh Control
        refreshControl.addTarget(self, action: #selector(didChangeValue(sender:)), for: .valueChanged)
        
        tableView.delegate       = self
        tableView.dataSource     = self
        tableView.refreshControl = refreshControl
        
        tableView.registerClass(EREventsTableViewCell.self, forCellReuseIdentifier: kEREventsTableViewCell)
        tableView.registerClass(EREventsHeaderTableViewCell.self, forCellReuseIdentifier: kEREventsHeaderTableViewCell)
        
        // Empty View
        emptyViewEvents.icon      = UIImage.iconChatBubblesSelected()
        emptyViewEvents.title     = String.EVENTS
        emptyViewEvents.subtitle  = String.CURRENTLY_NO_EVENT
        
        tableView.emptyView             = emptyViewEvents
        
        dataManager.findEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.addObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.removeObserver(self)
    }
    
    func didChangeValue(sender: AnyObject) {
        dataManager.findEvents()
    }
    
    func reloadData() {
        if !dataManager.isLoadingNews {
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    // MARK: Table View
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.events.count
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(kEREventsHeaderTableViewCell) as! EREventsHeaderTableViewCell
            cell.event = dataManager.events[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(kEREventsTableViewCell) as! EREventsTableViewCell
            cell.event = dataManager.events[indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UCTableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return kHeaderHeight
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let viewController = EREventsV2DetailViewController()
        viewController.event = dataManager.events[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - ERDataManagerDelegate
    
    func dataManagerDidEndLoadEvents(dataManager: ERDataManager, events: [EREvent]?, error: Error?) {
        reloadData()
    }

}
