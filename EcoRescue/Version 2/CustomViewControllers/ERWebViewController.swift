//
//  ERWebViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 19.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

enum ERWebViewControllerState {
    case loaded, loading, failed
}

class ERWebViewController: CenterMenuViewController, UCWebViewProtocol {
    
    var state: ERWebViewControllerState = .loaded { didSet { p_setState(oldValue: oldValue) } }

    private let loadView = ERDefaultEmptyView()
    private let failView = ERDefaultEmptyView()
    
    private let webView         = UCWebView()
    private let activityView    = UIView.initActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        
        // Activity View
        activityView.hidesWhenStopped = true
        
        failView.addTarget(target: self, selector: #selector(didTapReload(sender:)))
        
        webView.delegate = self
        
        view.addSubview(webView)
        
        webView.match().apply()
        
        // Bar Buttons
        let activityButtonItem = UIBarButtonItem(customView: activityView)
        navigationItem.rightBarButtonItem = activityButtonItem
        
        p_setState()
    }
    
    // MARK: - Public Methods
    
    func load(string: String) {
        if let url = URL(string: string) {
            load(url: url)
        }
    }
    
    func load(url: URL) {
        webView.load(url: url)
    }
    
    // MARK: - Actions
    
    func didTapReload(sender: Any) {
        webView.reload()
    }
    
    // MARK: - Computed Variables
    
    var loadViewTitle: String? {
        set { loadView.title = newValue }
        get { return loadView.title     }
    }
    
    var loadViewSubtitle: String? {
        set { loadView.subtitle = newValue }
        get { return loadView.subtitle     }
    }
    
    var loadViewButtonImage: UIImage? {
        set { loadView.buttonImage = newValue }
        get { return loadView.buttonImage     }
    }
    
    var loadViewIndicatorHidden: Bool {
        set { loadView.indicatorHidden = newValue }
        get { return loadView.indicatorHidden     }
    }
    
    var failViewTitle: String? {
        set { failView.title = newValue }
        get { return failView.title     }
    }
    
    var failViewSubtitle: String? {
        set { failView.subtitle = newValue }
        get { return failView.subtitle     }
    }
    
    var failViewButtonImage: UIImage? {
        set { failView.buttonImage = newValue }
        get { return failView.buttonImage     }
    }
    
    var failViewIndicatorHidden: Bool {
        set { failView.indicatorHidden = newValue }
        get { return failView.indicatorHidden     }
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
    
    // MARK: - Private Methods
    
    private func p_setState(oldValue: ERWebViewControllerState) {
        if oldValue == state { return }
        p_setState()
    }
    
    private func p_setState() {
        switch state {
        case .loaded:
            webView.emptyView = nil
            activityView.stopAnimating()
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
        
        didChangeState()
    }

    func didChangeState() {
        
    }
    
}
