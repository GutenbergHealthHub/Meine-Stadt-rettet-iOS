//
//  ERSubContractOverviewV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 26.07.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERSubContractOverviewV2ViewController: ERContractOverviewV2ViewController {
    
    var userContractSub: ERUserContractSub? { didSet { setUserContractSub(oldValue: oldValue) } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    private func setUserContractSub(oldValue: ERUserContractSub?) {
        if userContractSub == oldValue { return }
        
        if let contract = userContractSub, let signature = contract.signature {
            title = contract.contract?.title
            
            ERImageManager.image(from: signature, completion: { (image, error) in
                self.signatureView.setContents(image: image, signDate: contract.signedAt)
            })
            
        } else {
            title = nil
        }
        
        reloadData(url: userContractSub?.contract?.url)
    }

}
