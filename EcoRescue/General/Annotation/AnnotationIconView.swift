//
//  AnnotationIconView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 14.11.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit

class AnnotationIconView: View {
    
    private let imageView = UIImageView.imageView()

    override init() {
        super.init()
        backgroundColor = tintColor
        
        addSubview(imageView)
        imageView.height(multiplier: 0.6).widthEqualsHeight().centerXY().apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Attributes
    
    var image: UIImage? {
        set { imageView.image = newValue    }
        get { return imageView.image        }
    }
    
    // MARK: - Override
    
    override var tintColor: UIColor! {
        didSet {
            backgroundColor = tintColor
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.width / 2
    }
    
    // MARK: - Static Methods
    
    class func createFrom(annotation: Annotation) -> AnnotationIconView {
        let view = AnnotationIconView()
        
        switch annotation {
        case is Annotation.Defibrillator:
            view.image      = UIImage.iconMapDefibrillatorV2().image(color: UIColor.white)
            view.tintColor  = UIColor.defibrillator
            break
            
        case is Annotation.Emergency:
            view.image      = UIImage.iconEmergencySelected().image(color: UIColor.white)
            view.tintColor  = UIColor.emergency
            break
            
        case is Annotation.Hospital:
            view.image      = UIImage.iconMapHospitalV2().image(color: UIColor.white)
            view.tintColor  = UIColor.hospital
            break
            
        case is Annotation.Firehouse:
            view.image      = UIImage.iconMapFireStationV2().image(color: UIColor.white)
            view.tintColor  = UIColor.firehouse
            break
            
        case is Annotation.Doctor:
            view.image      = UIImage.iconMapDoctorV2().image(color: UIColor.white)
            view.tintColor  = UIColor.doctor
            break
            
        case is Annotation.Dentist:
            view.image      = UIImage.iconMapDentistV2().image(color: UIColor.white)
            view.tintColor  = UIColor.dentist
            break
            
        case is Annotation.Pharmacy:
            view.image      = UIImage.iconMapPharmacyV2().image(color: UIColor.white)
            view.tintColor  = UIColor.pharmacy
            break
            
        default:
            break
        }
        
        return view
    }

}
