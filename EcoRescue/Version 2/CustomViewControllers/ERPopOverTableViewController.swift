//
//  ERPopOverTableViewController.swift
//  EcoRescue
//
//  Created by Birtan on 31.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit

protocol ERPopOverTableViewControllerDelegate: NSObjectProtocol {
    func selectedText(text: String, index: Int)
}

class ERPopOverTableViewController: UITableViewController {
    
    weak var delegate: ERPopOverTableViewControllerDelegate?
    
    var popOverData: [String]? { didSet { setPopOverData() } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        tableView.separatorStyle = .none
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popOverData?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.white : UIColor.background
        cell.selectionStyle  = .none
        cell.textLabel?.text = popOverData?[indexPath.row] ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedText(text: popOverData?[indexPath.row] ?? "", index: indexPath.row)
        self.dismiss(animated: true, completion: nil)
    }
    
    func setPopOverData() {
        tableView.reloadData()
    }
    

}
