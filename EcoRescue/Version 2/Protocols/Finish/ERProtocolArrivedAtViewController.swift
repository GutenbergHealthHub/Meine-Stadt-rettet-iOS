//
//  ERProtocolArrivedAtViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 12.01.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERProtocolArrivedAtViewController: StepsViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let containerView = UIView.view()
    
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    private let dateFormatter = DateFormatter()
    
    private let cellIdentifier = "UITableViewCell"
    
    private let datePicker = UIDatePicker()
    
    var datePickerVisible: Bool = false
    
    var acceptedAt: Date?
    var endedAt: Date?
    var arrivedAt: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headerTitleLabel.text    = String.ARRIVAL_TIME_TITLE
        headerSubtitleLabel.text = String.ARRIVED_AT_SUBTITLE
        
        view.addSubview(containerView)
        containerView.bottom(of: progressView, constant: 0).leftright().top(of: progressView2, constant: 0).apply()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        tableView.top().leftright().bottom().apply()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UIDatePickerTableViewCell")
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(didDatePickerValueChaged(sender:)), for: .valueChanged)
        
        let interval = acceptedAt?.addingTimeInterval(60 * 60 * 3)
        datePicker.minimumDate = acceptedAt
        datePicker.maximumDate = (interval! > endedAt!) ? endedAt : interval
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
        isNextButtonEnabled()
    }
    
    private func isNextButtonEnabled() {
        if let _ = arrivedAt {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        } else {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datePickerVisible ? 4 : 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if datePickerVisible, indexPath.row == 3 {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UIDatePickerTableViewCell", for: indexPath)
            cell.contentView.addSubview(datePicker)
            datePicker.match().apply()
            
            return cell
        } else {
            var cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
            }

            cell.selectionStyle = .none
            cell.textLabel?.font = UIFont.openSansRegular(textStyle: .body)
            cell.detailTextLabel?.font = UIFont.openSansRegular(textStyle: .footnote)
            
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = String.ACCEPTED_AT
                cell.detailTextLabel?.text = dateFormatter.string(from: acceptedAt!)
                cell.textLabel?.textColor = UIColor.gray
                cell.detailTextLabel?.textColor = UIColor.gray
                break
            case 1:
                cell.textLabel?.text = String.ENDED_AT
                cell.detailTextLabel?.text = dateFormatter.string(from: endedAt!)
                cell.textLabel?.textColor = UIColor.gray
                cell.detailTextLabel?.textColor = UIColor.gray
                break
            case 2:
                cell.textLabel?.text = String.ARRIVED_AT
                cell.detailTextLabel?.text = String.NOT_SPECIFIED
                break
            default:
                break
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2, !datePickerVisible {
            datePickerVisible = true
            tableView.beginUpdates()
            tableView.insertRows(at: [IndexPath(row: indexPath.row + 1, section: indexPath.section)], with: .fade)
            tableView.endUpdates()
        }
    }
    
    // MARK: ERDatePickerTableViewCellDelegate
    
    func didDatePickerValueChaged(sender: UIDatePicker) {
        self.arrivedAt = sender.date
        tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.text = dateFormatter.string(from: sender.date)
        tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.textColor = UIColor.colorPrimaryRedV2
        tableView.cellForRow(at: IndexPath(row: 2, section: 0))?.detailTextLabel?.font = UIFont.openSansBold(textStyle: .body)
        isNextButtonEnabled()
    }


}

