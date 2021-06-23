//
//  ERNewsAndEventsViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 14.01.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit

private enum ERNewsEventsViewControllerType {
    case news, events
}

class ERNewsAndEventsV2ViewController: CenterMenuViewController, ERDataManagerDelegate, UCTableViewDataSource, UCTableViewDelegate {
    
    private var type = ERNewsEventsViewControllerType.news { didSet { setType(oldValue: oldValue) } }
    
    private let kHeaderHeight: CGFloat = 250
    
    private let dataManager    = ERDataManager.sharedManager
    
    private let segmentedControl    = UISegmentedControl(items: [String.NEWS, String.EVENTS])
    private let tableView           = UCTableView(style: .plain)
    
    private let emptyViewNews       = ERDefaultEmptyView()
    private let emptyViewEvents     = ERDefaultEmptyView()
    
    private let refreshControl      = UIView.initRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.titleView = segmentedControl
        view.backgroundColor = UIColor.background
        
        view.addSubview(tableView)
        tableView.match().apply()
        
        // Refresh Control
        refreshControl.addTarget(self, action: #selector(didChangeValue(sender:)), for: .valueChanged)
        
        tableView.registerClass(ERNewsTableViewCell.self, forCellReuseIdentifier: kERNewsTableViewCell)
        tableView.registerClass(ERNewsHeaderTableViewCell.self, forCellReuseIdentifier: kERNewsHeaderTableViewCell)
        
        tableView.registerClass(EREventsTableViewCell.self, forCellReuseIdentifier: kEREventsTableViewCell)
        tableView.registerClass(EREventsHeaderTableViewCell.self, forCellReuseIdentifier: kEREventsHeaderTableViewCell)
        
        tableView.refreshControl    = refreshControl
        tableView.dataSource        = self
        tableView.delegate          = self
        
        // Empty Views
        emptyViewNews.icon      = UIImage.iconBoxSelected()
        emptyViewNews.title     = String.NEWS
        emptyViewNews.subtitle  = String.CURRENTLY_NO_NEWS
        
        emptyViewEvents.icon      = UIImage.iconChatBubblesSelected()
        emptyViewEvents.title     = String.EVENTS
        emptyViewEvents.subtitle  = String.CURRENTLY_NO_EVENT
        
        // Toolbar
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(didChangeType(sender:)), for: .valueChanged)
        
        setType()
        
        loadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.addObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.removeObserver(self)
    }
    
    // MARK: - Private Methods
    
    private func setType(oldValue: ERNewsEventsViewControllerType) {
        if type == oldValue { return }
        setType()
    }
    
    private func setType() {
        switch type {
        case .news:
            tableView.emptyView = emptyViewNews
            break
            
        case .events:
            tableView.emptyView = emptyViewEvents
            break
        }
    }
    
    private func loadData() {
        dataManager.findEvents()
        dataManager.findNews()
    }
    
    private func reloadData() {
        if !dataManager.isLoadingNews && !dataManager.isLoadingEvents {
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    // MARK: - Actions
    
    func didChangeType(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: type = .news;   break
        case 1: type = .events; break
        default: break
        }
        
        reloadData()
    }
    
    func didChangeValue(sender: AnyObject) {
        loadData()
    }
    
    // MARK: Table View
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        switch type {
        case .news:     return dataManager.news.count
        case .events:   return dataManager.events.count
        }
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        switch type {
        case .news:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier(kERNewsHeaderTableViewCell) as! ERNewsHeaderTableViewCell
                cell.news = dataManager.news[indexPath.row]
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(kERNewsTableViewCell) as! ERNewsTableViewCell
                cell.news = dataManager.news[indexPath.row]
                return cell
            }
        case .events:
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
        
    }
    
    func tableView(tableView: UCTableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return kHeaderHeight
        }
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        switch type {
        case .news:
            let viewController = ERNewsV2DetailViewController()
            viewController.news = dataManager.news[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        case .events:
            let viewController = EREventsV2DetailViewController()
            viewController.event = dataManager.events[indexPath.row]
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    // MARK: - ERDataManagerDelegate
    
    func dataManagerDidEndLoadNews(dataManager: ERDataManager, news: [ERNews]?, error: Error?) {
        reloadData()
    }
    
    func dataManagerDidEndLoadEvents(dataManager: ERDataManager, events: [EREvent]?, error: Error?) {
        reloadData()
    }

}
