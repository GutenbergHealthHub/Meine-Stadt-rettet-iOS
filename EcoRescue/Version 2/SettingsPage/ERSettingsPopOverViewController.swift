//
//  ERSettingsPopOverViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 06.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERSettingsPopOverViewController: ERPopOverTableViewController {
    
    var soundManager: ERSoundManager!
    
    var selectedSound: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        popOverData = ERSoundManager.sounds.map { $0.title }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.white : UIColor.background
        cell.selectionStyle  = .none
        cell.textLabel?.text = popOverData?[indexPath.row] ?? ""
        
        if let selectedSound = selectedSound, selectedSound == popOverData?[indexPath.row] {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
        }
        delegate?.selectedText(text: popOverData?[indexPath.row] ?? "", index: indexPath.row)
        
        soundManager.play(sound: ERSoundManager.sounds[indexPath.row])
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }

}
