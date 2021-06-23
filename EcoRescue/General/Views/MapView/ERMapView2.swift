//
//  ERMapView2.swift
//  EcoRescue
//
//  Created by Christoph Erl on 22.11.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

import MapKit

enum ERZoomLevel {
    case far, close
}

private let kDefaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)

class ERMapView2: MKMapView {

    init() {
        super.init(frame: CGRect.zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        showsCompass = false
        showsUserLocation = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public Methods
    
    func zoomAnnotationStepwise(annotation: MKAnnotation, contentInset: UIEdgeInsets, animated: Bool) {
        let latitudeDelta   = region.span.latitudeDelta     * 0.5
        let longitudeDelta  = region.span.longitudeDelta    * 0.5
        
        let span        = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        let newRegion   = MKCoordinateRegion(center: annotation.coordinate, span: span)
        let rect        = rectFor(region: newRegion)
        
        setVisibleMapRect(rect, edgePadding: contentInset, animated: animated)
    }
    
    func zoomAnnotation(annotation: MKAnnotation, contentInset: UIEdgeInsets, animated: Bool) {
        zoomCoordinate(coordinate: annotation.coordinate, contentInset: contentInset, animated: animated)
    }
    
    func zoomUserLocation(contentInset: UIEdgeInsets, animated: Bool) {
        zoomCoordinate(coordinate: userLocation.coordinate, contentInset: contentInset, animated: animated)
    }
    
    func zoomRoute(annotation: MKAnnotation, contentInset: UIEdgeInsets, animated: Bool) {
        
        var zoomRect = MKMapRectNull
        
        let point = MKMapPointForCoordinate(annotation.coordinate)
        let rect = MKMapRectMake(point.x, point.y, 0.1, 0.1)
        
        let userPoint = MKMapPointForCoordinate(userLocation.coordinate)
        let userRect = MKMapRectMake(userPoint.x, userPoint.y, 0.1, 0.1)
        
        zoomRect = MKMapRectUnion(zoomRect, rect)
        zoomRect = MKMapRectUnion(zoomRect, userRect)
        
        setVisibleMapRect(zoomRect, edgePadding: contentInset, animated: animated)
    }
    
    func zoomRoute(route: MKRoute, contentInset: UIEdgeInsets, animated: Bool) {
        
        var zoomRect = route.polyline.boundingMapRect
        setVisibleMapRect(zoomRect, edgePadding: contentInset, animated: animated)
    }
    
    // MARK: - Public Static Methods 
    

    
    // MARK: - Private Methods
    
    private func zoomCoordinate(coordinate: CLLocationCoordinate2D, contentInset: UIEdgeInsets, animated: Bool) {
        var newSpan = kDefaultSpan
        newSpan.latitudeDelta   = newSpan.latitudeDelta * Double(frame.height - contentInset.top - contentInset.bottom) / Double(frame.height)
        newSpan.longitudeDelta  = newSpan.longitudeDelta * Double(frame.width - contentInset.left - contentInset.right) / Double(frame.width)
        
        let region  = MKCoordinateRegion(center: coordinate, span: newSpan)
        let rect    = rectFor(region: region)
        setVisibleMapRect(rect, edgePadding: UIEdgeInsets.zero, animated: animated)
    }

}

extension MKMapView {
    
    func annotationViewFor(annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView: MKAnnotationView? = nil
            
            // Plaform < iOS 11
            
            if let _ = annotation as? Annotation.Defibrillator {
                annotationView = dequeueReusableAnnotationView(withIdentifier: ERImageAnnotationView.Defibrillator.id)
                if annotationView == nil {
                    annotationView = ERImageAnnotationView.Defibrillator(annotation: nil, reuseIdentifier: ERImageAnnotationView.Defibrillator.id)
                }
                
            } else if let _ = annotation as? Annotation.Emergency {
                annotationView = dequeueReusableAnnotationView(withIdentifier: ERImageAnnotationView.Emergency.id)
                if annotationView == nil {
                    annotationView = ERImageAnnotationView.Emergency(annotation: nil, reuseIdentifier: ERImageAnnotationView.Emergency.id)
                }
                
            } else if let _ = annotation as? Annotation.Hospital {
                annotationView = dequeueReusableAnnotationView(withIdentifier: ERImageAnnotationView.Hospital.id)
                if annotationView == nil {
                    annotationView = ERImageAnnotationView.Hospital(annotation: nil, reuseIdentifier: ERImageAnnotationView.Hospital.id)
                }
                
            } else if let _ = annotation as? Annotation.Firehouse {
                annotationView = dequeueReusableAnnotationView(withIdentifier: ERImageAnnotationView.Firehouse.id)
                if annotationView == nil {
                    annotationView = ERImageAnnotationView.Firehouse(annotation: nil, reuseIdentifier: ERImageAnnotationView.Firehouse.id)
                }
                
            } else if let _ = annotation as? Annotation.Doctor {
                annotationView = dequeueReusableAnnotationView(withIdentifier: ERImageAnnotationView.Doctor.id)
                if annotationView == nil {
                    annotationView = ERImageAnnotationView.Doctor(annotation: nil, reuseIdentifier: ERImageAnnotationView.Doctor.id)
                }
                
            } else if let _ = annotation as? Annotation.Dentist {
                annotationView = dequeueReusableAnnotationView(withIdentifier: ERImageAnnotationView.Dentist.id)
                if annotationView == nil {
                    annotationView = ERImageAnnotationView.Dentist(annotation: nil, reuseIdentifier: ERImageAnnotationView.Dentist.id)
                }
                
            } else if let _ = annotation as? Annotation.Pharmacy {
                annotationView = dequeueReusableAnnotationView(withIdentifier: ERImageAnnotationView.Pharmacy.id)
                if annotationView == nil {
                    annotationView = ERImageAnnotationView.Pharmacy(annotation: nil, reuseIdentifier: ERImageAnnotationView.Pharmacy.id)
                }
            }
            
            annotationView?.annotation = annotation
            return annotationView
    }
    
}

extension MKMapView {
    
    var northEast: CLLocationCoordinate2D? {
        let point = CGPoint(x: bounds.maxX, y: bounds.origin.y)
        let coord = convert(point, toCoordinateFrom: self)
        return coord.valid ? coord : nil
    }
    
    var southWest: CLLocationCoordinate2D? {
        let point = CGPoint(x: bounds.minX, y: bounds.maxY)
        let coord = convert(point, toCoordinateFrom: self)
        return coord.valid ? coord : nil
    }
    
    var edges: MKEdges? {
        
        let nePoint = CGPoint(x: bounds.maxX, y: bounds.origin.y)
        let swPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
        
        let neCoord = convert(nePoint, toCoordinateFrom: self)
        let swCoord = convert(swPoint, toCoordinateFrom: self)
        
        if neCoord.latitude > -90 && neCoord.latitude < 90 && swCoord.latitude > -90 && swCoord.latitude < 90 {
            return MKEdges(ne: neCoord, sw: swCoord)
        }
        
        return nil
    }
    
}

extension CLLocationCoordinate2D {
    
    var valid: Bool {
        return latitude > -90 && latitude < 90 && longitude > -180 && longitude < 180
    }
    
}

// MARK: - Structs

struct MKEdges {
    let ne: CLLocationCoordinate2D
    let sw: CLLocationCoordinate2D
}

extension MKMapView {
    
    var edges2: MKEdges2 {
        
        let nePoint = CGPoint(x: bounds.maxX, y: bounds.origin.y)
        let nwPoint = CGPoint(x: bounds.minX, y: bounds.origin.y)
        let sePoint = CGPoint(x: bounds.maxX, y: bounds.maxY)
        let swPoint = CGPoint(x: bounds.minX, y: bounds.maxY)
        
        let neCoord = convert(nePoint, toCoordinateFrom: self)
        let nwCoord = convert(nwPoint, toCoordinateFrom: self)
        let seCoord = convert(sePoint, toCoordinateFrom: self)
        let swCoord = convert(swPoint, toCoordinateFrom: self)
        
        return MKEdges2(ne: neCoord, sw: swCoord, nw: nwCoord, se: seCoord)
    }
    
}

// MARK: - Structs

struct MKEdges2 {
    let ne: CLLocationCoordinate2D
    let sw: CLLocationCoordinate2D
    let nw: CLLocationCoordinate2D
    let se: CLLocationCoordinate2D
}
