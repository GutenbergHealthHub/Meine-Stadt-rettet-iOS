//
//  ERContractEditV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 23.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class ERContractEditV2ViewController: UIViewController, UCWebViewProtocol {
    
    var contract: ERContract? { didSet { setContract(oldValue: oldValue)    } }
    
    private let webView      = UCWebView()
    private let activityView = UIView.initActivityIndicatorView(activityIndicatorStyle: .gray)
    private let loadView     = ERDefaultEmptyView()
    private let failView     = ERDefaultEmptyView()
    
    private var state    = ERWebViewControllerState.loaded { didSet { setState(oldValue: oldValue) } }
    
    private let signButton = ERButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor    = UIColor.background
        
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
        webView.delegate = self
        view.addSubview(webView)
        webView.match().apply()
        
        //Sign Button
        view.addSubview(signButton)
        signButton.centerX().bottom(constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).height(constant: 44).apply()
        signButton.text = String.SIGN_AGREEMENT
        signButton.addTarget(self, action: #selector(didTapSign(sender:)), for: .touchDown)
        signButton.alpha = 0
        
        // Activity View
        activityView.hidesWhenStopped = true
        
        setState()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData(url: nil)
    }
    
    private func setState(oldValue: ERWebViewControllerState) {
        if oldValue == state { return }
        setState()
    }
    
    private func setState() {
        switch state {
        case .loaded:
            webView.emptyView = nil
            activityView.stopAnimating()
            signButton.alpha = 1
            break
            
        case .loading:
            webView.emptyView = loadView
            activityView.startAnimating()
            break
            
        case .failed:
            webView.emptyView = failView
            activityView.stopAnimating()
            break
        }
    }
    
    private func setContract(oldValue: ERContract?) {
        if contract == oldValue { return }
        
        if let contract = contract {
            title = contract.title
        } else {
            title = nil
        }
        
        reloadData(url: contract?.url)
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
    
    func didTapSign(sender: Any) {
        let vc = ERContractEditSignatureV2ViewController()
        vc.contract = contract
        self.navigationController?.pushViewController(vc, animated: true)
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
