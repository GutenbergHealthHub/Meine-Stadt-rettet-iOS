//
//  ERSettingsWebViewController.swift
//  EcoRescue
//
//  Created by Christoph Erl on 23.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class ERSettingsWebViewController: ERWebViewController, ERDataManagerDelegate {
    
    private let dataManager = ERDataManager.sharedManager

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dataManager.addObserver(self)
        p_reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dataManager.removeObserver(self)
    }
    
    // MARK: - Override
    
    override func didTapReload(sender: Any) {
        p_reloadData()
    }
    
    func getURLType() -> ERURLType {
        return .none
    }
    
    // MARK: - ERDataManagerDelegate
    
    func dataManagerDidBeginLoadURLs(dataManager: ERDataManager) {
        state = .loading
    }
    
    func dataManagerDidEndLoadURLs(dataManager: ERDataManager, urls: [ERURL]?, error: Error?) {
        if let _ = error {
            state = .failed
        } else {
            p_reloadData()
        }
    }
    
    // MARK: - Private Methods
    
    private func p_reloadData() {
        if dataManager.isLoadingURLs {
            state = .loading
        }
        
        if let url = dataManager.urls[getURLType()]?.localizedUrlString {
            load(string: url)
        } else {
            dataManager.findURLs()
        }
    }

}
