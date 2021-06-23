//
//  ERCertificateImageOverviewV2ViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 23.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import Parse

protocol ERCertificateImageOverviewV2ViewControllerDelegate: NSObjectProtocol {
    func viewImageViewController(shouldEdit: Bool, inCertificate: ERCertificate)
}

class ERCertificateImageOverviewV2ViewController: UIViewController {
    
    weak var delegate: ERCertificateImageOverviewV2ViewControllerDelegate?
    
    private let imageView = UIImageView.imageView()
    
    var certificate: ERCertificate!
    
    var file: PFFileObject? { didSet { setFile(oldValue: oldValue) } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        
        let deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(didTapEdit(sender:)))
        navigationItem.rightBarButtonItem = deleteBarButtonItem
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        view.addSubview(imageView)
        imageView.leftright(constant: UIViewPadding.big).bottom(of: topLayoutGuide, constant: UIViewPadding.big).top(of: bottomLayoutGuide, constant: UIViewPadding.big).apply()
        
    }
    
    private func setFile(oldValue: PFFileObject?) {
        if oldValue == file { return }
        
        ERImageManager.image(from: file!, completion: { (image, error) in
            self.imageView.image = image
        })
    }
    
    // MARK: - Actions
    
    func didTapEdit(sender: Any) {
        _ = navigationController?.popViewController(animated: true)
        
        delegate?.viewImageViewController(shouldEdit: true, inCertificate: certificate)
    }


}
