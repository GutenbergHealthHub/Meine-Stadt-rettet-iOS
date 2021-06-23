//
//  AnnotationManager.swift
//  EcoRescue
//
//  Created by Christoph Erl on 25.12.17.
//  Copyright © 2017 Christoph Erl. All rights reserved.
//

import UIKit
import CoreLocation

protocol AnnotationsRequestDelegate: NSObjectProtocol {
    func annotationRequestDidBeginLoading(annotationsRequest: AnnotationsRequest)
    func annotationRequestDidFinishLoading(annotationsRequest: AnnotationsRequest, annotations: [Annotation]?, error: Error?)
}

class AnnotationsRequest: NSObject {
    
    var delegate: AnnotationsRequestDelegate?
    
    // MARK: - Public Methods
    
    func requestAnnotations(southWest: CLLocationCoordinate2D?, northEast: CLLocationCoordinate2D?, location: CLLocationCoordinate2D?, defibrillator: Bool, hospital: Bool, firehouse: Bool, doctor: Bool, dentist: Bool, pharmacy: Bool) {
        
        guard let northEast = northEast, let southWest = southWest, let location = location else {
            return
        }
        
        self.defiDone           = !defibrillator
        self.hospitalDone       = !hospital
        self.fireStationDone    = !firehouse
        self.doctorDone         = !doctor
        self.dentistDone        = !dentist
        self.pharmacyDone       = !pharmacy
        
        if running { cancel()  }
        running = true
        
        // Request Annotations
        var annotations = [Annotation]()

        // Hospital
        if !self.hospitalDone {
            placesHospitalRequest.requestPlaces(southWest: southWest, northEast: northEast, location: location) { (objects, error) in
                if let places = objects as? [Place] {
                    for place in places {
                        annotations.append(Annotation.Hospital(place: place))
                    }
                }
                self.hospitalDone = true
                self.p_completion(annotations: annotations)
            }
        }
        
        // Doctor
        if !self.doctorDone {
            placesDoctorRequest.requestPlaces(southWest: southWest, northEast: northEast, location: location) { (objects, error) in
                if let places = objects as? [Place] {
                    for place in places {
                        annotations.append(Annotation.Doctor(place: place))
                    }
                }
                self.doctorDone = true
                self.p_completion(annotations: annotations)
            }
        }
        
        // Dentist
        if !self.dentistDone {
            placesDentistRequest.requestPlaces(southWest: southWest, northEast: northEast, location: location) { (objects, error) in
                if let places = objects as? [Place] {
                    for place in places {
                        annotations.append(Annotation.Dentist(place: place))
                    }
                }
                self.dentistDone = true
                self.p_completion(annotations: annotations)
            }
        }
        
        // Fire Station
        if !self.fireStationDone {
            placesFireStationRequest.requestPlaces(southWest: southWest, northEast: northEast, location: location) { (objects, error) in
                if let places = objects as? [Place] {
                    for place in places {
                        annotations.append(Annotation.Firehouse(place: place))
                    }
                }
                self.fireStationDone = true
                self.p_completion(annotations: annotations)
            }
        }
        
        // Pharmacy
        if !self.pharmacyDone {
            placesPharmacyRequest.requestPlaces(southWest: southWest, northEast: northEast, location: location) { (objects, error) in
                if let places = objects as? [Place] {
                    for place in places {
                        annotations.append(Annotation.Pharmacy(place: place))
                    }
                }
                self.pharmacyDone = true
                self.p_completion(annotations: annotations)
            }
        }
        
        // Defibrillator
        if !self.defiDone {
            placesDefibrillatorRequest.requestPlaces(southWest: southWest, northEast: northEast) { (objects, error) in
                if let places = objects as? [ERDefibrillator] {
                    for place in places {
                        annotations.append(Annotation.Defibrillator(defibrillator: place))
                    }
                }
                self.defiDone = true
                self.p_completion(annotations: annotations)
            }
        }
    
    }
    
    func requestDefibrillators(southWest: CLLocationCoordinate2D?, northEast: CLLocationCoordinate2D?, completion: @escaping ([Annotation]?, Error?) -> ())  {
        
        guard let northEast = northEast, let southWest = southWest else {
            return
        }
        
        // Request Annotations
        var annotations = [Annotation]()
        
        // Defibrillator
        placesDefibrillatorRequest.requestPlaces(southWest: southWest, northEast: northEast) { (objects, error) in
            if let places = objects as? [ERDefibrillator] {
                for place in places {
                    annotations.append(Annotation.Defibrillator(defibrillator: place))
                }
            }
            completion(annotations, nil)
        }
        
    }
    
    func requestDefibrillatorsForEmergencyView(southWest: CLLocationCoordinate2D?, northEast: CLLocationCoordinate2D?, location: CLLocationCoordinate2D?, completion: @escaping ([Annotation]?, Error?) -> ())  {
        
        guard let northEast = northEast, let southWest = southWest, let location = location else {
            return
        }
        
        // Request Annotations
        var annotations = [Annotation]()
        
        // Defibrillator
        placesEmergencyDefibrillatorRequest.requestPlaces(southWest: southWest, northEast: northEast, location: location) { (objects, error) in
            if let places = objects as? [ERDefibrillator] {
                for place in places {
                    annotations.append(Annotation.Defibrillator(defibrillator: place))
                }
            }
            completion(annotations, nil)
        }
        
    }
    
    func cancel() {
        if running {
            running = false
            
            placesHospitalRequest.cancel()
            placesFireStationRequest.cancel()
            placesDoctorRequest.cancel()
            placesDentistRequest.cancel()
            placesPharmacyRequest.cancel()
            placesDefibrillatorRequest.cancel()
            
            DispatchQueue.main.async {
                self.delegate?.annotationRequestDidFinishLoading(annotationsRequest: self, annotations: nil, error: nil)
            }
        }
    }
    
    // MARK: - Private Methods
    
    private var running = false
    private var hospitalDone = false, fireStationDone = false, dentistDone = false, doctorDone = false, pharmacyDone = false, defiDone = false
    
    private let placesHospitalRequest       = PlacesGMSRequest(placeType: .hospital)
    private let placesFireStationRequest    = PlacesGMSRequest(placeType: .fireStation)
    private let placesDoctorRequest         = PlacesGMSRequest(placeType: .doctor)
    private let placesDentistRequest        = PlacesGMSRequest(placeType: .dentist)
    private let placesPharmacyRequest       = PlacesGMSRequest(placeType: .pharmacy)
    private let placesDefibrillatorRequest  = PlacesDefibrillatorRequest()
    private let placesEmergencyDefibrillatorRequest = PlacesEmergencyDefibrillatorRequest()
    
    private(set) var annotations            = [Annotation]()
    
    private func p_completion(annotations: [Annotation]) {
        if defiDone && hospitalDone && fireStationDone && doctorDone && dentistDone && pharmacyDone {
            self.annotations    = annotations
            self.running        = false
            
            DispatchQueue.main.async {
                self.delegate?.annotationRequestDidFinishLoading(annotationsRequest: self, annotations: annotations, error: nil)
            }
        }
    }
    
}
