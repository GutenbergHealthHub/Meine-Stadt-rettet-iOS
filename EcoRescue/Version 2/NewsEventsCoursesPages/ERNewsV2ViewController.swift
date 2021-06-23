//
//  ERNewsEventsV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 14.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class ERNewsV2ViewController: CenterMenuViewController, ERDataManagerDelegate, UCTableViewDataSource, UCTableViewDelegate {
    
    private let kHeaderHeight: CGFloat = 250
    
    private let dataManager    = ERDataManager.sharedManager
    
    private let tableView      = UCTableView(style: .plain)
    
    private let emptyViewNews  = ERDefaultEmptyView()
    
    private let refreshControl = UIView.initRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String.NEWS
        view.backgroundColor = UIColor.background
        
        view.addSubview(tableView)
        tableView.match().apply()

        // Refresh Control
        refreshControl.addTarget(self, action: #selector(didChangeValue(sender:)), for: .valueChanged)
        
        tableView.delegate       = self
        tableView.dataSource     = self
        tableView.refreshControl = refreshControl
        
        tableView.registerClass(ERNewsTableViewCell.self, forCellReuseIdentifier: kERNewsTableViewCell)
        tableView.registerClass(ERNewsHeaderTableViewCell.self, forCellReuseIdentifier: kERNewsHeaderTableViewCell)
        
        // Empty View
        emptyViewNews.icon      = UIImage.iconBoxSelected()
        emptyViewNews.title     = String.NEWS
        emptyViewNews.subtitle  = String.CURRENTLY_NO_NEWS
        
        tableView.emptyView     = emptyViewNews
        
        dataManager.findNews()
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
        dataManager.findNews()
    }
    
    func reloadData() {
        if !dataManager.isLoadingNews {
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    // MARK: Table View    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.news.count
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(kERNewsHeaderTableViewCell) as! ERNewsHeaderTableViewCell
            cell.news = dataManager.news[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(kERNewsTableViewCell) as! ERNewsTableViewCell
            cell.news = dataManager.news[indexPath.row]
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
        let viewController = ERNewsV2DetailViewController()
        viewController.news = dataManager.news[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - ERDataManagerDelegate
    
    func dataManagerDidEndLoadNews(dataManager: ERDataManager, news: [ERNews]?, error: Error?) {
        reloadData()
    }
    
}

