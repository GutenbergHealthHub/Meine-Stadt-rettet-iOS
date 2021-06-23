//
//  ERImageAnnotationView.swift
//  EcoRescue
//
//  Created by Christoph Erl on 14.02.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import MapKit

class ERImageAnnotationView: ERAnnotationView {
    
    var icon: UIImage? { didSet { p_setImage(oldValue: oldValue) } }
    
    private let imageView = UIView.initImageView()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(imageView)
        imageView.match().apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func p_setImage(oldValue: UIImage?) {
        imageView.image = icon
    }

    // Emergency Annotaton View
    
    class Emergency: ERImageAnnotationView {
        
        static let id = "kERHospitalAnnoationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            self.tintColor  = UIColor.emergency
            self.icon       = UIImage.iconEmergencySelected().image(color: UIColor.white)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var emergencyAnnotation: Annotation.Emergency? {
            set { annotation = newValue                         }
            get { return annotation as? Annotation.Emergency    }
        }
        
    }
    
    // Defibrillator Annotaton View
    
    class Defibrillator: ERImageAnnotationView {
        
        static let id = "ERDefibrillatorAnnotationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            self.tintColor  = UIColor.defibrillator
            self.icon       = UIImage.iconMapDefibrillatorV2().image(color: UIColor.white)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var defibrillatorAnnotation: Annotation.Defibrillator? {
            set { annotation = newValue                             }
            get { return annotation as? Annotation.Defibrillator    }
        }
        
    }
    
    // Firehouse Annotaton View
    
    class Firehouse: ERImageAnnotationView {
        
        static let id = "ERFirehouseAnnotationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            self.tintColor  = UIColor.firehouse
            self.icon       = UIImage.iconMapFireStationV2().image(color: UIColor.white)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var firehouseAnnotation: Annotation.Firehouse? {
            set { annotation = newValue                       }
            get { return annotation as? Annotation.Firehouse  }
        }
        
    }
    
    // Hospital Annotaton View
    
    class Hospital: ERImageAnnotationView {
        
        static let id = "kERHospitalAnnoationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            self.tintColor  = UIColor.hospital
            self.icon       = UIImage.iconMapHospitalV2().image(color: UIColor.white)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var hospitalAnnotation: Annotation.Hospital? {
            set { annotation = newValue                     }
            get { return annotation as? Annotation.Hospital }
        }
        
    }
    
    // Hospital Annotaton View
    
    class Dentist: ERImageAnnotationView {
        
        static let id = "ERDentistAnnotationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            self.tintColor  = UIColor.dentist
            self.icon       = UIImage.iconMapDentistV2().image(color: UIColor.white)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var dentistAnnotation: Annotation.Dentist? {
            set { annotation = newValue                         }
            get { return annotation as? Annotation.Dentist      }
        }
        
    }
    
    // Hospital Annotaton View
    
    class Doctor: ERImageAnnotationView {
        
        static let id = "ERDoctorAnnotationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            self.tintColor  = UIColor.doctor
            self.icon       = UIImage.iconMapDoctorV2().image(color: UIColor.white)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var doctorAnnotation: Annotation.Doctor? {
            set { annotation = newValue                     }
            get { return annotation as? Annotation.Doctor   }
        }
        
    }
    
    // Hospital Annotaton View
    
    class Pharmacy: ERImageAnnotationView {
        
        static let id = "kERHospitalAnnoationView"
        
        override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
            super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
            self.tintColor  = UIColor.pharmacy
            self.icon       = UIImage.iconMapPharmacyV2().image(color: UIColor.white)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        var pharmacyAnnotation: Annotation.Pharmacy? {
            set { annotation = newValue                         }
            get { return annotation as? Annotation.Pharmacy     }
        }
        
    }
    
}
