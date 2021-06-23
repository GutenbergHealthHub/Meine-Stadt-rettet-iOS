//
//  ERSideMenuViewController.swift
//  EcoRescue
//
//  Created by Birtan on 01.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

private let kHeaderViewHeight: CGFloat = 150

class ERSideMenuViewController: UIViewController {
    
    var delegate: CenterMenuViewControllerDelegate?
    
    private let cellHomePage       = TableViewCell()
    private let cellMap            = TableViewCell()
    private let cellNewsAndEvents  = TableViewCell()
    //private let cellNews           = TableViewCell()
    //private let cellEvents         = TableViewCell()
    private let cellCourses        = TableViewCell()
    private let cellProfile        = TableViewCell()
    private let cellSettings       = TableViewCell()
    private let cellStandBy        = TableViewCell()
    private let cellAboutProject   = TableViewCell()
    private let cellFAQ            = TableViewCell()
    private let cellContactImprint = TableViewCell()
    private let cellLegalNotice    = TableViewCell()
    
    private let sideMenuHeaderView = SideMenuHeaderView()
    
    private let tableView = FixedTableView(style: .grouped)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        //sideMenuHeaderView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: kHeaderViewHeight)
        
        self.view.addSubview(sideMenuHeaderView)
        self.view.addSubview(tableView)
        sideMenuHeaderView.top().left().width(constant: view.frame.width - 60).height(multiplier: 0.2).apply()
        tableView.bottom(of: sideMenuHeaderView, constant: 0).left().width(constant: view.frame.width - 60).bottom().apply()
        
        reloadData()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /*let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        statusBarView.backgroundColor = UIColor.colorPrimaryBlueV2
        self.view.addSubview(statusBarView)*/
        
    }
    
    private func reloadData() {
        
        cellHomePage.title       = String.HOME_PAGE
        cellHomePage.titleFont   = UIFont.quicksandBold(textStyle: .body)
        cellHomePage.isBadgeFilled = false
        cellMap.title            = String.MAP
        cellMap.titleFont        = UIFont.quicksandBold(textStyle: .body)
        cellNewsAndEvents.title     = "\(String.NEWS) & \(String.EVENTS)"
        cellNewsAndEvents.titleFont = UIFont.quicksandBold(textStyle: .body)
        /*cellNews.title           = String.NEWS
        cellNews.titleFont       = UIFont.quicksandBold(textStyle: .body)
        cellEvents.title         = String.EVENTS
        cellEvents.titleFont     = UIFont.quicksandBold(textStyle: .body)*/
        cellCourses.title        = String.COURSES
        cellCourses.titleFont    = UIFont.quicksandBold(textStyle: .body)
        
        let section1 = FixedTableViewSection()
        section1.tableViewCells = [(cellHomePage, didTapHomePage), (cellMap, didTapMap), (cellNewsAndEvents, didTapNewsAndEvents), (cellCourses, didTapCourses)]
        //section1.tableViewCells = [(cellHomePage, didTapHomePage), (cellMap, didTapMap), (cellNews, didTapNews), (cellEvents, didTapEvents), (cellCourses, didTapCourses)]
        
        
        cellProfile.title        = String.PROFILE
        cellProfile.titleFont    = UIFont.quicksandRegular(textStyle: .body)
        cellSettings.title       = String.SETTINGS
        cellSettings.titleFont   = UIFont.quicksandRegular(textStyle: .body)
        cellStandBy.title        = String.STANDBY_MODE
        cellStandBy.titleFont    = UIFont.quicksandRegular(textStyle: .body)
        
        let section2 = FixedTableViewSection()
        section2.headerView = TableSectionHeaderView(style: .plain, title: String.ACCOUNT)
        section2.tableViewCells = [(cellProfile, didTapProfile), (cellSettings, didTapSettings), (cellStandBy, didTapStandBy)]
        
        cellAboutProject.title       = String.ABOUT_THE_PROJECT
        cellAboutProject.titleFont   = UIFont.quicksandRegular(textStyle: .body)
        cellFAQ.title                = String.FAQ
        cellFAQ.titleFont            = UIFont.quicksandRegular(textStyle: .body)
        cellContactImprint.title     = "\(String.CONTACT) & \(String.IMPRINT)"
        cellContactImprint.titleFont = UIFont.quicksandRegular(textStyle: .body)
        cellLegalNotice.title        = String.LEGAL_NOTICE
        cellLegalNotice.titleFont    = UIFont.quicksandRegular(textStyle: .body)
        
        let section3 = FixedTableViewSection()
        section3.headerView = TableSectionHeaderView(style: .plain, title: String.ABOUT_THE_APP)
        section3.tableViewCells = [(cellAboutProject, didTapAboutProject), (cellFAQ, didTapFAQ), (cellContactImprint, didTapContactImprint), (cellLegalNotice, didTapLegalNotice)]
        
        if let _ = ERUser.current() {
            tableView.sections = [section1, section2, section3]
            let count = ERDataManager.sharedManager.finishedExpiredEvaluationsWithProtocolNotDoneArray.count
            if count > 0 {
                self.cellHomePage.badge = "\(count)"
            } else {
                self.cellHomePage.badge = nil
            }
        } else {
            tableView.sections = [section1, section3]
            self.cellHomePage.badge = nil
        }
        
        
    }
    
    func didTapHomePage(sender: Any) {
        delegate?.changeViewController?(to: 1)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapMap(sender: Any) {
        delegate?.changeViewController?(to: 2)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapNewsAndEvents(sender: Any) {
        delegate?.changeViewController?(to: 3)
        delegate?.toggleLeftPanel?()
    }
    /*
    func didTapNews(sender: Any) {
        delegate?.changeViewController?(to: 3)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapEvents(sender: Any) {
        delegate?.changeViewController?(to: 4)
        delegate?.toggleLeftPanel?()
    }*/
    
    func didTapCourses(sender: Any) {
        delegate?.changeViewController?(to: 5)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapProfile(sender: Any) {
        delegate?.changeViewController?(to: 6)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapSettings(sender: Any) {
        delegate?.changeViewController?(to: 7)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapStandBy(sender: Any) {
        delegate?.changeViewController?(to: 8)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapAboutProject(sender: Any) {
        delegate?.toggleLeftPanel?()
        delegate?.changeViewController?(to: 9)
    }
    
    func didTapFAQ(sender: Any) {
        delegate?.changeViewController?(to: 10)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapContactImprint(sender: Any) {
        delegate?.changeViewController?(to: 11)
        delegate?.toggleLeftPanel?()
    }
    
    func didTapLegalNotice(sender: Any) {
        delegate?.changeViewController?(to: 12)
        delegate?.toggleLeftPanel?()
    }
}


