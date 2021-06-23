//
//  ERProtocolExpandableTableViewController.swift
//  EcoRescue
//
//  Created by Birtan on 11.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

class ERProtocolExpandableTableViewController: StepsViewController, UITableViewDelegate, UITableViewDataSource, ERProtocolExpandableTableViewCellDelegate {
    
    private let containerView = UIView.view()
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    var reportData: ERReportData!
    
    var pickerRow: Int!
    
    var selectedPickerRow: Bool = false
    
    var pickerValues: [Int]!
    
    var pickerViewText: String?
    
    var selectedIndex: Int?
    
    var selectedPickerRowIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(containerView)
        containerView.bottom(of: progressView, constant: 0).leftright().top(of: progressView2, constant: 0).apply()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(tableView)
        tableView.top().leftright().bottom().apply()
        
        tableView.delegate   = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        tableView.register(ERProtocolExpandableTableViewCell.self, forCellReuseIdentifier: "ERProtocolExpandableTableViewCell")
        
        isNextButtonEnabled()
    }
    
    private func isNextButtonEnabled() {
        if selectedValues().0 == nil && selectedValues().1 == nil {
            nextButton.isEnabled = false
            nextButton.alpha = 0.5
        } else {
            nextButton.isEnabled = true
            nextButton.alpha = 1
        }
    }
    
    func selectedValues() -> (Int?, Int?) {
        return (nil, nil)
    }
    
    func selected(index: Int){
    }
    
    // MARK: ERProtocolExpandableTableViewCellDelegate
    
    func pickerView(value: Int) {
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reportData.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == pickerRow {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ERProtocolExpandableTableViewCell", for: indexPath) as! ERProtocolExpandableTableViewCell
            cell.delegate = self
            cell.selectionStyle   = .none
            cell.titleLabel.text  = reportData.data[indexPath.row].text
            cell.titleLabel.font  = UIFont.openSansRegular(textStyle: .body)
            cell.titleLabel.adjustsFontForContentSizeCategory = true
            cell.pickerValues     = self.pickerValues
            cell.pickerViewText   = self.pickerViewText
            if let index = selectedValues().1 {
                self.selectedPickerRow = true
                cell.titleLabel.textColor = UIColor.colorPrimaryRedV2
                cell.titleLabel.font  = UIFont.openSansBold(textStyle: .body)
                cell.titleLabel.adjustsFontForContentSizeCategory = true
                cell.detailLabel.text = "\(pickerValues[index]) \(pickerViewText ?? "")"
                cell.pickerViewIndex = index
                //cell.pickerView.selectRow(index, inComponent: 0, animated: true)
                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
            return cell
        }
        
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        cell.selectionStyle  = .none
        cell.textLabel?.text = reportData.data[indexPath.row].text
        cell.textLabel?.font = UIFont.openSansRegular(textStyle: .body)
        cell.textLabel?.adjustsFontForContentSizeCategory = true
        
        if let index = selectedValues().0, index == indexPath.row {
            cell.textLabel?.textColor = UIColor.colorPrimaryRedV2
            cell.textLabel?.font = UIFont.openSansBold(textStyle: .body)
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
        
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.colorPrimaryRedV2
        tableView.cellForRow(at: indexPath)?.textLabel?.font = UIFont.openSansBold(textStyle: .body)
        selected(index: indexPath.row)
        
       if indexPath.row == pickerRow {
            self.selectedPickerRow = true
        
            (tableView.cellForRow(at: indexPath) as! ERProtocolExpandableTableViewCell).titleLabel.textColor = UIColor.colorPrimaryRedV2
            (tableView.cellForRow(at: indexPath) as! ERProtocolExpandableTableViewCell).titleLabel.font = UIFont.openSansBold(textStyle: .body)
            (tableView.cellForRow(at: indexPath) as! ERProtocolExpandableTableViewCell).detailLabel.text = "\(pickerValues[0]) \(pickerViewText ?? "")"
            (tableView.cellForRow(at: indexPath) as! ERProtocolExpandableTableViewCell).pickerView.selectRow(0, inComponent: 0, animated: false)
                
            tableView.beginUpdates()
            tableView.endUpdates()
        }
        isNextButtonEnabled()
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = UIColor.black
        tableView.cellForRow(at: indexPath)?.textLabel?.font = UIFont.openSansRegular(textStyle: .body)
        
        if let pickerRow = self.pickerRow, indexPath.row == pickerRow {
            self.selectedPickerRow = false
            
            (tableView.cellForRow(at: indexPath) as! ERProtocolExpandableTableViewCell).titleLabel.textColor = UIColor.black
            (tableView.cellForRow(at: indexPath) as! ERProtocolExpandableTableViewCell).titleLabel.font = UIFont.openSansRegular(textStyle: .body)
            (tableView.cellForRow(at: indexPath) as! ERProtocolExpandableTableViewCell).detailLabel.text = ""
            
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == pickerRow {
            return selectedPickerRow ? ERProtocolExpandableTableViewCell.expandedHeight : ERProtocolExpandableTableViewCell.defaultheight
        }
        return UITableViewAutomaticDimension
    }

}

protocol ERProtocolExpandableTableViewCellDelegate: NSObjectProtocol {
    func pickerView(value: Int)
}

private class ERProtocolExpandableTableViewCell: UITableViewCell, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: ERProtocolExpandableTableViewCellDelegate?
    
    let titleLabel  = UILabel.type2Label()
    let detailLabel = UILabel.type2SemiBoldLabel()
    let pickerView  = UIPickerView(frame: CGRect.zero)
    var pickerValues: [Int] = []
    
    var pickerViewText: String?
    
    var pickerViewIndex: Int?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let containerView = UIView.view()
        addSubview(containerView)
        addSubview(pickerView)
        
        containerView.top().leftright().height(constant: 44).apply()
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(detailLabel)
        
        
        titleLabel.centerY().left(constant: UIViewPadding.big).apply()
        detailLabel.centerY().right(constant: UIViewPadding.big).apply()
        detailLabel.textColor = UIColor.colorPrimaryRedV2
        
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.bottom(of: containerView, constant: 0).leftright().height(constant: 0).apply()
        
        let pickerViewInfoLabel = UILabel.type2Label()
        pickerView.addSubview(pickerViewInfoLabel)
        pickerViewInfoLabel.centerY(to: pickerView).centerX(to: pickerView, constant: 2 * UIViewPadding.large).apply()
        pickerViewInfoLabel.text = pickerViewText
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for constraint in self.pickerView.constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = frame.height < ERProtocolExpandableTableViewCell.expandedHeight ? 0 : 130
            }
        }
        
        if let index = pickerViewIndex {
            self.pickerView.selectRow(index, inComponent: 0, animated: true)
        }
    }
    
    class var expandedHeight: CGFloat { get { return 160 } }
    class var defaultheight: CGFloat { get { return 44 } }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(pickerValues[row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.detailLabel.text = "\(pickerValues[row]) \(pickerViewText ?? "")"
        pickerViewIndex = row
        delegate?.pickerView(value: pickerValues[row])
    }
    
    
}
