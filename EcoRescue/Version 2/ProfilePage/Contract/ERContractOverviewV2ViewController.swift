//
//  ERContractOverviewV2ViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 12.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit

class ERContractOverviewV2ViewController: UITableViewController, UCWebViewProtocol {
    
    var contract: ERUserContract? { didSet { setContract(oldValue: oldValue) } }
    
    let signatureView = SignatureCellView()
    
    private let cellContract  = UITableViewCell(style: .default, reuseIdentifier: nil)
    private let cellSignature = UITableViewCell(style: .default, reuseIdentifier: nil)
    
    private let webView      = UCWebView()
    private let activityView = UIView.initActivityIndicatorView(activityIndicatorStyle: .gray)
    private let loadView     = ERDefaultEmptyView()
    private let failView     = ERDefaultEmptyView()
    
    private var state    = ERWebViewControllerState.loaded { didSet { setState(oldValue: oldValue) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        // Empty View
        failView.indicatorHidden    = true
        failView.title              = String.DECLARATION
        failView.subtitle           = String.DECLARATION_NOT_LOADED
        failView.buttonImage        = UIImage.iconRepeat()
        failView.addTarget(target: self, selector: #selector(didTapReload(sender:)))
        
        loadView.indicatorHidden    = false
        loadView.title              = String.DECLARATION
        loadView.subtitle           = String.DECLARATION_LOADING
        loadView.buttonImage        = nil
        
        // Web View
        cellContract.contentView.addSubview(webView)
        webView.delegate = self
        webView.match().apply()
        
        // Signature View
        cellSignature.contentView.addSubview(signatureView)
        signatureView.match().apply()
        
        // Activity View
        activityView.hidesWhenStopped = true
        
        setState()
        
        //reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return cellContract
        default:
            return cellSignature
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height
        }
        return 200
    }
    
    private func setWebViewContentHeight(oldValue: CGFloat) {
       // if webViewContentHeight == oldValue { return }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func setContract(oldValue: ERUserContract?) {
        if contract == oldValue { return }
        
        if let contract = contract, let signature = contract.signature {
            title = contract.contract?.title
            
            ERImageManager.image(from: signature, completion: { (image, error) in
                self.signatureView.setContents(image: image, signDate: contract.signedAt)
            })
            
        } else {
            title = nil
        }
        
        reloadData(url: contract?.contract?.url)
    }
    
    private func setState(oldValue: ERWebViewControllerState) {
        if oldValue == state { return }
        setState()
    }
    
    private func setState() {
        switch state {
        case .loaded:
            webView.emptyView = nil
            //self.webViewContentHeight = webView.contentSize.height
            activityView.stopAnimating()
            break
            
        case .loading:
            webView.emptyView = loadView
            //self.webViewContentHeight = self.view.frame.height
            activityView.startAnimating()
            break
            
        case .failed:
            webView.emptyView = failView
            //self.webViewContentHeight = self.view.frame.height
            activityView.stopAnimating()
            break
        }
    }
    
    func reloadData(url: String?) {
        state = .loading
        
        if let url = url {
            webView.load(string: url)
        } else {
            state = .failed
        }
    }
    
    // MARK: - Actions
    
    func didTapReload(sender: Any) {
        webView.reload()
    }
    
    // MARK: - UCWebViewProtocol
    
    func webViewDidStartLoad(webView: UCWebView) {
        state = .loading
    }
    
    func webViewDidFinishLoad(webView: UCWebView) {
        state = .loaded
    }
    
    func webViewDidFailWithError(webView: UCWebView, error: Error) {
        state = .failed
    }
    
}

class SignatureCellView: UIView {
    
    let imageView = UIImageView.imageView()
    let signLabel = UILabel.type2LightLabel()
    
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(signLabel)
        
        imageView.top(constant: UIViewPadding.large).leftright(constant: UIViewPadding.large).bottom(constant: 2 * UIViewPadding.large).apply()
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFit
        
        signLabel.right(constant: UIViewPadding.small).bottom(constant: UIViewPadding.small).apply()
        signLabel.numberOfLines = 1
        signLabel.textAlignment = .right
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setContents(image: UIImage?, signDate: Date?) {
        imageView.image = image
        
        if let signDate = signDate {
            // Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .long
            
            signLabel.text = "\(String.SIGNED_ON) \(dateFormatter.string(from: signDate))"
        }
    }

    
}
