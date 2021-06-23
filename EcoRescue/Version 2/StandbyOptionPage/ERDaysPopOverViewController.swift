//
//  ERDaysPopOverViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 19.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERDaysPopOverViewController: ERPopOverTableViewController {
    
    var selectedDays: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = true
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.selectionStyle  = .none
        cell.textLabel?.text = popOverData?[indexPath.row] ?? ""
        
        if selectedDays.contains(indexPath.row + 1) {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            if !selectedDays.contains(indexPath.row + 1) {
                selectedDays.append(indexPath.row + 1)
                delegate?.selectedText(text: popOverData?[indexPath.row] ?? "", index: indexPath.row)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            selectedDays = selectedDays.filter { $0 != indexPath.row + 1}
            delegate?.selectedText(text: popOverData?[indexPath.row] ?? "", index: indexPath.row)
        }
    }


}
