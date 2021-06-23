//
//  ERProtocolOverviewTableViewCell.swift
//  EcoRescueASB
//
//  Created by Birtan on 27.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit

class ERProtocolOverviewTableViewCell: UITableViewCell {
    
    static let id = "ERProtocolOverviewTableViewCell"
    
    var emergencyState: EREmergencyState? { didSet { setEmergencyState() } }
    
    private let snapshotManager = UCMapSnapshotManager()
    private var snapshots       = [EREmergencyState: UIImage?]()
    
    private let dateFormatter = DateFormatter()
    
    private let imgView         = UIImageView.imageView()
    
    private let addressLabel = UILabel.type2Label()
    private let statusLabel  = UILabel.type2Label()
    
    private let dateLabel = UILabel.type2LightLabel()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(imgView)
        addSubview(addressLabel)
        addSubview(statusLabel)
        addSubview(dateLabel)
        
        
        //imgView
        imgView.left(constant: 0).height(constant: 80).widthEqualsHeight().topbottom().apply()
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        imgView.clipsToBounds = true
        
        //statusLabel
        statusLabel.right(constant: UIViewPadding.big).centerY().apply()
        statusLabel.numberOfLines = 1
        
        //addressLabel
        addressLabel.top(constant: UIViewPadding.medium).right(of: imgView, constant: UIViewPadding.big).left(of: statusLabel, constant: UIViewPadding.medium, relatedBy: .lessThanOrEqual).apply()
        addressLabel.numberOfLines = 2
        addressLabel.lineBreakMode = .byTruncatingTail
        
        //dateLabel
        dateLabel.bottom(of: addressLabel, constant: UIViewPadding.small).bottom(constant: UIViewPadding.small).right(of: imgView, constant: UIViewPadding.big).apply()
        
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setEmergencyState() {
        reloadData()
    }
    
    func reloadData() {
        if let emergencyState = emergencyState, let createdAt = emergencyState.createdAt, let coordinate = emergencyState.emergencyRelation?.locationPoint?.coordinate {
            
            self.addressLabel.text = emergencyState.emergencyRelation.address.addressLinesString
            
            self.dateLabel.text = dateFormatter.string(from: createdAt)
            
            self.statusLabel.text      = emergencyState.stateDescriptionShort
            self.statusLabel.textColor = emergencyState.stateColor

            if let image = snapshots[emergencyState] {
                self.imgView.image = image
                
            } else {
                snapshotManager.createImageFrom(coordinate: coordinate, distance: 2000, completion: { (image, error) in
                    self.snapshots[emergencyState] = image
                    self.imgView.image = image
                })
            }
            
            
            
        }
    }

}
