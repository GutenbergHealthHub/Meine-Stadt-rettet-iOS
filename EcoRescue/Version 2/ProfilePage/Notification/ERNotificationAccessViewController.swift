//
//  ERNotificationAccessViewController.swift
//  EcoRescue
//
//  Created by Birtan on 14.01.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit
import UserNotifications

class ERNotificationAccessViewController: UIViewController {
    
    private let descriptionView = ERDescriptionView()
    
    private let tableView = FixedTableView(style: .grouped)
    
    private let notificationCell  = TableViewCell(style: .value1, reuseIdentifier: nil)
    private let criticalAlertCell = TableViewCell(style: .value1, reuseIdentifier: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        title = String.NOTIFICATIONS
        view.backgroundColor = UIColor.background
        
        // Description view
        view.addSubview(descriptionView)
        descriptionView.top().leftright().height(multiplier: 0.2).apply()
        descriptionView.image = UIImage.iconNotificationV2().imageWithColor(.white)
        descriptionView.text  = String.PERMISSION_NOTIFICATION_DESCRIPTION
        
        view.addSubview(tableView)
        tableView.leftright().bottom().bottom(of: descriptionView, constant: 0).apply()
        tableView.isScrollEnabled = false
        
        notificationCell.title  = String.PERMISSION_NOTIFICATION
        criticalAlertCell.title = String.CRITICAL_ALERT
        
        setTableViewCells()
        
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        reloadData()
    }
    
    private func setTableViewCells() {
        
        let section1 = FixedTableViewSection()
        section1.tableViewCells = [(notificationCell, didTapNotificationCell)]
        
        let section2 = FixedTableViewSection()
        section2.tableViewCells = [(criticalAlertCell, didTapCriticalAlertCell)]
        section2.footerView = TableSectionFooterView(style: .grouped, title: String.CRITICAL_ALERT_INFO)
        
        tableView.sections = [section1, section2]
        
    }
    
    private func reloadData() {
        
        if #available(iOS 12.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                DispatchQueue.main.async {
                    self.notificationCell.subtitle = settings.authorizationStatus == .authorized ? String.ENABLED : String.DISABLED
                    self.criticalAlertCell.subtitle = settings.criticalAlertSetting == .enabled ? String.ENABLED : String.DISABLED
                }
            }
        }
    }
    
    private func openSettingsAlert() {
        let viewController      = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        viewController.title    = String.OPEN_CONFIGURATION
        viewController.message  = String.PERMISSION_CAN_BE_RESET_IN_SETTINGS
        
        viewController.addAction(UIAlertAction(title: String.OPEN_CONFIGURATION, style: .default, handler: { (action) in
            ERUtil.openSettings()
        }))
        
        viewController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: { (action) in
            self.reloadData()
        }))
        present(viewController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    func didTapNotificationCell() {
        openSettingsAlert()
    }
    
    func didTapCriticalAlertCell() {
        if #available(iOS 12.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options:  [.alert, .badge, .sound, .criticalAlert]) { (success, error) in
                self.openSettingsAlert()
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func appWillEnterForeground() {
        reloadData()
    }
    
    
}
