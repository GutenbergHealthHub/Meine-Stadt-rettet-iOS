//
//  ERSubContractEditV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 26.07.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERSubContractEditV2ViewController: ERContractEditV2ViewController {
    
    var subContract: ERContractSub? { didSet { setSubContract(oldValue: oldValue)    } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func setSubContract(oldValue: ERContractSub?) {
        if subContract == oldValue { return }
        
        if let subContract = subContract {
            title = subContract.title
        } else {
            title = nil
        }
        
        reloadData(url: subContract?.url)
    }
    
    override func didTapSign(sender: Any) {
        let vc = ERSubContractEditSignatureV2ViewController()
        vc.subContract = subContract
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
