//
//  ERMapV2InfoViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 17.12.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit
import MapKit
import SafariServices

class ERMapV2InfoViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ERMapInfoBarDelegate {
    
    private let mapView = ERMapView2()
    
    private let tableView = FixedTableView(style: .grouped)
    private let toolbar   = ERMapInfoBar(position: .bottom)
    
    private let titleTableViewCell   = TitleTableViewCell()
    private let addressTableViewCell = TitleDetailTableViewCell()
    
    private var tableViewCells: [UITableViewCell] = []
    
    var annotation: Annotation!
    
    var phoneNumber: String?
    var url: String?
    
    fileprivate var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.background
        
        view.addSubview(mapView)
        mapView.top().leftright().height(multiplier: 0.3).apply()
        mapView.delegate = self
        mapView.isUserInteractionEnabled = true
        
        view.addSubview(tableView)
        tableView.bottom(of: mapView, constant: 0).leftright().bottom().apply()
        
        
        view.addSubview(toolbar)
        toolbar.bottom().leftright().height(constant: 54).apply()
        toolbar.subtitle            = String.NAVIGATE_WITH_APPLE_MAPS
        toolbar.annotation          = annotation
        toolbar.delegate            = self
        toolbar.infoButtonHidden    = true
        
        setTableViewSections()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.showsUserLocation = true
        zoom(animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.showsUserLocation = false
    }
    
    private func setTableViewSections() {
        let section0 = FixedTableViewSection()
        
        addressTableViewCell.isUserInteractionEnabled = false
        titleTableViewCell.isUserInteractionEnabled = false
        
        addressTableViewCell.title = String.ADDRESS
        
        if annotation is Annotation.PlaceAnnotation {
            
            let place = (annotation as! Annotation.PlaceAnnotation).place
            titleTableViewCell.title      = place.name
            addressTableViewCell.subtitle = place.vicinity ?? String.UNKNOWN
            
            let phoneTableViewCell = TitleDetailTableViewCell()
            let urlTableViewCell   = TitleDetailTableViewCell()
            
            phoneTableViewCell.subtitle = place.phone ?? String.UNKNOWN
            phoneTableViewCell.title    = String.PHONE
            
            urlTableViewCell.subtitle    = place.website ?? String.UNKNOWN
            urlTableViewCell.title       = String.URL
            
            if let placeId = place.id {
                PlacesGMSRequest.requestPlace(placeId: placeId, placeType: place.type,completion: { (place, error) in
                    if let place = place as? Place {
                        self.addressTableViewCell.subtitle = place.formattedAddress
                        phoneTableViewCell.subtitle   = place.phone ?? String.UNKNOWN
                        urlTableViewCell.subtitle     = place.website ?? String.UNKNOWN
                        self.phoneNumber = place.phone
                        self.url = place.website
                    } else {
                        print(error ?? "")
                    }
                })
            }
            
            tableViewCells.append(titleTableViewCell)
            tableViewCells.append(addressTableViewCell)
            tableViewCells.append(phoneTableViewCell)
            tableViewCells.append(urlTableViewCell)
            section0.tableViewCells = [(titleTableViewCell, nil), (addressTableViewCell, nil), (phoneTableViewCell, didTapPhoneCell), (urlTableViewCell, didTapUrlCell)]
            
        } else {
            let defiAnnotation = annotation as! Annotation.Defibrillator
            titleTableViewCell.title = String.DEFIBRILLATOR
            
            addressTableViewCell.subtitle = defiAnnotation.defibrillator.address?.addressLinesString
            
            let defiTableViewCell   = TitleDetailTableViewCell()
            let section2 = FixedTableViewSection()
            section2.tableViewCells = [(defiTableViewCell, nil)]
            
            defiTableViewCell.title = String.NOTE
            defiTableViewCell.isUserInteractionEnabled = false
            
            if let information = defiAnnotation.defibrillator.information {
                defiTableViewCell.subtitle = information
            } else {
                defiTableViewCell.subtitle = String.NO_INFORMATION
            }
            
            tableViewCells.append(titleTableViewCell)
            tableViewCells.append(addressTableViewCell)
            tableViewCells.append(defiTableViewCell)
            section0.tableViewCells = [(titleTableViewCell, nil), (addressTableViewCell, nil), (defiTableViewCell, nil)]
        }
        
        tableView.sections = [section0]
        
    }
    
    // MARK: - Actions
    
    func didTapPhoneCell(sender: Any) {
        if let phoneNumber = phoneNumber {
            UCUtil.call(number: phoneNumber)
        }
    }
    
    func didTapUrlCell(sender: Any) {
        if let url = URL(string: url ?? "") {
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }
    }
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.theme
        renderer.lineWidth = 3
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return mapView.annotationViewFor(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if firstTime {
            zoom(animated: false)
            firstTime = false
        }
    }
    
    private func zoom(animated: Bool) {
        if let annotation = annotation, firstTime, mapView.userLocation.coordinate != CLLocationCoordinate2D(latitude: 0, longitude: 0) {
            
            // Zoom Annotation
            self.mapView.showAnnotations([annotation], animated: animated)
            //zoomAnnotation(annotation: annotation, contentInset: mapContentInsets, animated: false)
            
            self.mapView.alpha = 1
            
            // Load Route
            reloadRoute(animated: animated)
        }
    }
    
    private func reloadRoute(animated: Bool) {
        guard let annotation = annotation else { return }
        
        toolbar.titleColor = UIColor.separator
        toolbar.title = String.ROUTE_IS_CALCULATED
        
        mapView.route(coordinate: annotation.coordinate, transportType: .walking, completition: { (route, error) in
            self.mapView.removeOverlays(self.mapView.overlays)
            
            // Title Color
            self.toolbar.titleColor = UIColor.black
            
            // Add Route
            if let route = route {
                
                if route.distance < EcoRescueConfig.RouteDistanceTreshold {
                    self.mapView.add(route.polyline)
                    self.mapView.zoomRoute(route: route, contentInset: self.mapContentInsets, animated: animated)
                } else {
                    self.mapView.zoomAnnotation(annotation: annotation, contentInset: self.mapContentInsets, animated: animated)
                }
                
                let numberFormatter = NumberFormatter()
                numberFormatter.maximumFractionDigits = 0
                
                let number = NSNumber(value: route.expectedTravelTime / 60)
                
                self.toolbar.title = String(format: String.X_MIN_TO_WALK, numberFormatter.string(from: number) ?? "")
                
            } else {
                self.toolbar.title      = String.ROUTE_UNKNOWN
            }
            
        })
    }
    
    // MARK: - ERMapInfoBarDelegate
    func mapInfoBarDidTapNavigate(ERMapInfoBar: ERMapInfoBar, annotation: Annotation) {
        MKMapView.pushAppleMaps(coordinate: annotation.coordinate)
    }
    
    private var mapContentInsets: UIEdgeInsets {
        let padding = UIViewPadding.large
        return UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
    }


}
