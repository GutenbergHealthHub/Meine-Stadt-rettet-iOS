//
//  ERCoursesV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 17.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class ERCoursesV2ViewController: CenterMenuViewController, ERDataManagerDelegate, UCTableViewDataSource, UCTableViewDelegate {
    
    private let dataManager       = ERDataManager.sharedManager
    
    private let tableView         = UCTableView(style: .plain)
    
    private let emptyViewCourses  = ERDefaultEmptyView()
    
    private let refreshControl    = UIView.initRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.COURSES
        view.backgroundColor = UIColor.background
        
        view.addSubview(tableView)
        tableView.match().apply()
        
        // Refresh Control
        refreshControl.addTarget(self, action: #selector(didChangeValue(sender:)), for: .valueChanged)
        
        tableView.delegate       = self
        tableView.dataSource     = self
        tableView.refreshControl = refreshControl
        
        tableView.registerClass(ERCoursesTableViewCell.self, forCellReuseIdentifier: kERCoursesTableViewCell)
        
        // Empty View
        emptyViewCourses.icon      = UIImage.iconCourseSelected()
        emptyViewCourses.title     = "Courses"
        emptyViewCourses.subtitle  = "Courses"
        
        tableView.emptyView        = emptyViewCourses
        
        dataManager.findCourses()
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
        dataManager.findCourses()
    }
    
    func reloadData() {
        if !dataManager.isLoadingNews {
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.courses.count
    }


    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(kERCoursesTableViewCell) as! ERCoursesTableViewCell
        cell.course = dataManager.courses[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        let viewController = ERCoursesV2DetailViewController()
        viewController.course = dataManager.courses[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    func dataManagerDidEndLoadCourses(dataManager: ERDataManager, courses: [ERCourse]?, error: Error?) {
        reloadData()
    }

}
