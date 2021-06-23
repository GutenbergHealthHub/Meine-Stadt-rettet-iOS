//
//  EREmergencyCallAEDTaskMapV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 16.05.19.
//  Copyright © 2019 Birtan Gültekin. All rights reserved.
//

import UIKit
import MapKit

class EREmergencyCallAEDTaskMapV2ViewController: EREmergencyCallMapV2ViewController {
    
    private var routes: [MKRoute] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Overriden functions
    //drawing route
    override func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        if (overlay is MKPolyline) {
            if let aedAnnotations = aedAnnotations, !aedAnnotations.isEmpty {
                renderer.strokeColor = (mapView.overlays.count == 1 ) ? UIColor.colorDarkGreen : UIColor.colorPrimaryRedV2
            } else {
                renderer.strokeColor = UIColor.colorPrimaryRedV2
            }
        }
        renderer.lineWidth = 3
        return renderer
    }
    
    override func reloadRoute(animated: Bool) {
        
        if let aedAnnotations = aedAnnotations, !aedAnnotations.isEmpty {
            routeToDefibrillator { (error) in
                self.mapView.route(fromCoordinate: self.aedAnnotations!.first!.coordinate, toCoordinate: self.annotation!.coordinate, transportType: .walking, completition: { (route, error) in
                    if let route = route {
                        self.routes.append(route)
                        self.mapView.add(route.polyline)
                        self.totalRouteCalculation()
                    }
                })
            }
        } else {
            super.reloadRoute(animated: true)
        }
        
    }
    
    private func routeToDefibrillator(completion: @escaping ((_ error: NSError?) -> ())) {
        mapView.route(coordinate: aedAnnotations!.first!.coordinate, transportType: .walking) { (route, error) in
            self.mapView.removeOverlays(self.mapView.overlays)
            self.routes.removeAll()
            
            if let route = route {
                self.routes.append(route)
                self.mapView.add(route.polyline)
                
                completion(error)
            }
        }
    }
    
    private func totalRouteCalculation() {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0

        var time = 0
        var distance = 0
        
        for route in routes {
            time += NSNumber(value: route.expectedTravelTime / 60).intValue
            distance += Int(route.distance)
        }
        
        self.containerView.distanceValLabel.text = "\(distance) m"
        self.containerView.timeValLabel.text     = "\(time) min"
    }
    
    override func didTapPushMaps(sender: Any) {
        if let aedAnnotations = aedAnnotations, !aedAnnotations.isEmpty {
            presentAlertControllerForTask()
        } else {
            super.didTapPushMaps(sender: self)
        }
        
    }
    
    func didTapToAED(sender: Any){
        self.dismissAlertController()
        
        if let aedAnnotations = aedAnnotations, !aedAnnotations.isEmpty {
            MKMapView.pushAppleMaps(coordinate: self.aedAnnotations!.first!.coordinate, name: String.DEFIBRILLATOR)
        }
        
    }
    
    func didTapToEmergency(sender: Any){
        self.dismissAlertController()
        
        if let emergencyState = emergencyState, let coordinate = emergencyState.emergencyRelation.locationPoint?.coordinate {
            MKMapView.pushAppleMaps(coordinate: coordinate, name: String.EMERGENCY)
        }
    }
    
    private func presentAlertControllerForTask() {
        alertController = ERAlertV2ViewController()
        
        alertController?.alertLabel.text = String.TASK_ALERT_INFO
        alertController?.alertLabel.textColor = UIColor.white
        
        let btn1 = UIButton.button()
        btn1.backgroundColor = UIColor.clear
        btn1.layer.cornerRadius = 5
        btn1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn1.setTitle(String.DEFIBRILLATOR, for: .normal)
        btn1.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn1.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn1.layer.borderColor = UIColor.white.cgColor
        btn1.layer.borderWidth = 2
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(didTapToAED(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn1)
        
        let btn2 = UIButton.button()
        btn2.layer.cornerRadius = 5
        btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn2.setTitle(String.EMERGENCY, for: .normal)
        btn2.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn2.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn2.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderWidth = 2
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.addTarget(self, action: #selector(didTapToEmergency(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn2)
        
        let btn3 = UIButton.button()
        btn3.layer.cornerRadius = 5
        btn3.setTitle(String.BACK, for: .normal)
        btn3.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn3.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn3.layer.borderColor = UIColor.white.cgColor
        btn3.layer.borderWidth = 2
        btn3.addTarget(self, action: #selector(didTapBack(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn3)
        
        alertController!.providesPresentationContextTransitionStyle = true
        alertController!.definesPresentationContext = true
        alertController!.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        alertController!.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(alertController!, animated: true, completion: nil)
        
        alertController?.alertView.backgroundColor = UIColor.colorPrimaryBlue
    }
    

}
