//
//  ERMapV2EditAddressViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 07.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit

protocol ERMapV2EditAddressViewControllerDelegate: NSObjectProtocol {
    func addressTableViewDidChangeAddress(address: UCAddress)
}

class ERMapV2EditAddressViewController: UIViewController, UITextFieldDelegate, UCTableViewDataSource, UCTableViewDelegate {
    
    weak var delegate: ERMapV2EditAddressViewControllerDelegate?
    
    private let tableView = UCTableView(style: .grouped)
    
    private let streetCell  = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let cityCell    = UITableViewCell(style: .default, reuseIdentifier: nil)
    
    private let streetLabel = UITextField.textField()
    private let numberLabel = UITextField.textField()
    private let zipLabel    = UITextField.textField()
    private let cityLabel   = UITextField.textField()
    
    private let addButton   = ERButton()
    
    private let seperatorView1 = UIView.seperatorView()
    private let seperatorView2 = UIView.seperatorView()
    
    private var tableViewCells = [UITableViewCell]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.background
        
        self.view.addSubview(addButton)
        self.view.addSubview(tableView)
        
        addButton.bottom(constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).height(constant: 44).apply()
        tableView.top(constant: UIViewPadding.large).leftright().top(of: addButton, constant: UIViewPadding.large).apply()
        
        tableView.dataSource    = self
        tableView.delegate      = self
        
        tableView.scrollEnabled = false
        tableView.rowHeight     = UIViewRowHeight.small
        
        streetCell.contentView.addSubview(streetLabel)
        streetCell.contentView.addSubview(seperatorView1)
        streetCell.contentView.addSubview(numberLabel)
        cityCell.contentView.addSubview(zipLabel)
        cityCell.contentView.addSubview(seperatorView2)
        cityCell.contentView.addSubview(cityLabel)
        
        streetCell.selectionStyle = .none
        cityCell.selectionStyle   = .none
        
        tableViewCells.append(streetCell)
        tableViewCells.append(cityCell)
        
        streetLabel.left(constant: UIViewPadding.big).centerY().left(of: seperatorView1, constant: UIViewPadding.medium).apply()
        seperatorView1.topbottom().width(constant: 1).left(of: numberLabel, constant: UIViewPadding.medium).apply()
        numberLabel.right(constant: UIViewPadding.big).centerY().width(constant: 44).apply()
        
        zipLabel.centerY().left(constant: UIViewPadding.big).width(constant: 64).apply()
        seperatorView2.topbottom().width(constant: 1).right(of: zipLabel, constant: UIViewPadding.medium).apply()
        cityLabel.centerY().right(of: seperatorView2, constant: UIViewPadding.medium).right(constant: UIViewPadding.big).apply()
        
        
        streetLabel.delegate = self
        numberLabel.delegate = self
        zipLabel.delegate    = self
        cityLabel.delegate   = self
        
        streetLabel.placeholder = String.LOCATION_STREET
        numberLabel.placeholder = String.NUMBER_SHORT
        zipLabel.placeholder    = String.ZIP
        cityLabel.placeholder   = String.CITY
        
        addButton.text = String.ADD_ADDRESS
        addButton.addTarget(self, action: #selector(didTapAdd(sender:)), for: .touchDown)
    
    }
    
    // MARK: - UCTableViewDataSource
    
    func tableView(tableView: UCTableView, titleForHeaderInSection section: Int) -> String? {
        return String.ADDRESS
    }
    
    func tableView(tableView: UCTableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        return tableViewCells[indexPath.row]
    }
    
    func tableView(tableView: UCTableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewCells.count
    }
    
    func tableView(tableView: UCTableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UCTableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIViewRowHeight.tiny
    }
    
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: - Actions
    
    func didTapAdd(sender: Any) {
        if let street = street, !street.isEmpty, let number = number, !number.isEmpty, let zip = zip, !zip.isEmpty, let city = city, !city.isEmpty {
            delegate?.addressTableViewDidChangeAddress(address: self.address)
            self.navigationController?.pop(animated: true)
        } else {
            let alertController = UIAlertController(title: String.ADDRESS_IS_MISSING, message: nil, preferredStyle: .alert)
            alertController.message = String.PLEASE_FILL_IN_EVERYTHING
            alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Variables
    
    var street: String? {
        set { streetLabel.text = newValue   }
        get { return streetLabel.text       }
    }
    
    var number: String? {
        set { numberLabel.text = newValue   }
        get { return numberLabel.text       }
    }
    
    var zip: String? {
        set { zipLabel.text = newValue   }
        get { return zipLabel.text       }
    }
    
    var city: String? {
        set { cityLabel.text = newValue   }
        get { return cityLabel.text       }
    }
    
    var address: UCAddress {
        set {
            self.street = newValue.street
            self.number = newValue.number
            self.zip    = newValue.zip
            self.city   = newValue.city
        }
        
        get {
            let address = UCAddress()
            address.street  = street
            address.number  = number
            address.zip     = zip
            address.city    = city
            return address
        }
    }

}
