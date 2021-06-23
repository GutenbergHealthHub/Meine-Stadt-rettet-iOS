//
//  ERNewsV2DetailViewController.swift
//  EcoRescue
//
//  Created by Birtan on 15.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import SafariServices

class ERNewsV2DetailViewController: UIViewController, UCTableViewDelegate, UCTableViewDataSource {
    
    var news: ERNews? { didSet { setNews(oldValue: oldValue) } }
    
    //Table View
    private let tableView      = UCHeadedTableView(style: .plain)
    
    // Views
    private let headerView = ERNewEventHeaderView()
    
    private let cellTitle       = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let cellAbstract    = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let cellUrl         = UITableViewCell(style: .default, reuseIdentifier: nil)
    
    // Table View Cell - Labels
    private let titleLabel      = UILabel.type2Label()
    private let dateLabel       = UILabel.type2LightLabel()
    private let subtitleLabel   = UILabel.type2LightLabel()
    private let abstractLabel   = UILabel.type2Label()
    
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
        titleLabel.numberOfLines    = 0
        subtitleLabel.numberOfLines = 0
        dateLabel.numberOfLines     = 0
        abstractLabel.numberOfLines = 0
        
        // Date Formatter
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        prepareCells()
        setDate()
    }
    
    private func setNews(oldValue: ERNews?) {
        if news == oldValue { return }
        
        if let news = news {
            titleLabel.text     = news.title
            subtitleLabel.text  = news.subtitle
            abstractLabel.text  = news.abstract
            
            news.getImage(completion: { (image) in
                self.headerView.image = image
            })
            
        } else {
            titleLabel.text     = nil
            subtitleLabel.text  = nil
            abstractLabel.text  = nil
        }
        
    }
    
    private func setDate() {
        if let news = news, let date = news.createdAt {
            dateLabel.text = dateFormatter.string(from: date)
        } else {
            dateLabel.text = nil
        }
    }
    
    private func prepareCells() {
        //cellTitle
        cellTitle.selectionStyle  = .none
        cellTitle.backgroundColor = UIColor.background
        
        let containerViewTitle = UIView.view()
        cellTitle.contentView.addSubview(containerViewTitle)
        containerViewTitle.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
        
        containerViewTitle.addSubview(titleLabel)
        containerViewTitle.addSubview(subtitleLabel)
        containerViewTitle.addSubview(dateLabel)
        
        titleLabel.leftright().top().apply()
        subtitleLabel.leftright().bottom(of: titleLabel, constant: UIViewPadding.medium).apply()
        dateLabel.leftright().bottom(of: subtitleLabel, constant: UIViewPadding.medium).bottom(constant: UIViewPadding.small).apply()
        
        //cellAbstract
        cellAbstract.selectionStyle = .none
        
        let containerViewAbstract = UIView.view()
        cellAbstract.contentView.addSubview(containerViewAbstract)
        containerViewAbstract.leftright(constant: UIViewPadding.big).topbottom(constant: UIViewPadding.big).apply()
        
        containerViewAbstract.addSubview(abstractLabel)
        
        abstractLabel.match().apply()
        
        cellUrl.backgroundColor   = UIColor.clear
        cellUrl.textLabel?.text         = String.CONTINUE_READING
        cellUrl.textLabel?.textColor    = UIColor.theme
        
    }
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellTitle
        case 1:
            return cellAbstract
        default:
            return cellUrl
        }
    }
    
    func tableView(tableView: UCTableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if indexPath.row == 2, let url = URL(string: news?.newsUrl ?? "") {
            //UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }

}
