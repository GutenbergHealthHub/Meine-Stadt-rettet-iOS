//
//  ERCertificateOverviewV2ViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 17.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERCertificateOverviewV2ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ERCertificateImageOverviewV2ViewControllerDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let certificateFRCell = ERCertificateCell()
    
    private let tableViewCellAddCertificate = TableViewCell()
    
    private var optionalCertificates = [ERCertificate]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        
        tableView.autoLayout = true
        tableView.delegate   = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        tableView.match().apply()
        
        tableView.register(ERCertificateCell.self, forCellReuseIdentifier: ERCertificateCell.id)
        
        tableViewCellAddCertificate.title = String.ADD_ADDITIONAL_CERTIFICATES
        tableViewCellAddCertificate.accessoryType  = .disclosureIndicator
        tableViewCellAddCertificate.selectionStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadData()
    }
    
    private func reloadData() {
        if let certificateFR = ERUser.current()?.certificateFR {
            certificateFRCell.certificate = certificateFR
        }
        
        // Optional Certificates
        optionalCertificates = (ERUser.current()?.certificates ?? []).sorted(by: { (c1, c2) -> Bool in
            if let d1 = c1.updatedAt, let d2 = c2.updatedAt {
                return d1 > d2
            }
            return false
        })
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
            
        // Mandatory
        case 0:
            return String.CERTIFICATE
            
        // Optional
        default:
            return String.OPTIONAL_CERTIFICATES
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            return optionalCertificates.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return certificateFRCell
        default:
            switch indexPath.row {
                
            case optionalCertificates.count:
                return tableViewCellAddCertificate
                
            default:
                let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ERCertificateCell.id) as! ERCertificateCell
                tableViewCell.certificate = optionalCertificates[indexPath.row]
                return tableViewCell
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell == tableViewCellAddCertificate {
                let vc = ERCertificateEditV2ViewController()
                vc.certificateType = .other
                navigationController?.pushViewController(vc, animated: true)
                
            } else {
                let vc = ERCertificateImageOverviewV2ViewController()
                vc.delegate = self
                
                if cell == certificateFRCell, let certificateFR = ERUser.current()?.certificateFR {
                    vc.file = certificateFR.file
                    vc.certificate = certificateFR
                } else {
                    vc.file = optionalCertificates[indexPath.row].file
                    vc.certificate = optionalCertificates[indexPath.row]
                }
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let cell = tableView.cellForRow(at: indexPath)
        return indexPath.section == 1 && cell != tableViewCellAddCertificate
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            deleteCertificate(optionalCertificates[indexPath.row], completion: { (success) in
                if success {
                    self.optionalCertificates.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
    }
    
    // MARK: ERCertificateImageOverviewV2ViewControllerDelegate
    
    func viewImageViewController(shouldEdit: Bool, inCertificate: ERCertificate) {
        if shouldEdit {
            let vc = ERCertificateEditV2ViewController()
            vc.certificate = inCertificate
            vc.certificateType = inCertificate.typeValue
            navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    private func deleteCertificate(_ certificate: ERCertificate, completion: @escaping (_ result: Bool) -> Void) {
        certificate.deleteInBackground(block: { (success, error) in
            if success {
                if let user = ERUser.current() {
                    
                    // Remove File To Certificate & Remove Certificate To User
                    user.remove(certificate: certificate)
                    user.saveInBackground(block: { (success, error) in
                        completion(true)
                        self.saveCompletionHandler(certificate: certificate, error: error)
                    })
                    
                } else {
                    completion(false)
                    self.saveCompletionHandler(certificate: nil, error: NSError())
                }
            } else {
                completion(false)
                self.saveCompletionHandler(certificate: nil, error: error)
            }
        })
    }
    
    private func saveCompletionHandler(certificate: ERCertificate?, error: Error?) {
        
        if error != nil {
           self.present(UIAlertController.createCertificateSavingErrorController(), animated: true, completion: nil)
            
        } else {
            
            // Pin Data
            let savedController = UIAlertController.createCertificateSavingSuccessController(completion: {
                
            })
            self.present(savedController, animated: true, completion: nil)
        }
    }
    
}

private class ERCertificateCell: UITableViewCell {
    
    static let id = "CertificateTableViewCell"
    
    var certificate: ERCertificate? { didSet { setCertificate(oldValue: oldValue) } }
    
    // MARK: - Initialise
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.accessoryType  = .disclosureIndicator
        setResponderState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCertificate(oldValue: ERCertificate?) {
        guard let certificate = certificate else { return }
        
        self.textLabel?.text = ERCertificateType.stringWith(type: certificate.typeValue)
        if certificate.typeValue == .firstResponder {
            setResponderState()
        }
    }
    
    private func setResponderState() {
        if let certificate = certificate {
            self.detailTextLabel?.text = certificate.stateString
            
            switch certificate.stateValue {
            case .create:
                imageView?.image = Icon(type: .attention).toImage()
                imageView?.tintColor = UIColor.neutral
            case .denied:
                imageView?.image = Icon(type: .cancel).toImage()
                imageView?.tintColor = UIColor.negativ
            case .review:
                imageView?.image = Icon(type: .attention).toImage()
                imageView?.tintColor = UIColor.neutral
            case .verified:
                imageView?.image = Icon(type: .ok).toImage()
                imageView?.tintColor = UIColor.positive
            }
        }
    }
}
