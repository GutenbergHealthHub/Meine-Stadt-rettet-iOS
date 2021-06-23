//
//  ERContractListV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 25.07.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERContractListV2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let descriptionView = ERDescriptionView()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let responderStateManager = ResponderStateManager.shared
    
    var subContracts: [ERContractSub]?
    
    var userSubContracts: [ERUserContractSub]?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background

        // Do any additional setup after loading the view.
        // Description view
        self.view.addSubview(descriptionView)
        descriptionView.top().leftright().height(multiplier: 0.2).apply()
        descriptionView.image = UIImage.iconContract().withRenderingMode(.alwaysTemplate)
        descriptionView.text  = String.CONTRACT_LIST_INFO
        
        self.view.addSubview(tableView)
        tableView.leftright().bottom().bottom(of: descriptionView, constant: 0).apply()
        
        tableView.autoLayout = true
        tableView.delegate   = self
        tableView.dataSource = self
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let subContracts = subContracts, !subContracts.isEmpty {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
        // Mandatory
        case 0:
            return String.AGREEMENT
            
        // Optional
        default:
            return String.SUPPLEMENTARY_AGREEMENT
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return subContracts?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "myIdentifier")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            cell.textLabel?.text = String.BASIC_AGREEMENT
            if self.responderStateManager.isUserContractBasicValid, let _ = ERUser.current()?.userContractBasic {
                cell.imageView?.image = Icon(type: .ok).toImage()
                cell.imageView?.tintColor = UIColor.positive
            } else {
                cell.imageView?.image = Icon(type: .cancel).toImage()
                cell.imageView?.tintColor = UIColor.negativ
            }
        } else {
            if let contracts = subContracts, !contracts.isEmpty {
                cell.textLabel?.text = contracts[indexPath.row].title
                cell.detailTextLabel?.text = contracts[indexPath.row].subtitle
                
                if isContractSigned(contract: contracts[indexPath.row]) {
                    cell.imageView?.image = Icon(type: .ok).toImage()
                    cell.imageView?.tintColor = UIColor.positive
                } else {
                    cell.imageView?.image = Icon(type: .cancel).toImage()
                    cell.imageView?.tintColor = UIColor.negativ
                }
                
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // Alert Controller
            let alertController = UIAlertController.createContractBasicLoadingController()
            self.present(alertController, animated: true, completion: nil)
            
            // Find Contract Basic
            ERDataManager.findContractBasic(completion: { (contractBasic, error) in
                alertController.dismiss(animated: true, completion: {
                    
                    if let contractBasic = contractBasic {
                        if self.responderStateManager.isUserContractBasicValid, let userContractBasic = ERUser.current()?.userContractBasic {
                            let vc = ERContractOverviewV2ViewController()
                            vc.contract = userContractBasic
                            self.navigationController?.pushViewController(vc, animated: true)
                        } else {
                            let vc = ERContractEditV2ViewController()
                            vc.contract = contractBasic
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        self.present(UIAlertController.createContractBasicSavingErrorController(), animated: true, completion: nil)
                    }
                })
            })
        } else {
            if let user = ERUser.current() {
                ERDataManager.findUserContractSubs(contract: subContracts![indexPath.row], user: user) { (userContractSub, error) in
                    
                    if let error = error {
                        
                    }
                    
                    if let userContractSub = userContractSub {
                        let vc = ERSubContractOverviewV2ViewController()
                        vc.userContractSub = userContractSub
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = ERSubContractEditV2ViewController()
                        vc.subContract = self.subContracts![indexPath.row]
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                
            }
        }
    }
    
    private func isContractSigned(contract: ERContractSub) -> Bool {
        if let userSubContracts = userSubContracts {
            for sc in userSubContracts where sc.contract == contract {
                return true
            }
        }
        return false
    }

}
