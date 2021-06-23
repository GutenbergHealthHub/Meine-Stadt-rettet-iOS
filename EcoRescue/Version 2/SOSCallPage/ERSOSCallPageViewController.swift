//
//  ERSOSCallPageViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 08.11.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit
import MapKit

class ERSOSCallPageViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    private let mapView = MKMapView()
    
    private let addressLabel = UILabel.type2Label()
    
    private let locationLabel = UILabel.type2Label()
    
    private var locationManager: CLLocationManager!
    
    private let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    private var isCalled: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        // topView
        let topView = UIView.view()
        view.addSubview(topView)
        topView.top().leftright().height(constant: 44 + statusBarHeight).apply()
        topView.backgroundColor = UIColor.colorPrimaryBlue
        
        // topView - emergencyLabel
        let emergencyLabel = UILabel.type1BoldLabel(.headline)
        topView.addSubview(emergencyLabel)
        emergencyLabel.bottom(constant: UIViewPadding.medium).centerX().apply()
        emergencyLabel.text = String.EMERGENCY_CALL
        emergencyLabel.textColor = UIColor.white
        
        // topView - indicatorView
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(indicatorView)
        indicatorView.bottom(constant: UIViewPadding.big).right(constant: UIViewPadding.medium).apply()
        indicatorView.hidesWhenStopped = true
        
        // titleLabel
        let titleLabel = UILabel.type2BoldLabel()
        view.addSubview(titleLabel)
        titleLabel.centerX().bottom(of: topView, constant: UIViewPadding.big).apply()
        titleLabel.text = String.YOUR_CURRENT_POSITION
        
        // mapView
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.bottom(of: titleLabel, constant: UIViewPadding.big).leftright().height(multiplier: 0.4).apply()
        
        // addressContainerView
        let addressContainerView = UIView.view()
        view.addSubview(addressContainerView)
        addressContainerView.bottom(of: mapView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.large).height(constant: UITextFieldHeight.forScreenSize * 1.5).apply()
        
        // addressContainerView - addressTitleLabel
        let addressTitleLabel = UILabel.type2SemiBoldLabel()
        addressContainerView.addSubview(addressTitleLabel)
        addressTitleLabel.centerY().left().apply()
        addressTitleLabel.text = "\(String.ADDRESS):"
        
        // addressContainerView - addressLabel
        addressContainerView.addSubview(addressLabel)
        addressLabel.right(of: addressTitleLabel, constant: UIViewPadding.medium).topbottom().width(constant: 200).apply()
        addressLabel.numberOfLines   = 2
        addressLabel.lineBreakMode   = .byTruncatingTail
        
        // addressContainerView - separatorView1
        let separatorView1 = UIView.seperatorView()
        addressContainerView.addSubview(separatorView1)
        separatorView1.bottom().leftright().height(constant: 1).apply()
        
        // locationContainerView
        let locationContainerView = UIView.view()
        view.addSubview(locationContainerView)
        locationContainerView.bottom(of: addressContainerView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.large).height(constant: UITextFieldHeight.forScreenSize * 1.5).apply()
        
        // locationContainerView - locationTitleLabel
        let locationTitleLabel = UILabel.type2SemiBoldLabel()
        locationContainerView.addSubview(locationTitleLabel)
        locationTitleLabel.centerY().left().apply()
        locationTitleLabel.text = String.GEO_LOCATION
        
        // locationContainerView - locationLabel
        locationContainerView.addSubview(locationLabel)
        locationLabel.right(of: locationTitleLabel, constant: UIViewPadding.medium).centerY().apply()
        
        // locationContainerView - separatorView2
        let separatorView2 = UIView.seperatorView()
        locationContainerView.addSubview(separatorView2)
        separatorView2.bottom().leftright().height(constant: 1).apply()
        
        // backButton
        let backButton = ERButton()
        view.addSubview(backButton)
        backButton.bottom(constant: UIViewPadding.large).leftright(constant: UIViewPadding.big).height(constant: 44).apply()
        backButton.text = String.GO_BACK
        backButton.backgroundColor = UIColor.colorPrimaryRedV2
        backButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(didTapBack(sender:)), for: .touchDown)
        
        // Manager
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        
        locationManager.startUpdatingLocation()
        indicatorView.startAnimating()
        
        
    }
    
    private func notify(address: UCAddress, coordinate: CLLocationCoordinate2D) {

        self.addressLabel.text  = address.addressLinesString
        let lat = Float(coordinate.latitude)
        let lon = Float(coordinate.longitude)
        self.locationLabel.text = String(format: "%.05f, %.05f", lat, lon)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        // Center Coordinates
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.mapView.setCenter(coordinate, animated: true)
            self.zoomCoordinate(coordinate: coordinate, contentInset: self.contentInsets, animated: true)
        }
    }
    
    private func notify(coordinate: CLLocationCoordinate2D, completion: (()->())? = nil) {
        MKMapView.address(coordinate: coordinate, closure: { (address) in
            self.notify(address: address ?? UCAddress(), coordinate: coordinate)
            completion?()
        })
    }
    
    // MARK: - Zoom
    private var contentInsets: UIEdgeInsets {
        let top         = topLayoutGuide.length + 44 + statusBarHeight + 2 * UIViewPadding.big
        let bottom      = view.frame.height - mapView.frame.height + top
        let leftright   = UIViewPadding.large
        return UIEdgeInsets(top: top, left: leftright, bottom: bottom, right: leftright)
    }
    
    private func zoomCoordinate(coordinate: CLLocationCoordinate2D, contentInset: UIEdgeInsets, animated: Bool) {
        var newSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        newSpan.latitudeDelta   = newSpan.latitudeDelta * Double(mapView.frame.height - contentInset.top - contentInset.bottom) / Double(mapView.frame.height)
        newSpan.longitudeDelta  = newSpan.longitudeDelta * Double(mapView.frame.width - contentInset.left - contentInset.right) / Double(mapView.frame.width)
        
        let region  = MKCoordinateRegion(center: coordinate, span: newSpan)
        let rect    = p_MKMapRectForCoordinateRegion(region: region)
        mapView.setVisibleMapRect(rect, edgePadding: UIEdgeInsets.zero, animated: animated)
    }
    
    private func p_MKMapRectForCoordinateRegion(region: MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))
        
        let a = MKMapPointForCoordinate(topLeft)
        let b = MKMapPointForCoordinate(bottomRight)
        
        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
    // MARK: MKMapViewDelegate
    private let ann_id = "Pin"
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            var view: MKAnnotationView! = mapView.dequeueReusableAnnotationView(withIdentifier: ann_id)
            if view == nil {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: ann_id)
                view.isDraggable = true
            }
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        
        if let coordinate = view.annotation?.coordinate, newState == MKAnnotationViewDragState.ending {
            notify(coordinate: coordinate)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //updateAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.first, !isCalled {
            isCalled = true
            notify(coordinate: location.coordinate, completion: {
                self.indicatorView.stopAnimating()
                self.callEmergency()
            })
        } else {
            indicatorView.stopAnimating()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //isRequestingLocation = false
        
        let alertController = UIAlertController(title: String.LOCALIZATION_ERROR, message: nil, preferredStyle: .alert)
        alertController.message = String.LOCATION_ERROR_DETAIL
        alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: Actions
    
    func didTapBack(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func callEmergency() {
        UCUtil.call(number: "112")
    }


}
