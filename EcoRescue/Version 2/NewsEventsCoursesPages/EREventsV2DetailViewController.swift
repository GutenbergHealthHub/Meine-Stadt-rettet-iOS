//
//  EREventsV2DetailViewController.swift
//  EcoRescue
//
//  Created by Birtan on 16.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import SafariServices

class EREventsV2DetailViewController: UIViewController, UCTableViewDelegate, UCTableViewDataSource {
    
    var event: EREvent? { didSet { setEvent(oldValue: oldValue) } }
    
    //Table View
    private let tableView       = UCHeadedTableView(style: .plain)
    
    private var tableViewCells  = [UITableViewCell]()
    
    // Views
    private let headerView      = ERNewEventHeaderView()
    
    private let cellTitle       = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let cellInfo        = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let cellOrganizer   = UITableViewCell(style: .default, reuseIdentifier: nil)
    
    private let cellEmail       = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let cellPhone       = UITableViewCell(style: .default, reuseIdentifier: nil)
    
    private let cellDate        = EREventDateTableViewCell()
    private let cellAddress     = EREventLocationTableViewCell()
    
    private let cellUrl         = UITableViewCell(style: .default, reuseIdentifier: nil)
    
    // Table View Cell - Labels
    private let titleLabel      = UILabel.type2Label()
    private let dateLabel       = UILabel.type2LightLabel()
    private let infoLabel       = UILabel.type2Label()
    private let organizerLabel  = UILabel.type2LightLabel()
    
    // Other
    private let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        
        view.addSubview(tableView)
        tableView.match().apply()
        
        tableView.delegate       = self
        tableView.dataSource     = self
        
        // Header View
        headerView.contentMode = UIViewContentMode.scaleAspectFill
        headerView.clipsToBounds = true
        
        tableView.headerMode = .ten
        tableView.tableHeaderView = headerView
        tableView.tableHeaderViewHeight = 200
        tableView.estimatedRowHeight    = 44
        
        // Labels
        titleLabel.numberOfLines     = 0
        organizerLabel.numberOfLines = 0
        dateLabel.numberOfLines      = 0
        infoLabel.numberOfLines      = 0
        
        // Date Formatter
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        prepareCells()
    }
    
    
    private func setEvent(oldValue: EREvent?) {
        if event == oldValue { return }
        
        // Remove All Cells
        tableViewCells.removeAll()
        
        
        // Add Cells
        if let event = event {
            if let title = event.title {
                titleLabel.text   = title
                tableViewCells.append(cellTitle)
            }
            
            if let organizer = event.organizer {
                organizerLabel.text   = organizer
                tableViewCells.append(cellOrganizer)
            }
            
            if let from = event.from, let to = event.to {
                cellDate.from   = from
                cellDate.to     = to
                tableViewCells.append(cellDate)
            }
            
            
            cellAddress.address = event.address
            tableViewCells.append(cellAddress)
            
            event.getImage(completion: { (image) in
                self.headerView.image = image
            })
            
            if let information = event.information {
                infoLabel.text   = information
                tableViewCells.append(cellInfo)
            }
            
            if let phone = event.phone {
                cellPhone.textLabel?.text   = phone
                tableViewCells.append(cellPhone)
            }
            
            if let email = event.email {
                cellEmail.textLabel?.text   = email
                tableViewCells.append(cellEmail)
            }
            
            if let _ = event.eventUrl {
                tableViewCells.append(cellUrl)
            }
        }
        self.tableView.reloadData()
    }
    
    private func prepareCells() {
        cellDate.backgroundColor    = UIColor.clear
        cellAddress.backgroundColor = UIColor.clear
        cellUrl.backgroundColor     = UIColor.clear
        cellEmail.backgroundColor   = UIColor.clear
        cellPhone.backgroundColor   = UIColor.clear
        
        cellUrl.textLabel?.textColor    = UIColor.theme
        cellEmail.textLabel?.textColor  = UIColor.theme
        cellPhone.textLabel?.textColor  = UIColor.theme
        
        cellUrl.textLabel?.text         = String.CONTINUE_READING
        
        //cellTitle
        titleLabel.numberOfLines    = 0
        
        cellTitle.backgroundColor   = UIColor.background
        cellTitle.selectionStyle    = .none
        
        let containerView = UIView.view()
        cellTitle.contentView.addSubview(containerView)
        containerView.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
        
        containerView.addSubview(titleLabel)
        titleLabel.match().apply()
        
        
        //cellOrganizer
        organizerLabel.numberOfLines    = 0
        
        cellOrganizer.backgroundColor   = UIColor.background
        cellOrganizer.selectionStyle    = .none
        
        let containerView2 = UIView.view()
        cellOrganizer.contentView.addSubview(containerView2)
        containerView2.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
        
        containerView2.addSubview(organizerLabel)
        organizerLabel.match().apply()
        
        
        //cellInfo
        infoLabel.numberOfLines    = 0

        cellInfo.selectionStyle    = .none
        
        let containerView3 = UIView.view()
        cellInfo.contentView.addSubview(containerView3)
        containerView3.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
        
        containerView3.addSubview(infoLabel)
        infoLabel.match().apply()
        
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return tableViewCells[indexPath.row]
    }
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
            switch cell {
                
            case cellEmail:
                if let email = event!.email {
                    UCUtil.mail(receiver: email)
                }
                break
                
            case cellPhone:
                if let number = event!.phone {
                    UCUtil.call(number: number)
                }
                break
                
            case cellUrl:
                if let url = URL(string: event?.eventUrl ?? ""){
                    let svc = SFSafariViewController(url: url)
                    present(svc, animated: true, completion: nil)
                }
                break
                
            default: break
            }
        }
    }
    
}
