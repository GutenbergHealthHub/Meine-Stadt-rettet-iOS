//
//  EREmergencyCallMapV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 02.10.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import MapKit

class EREmergencyCallMapV2ViewController: EREmergencyCallStepViewController, MKMapViewDelegate {
    
    private let scrollView = UIScrollView.scrollView()
    
    private let annotationsRequest = AnnotationsRequest()
    
    private var firstTime = true
    
    internal let mapView = ERMapView2()
    
    internal let containerView = EREmergencyMapV2InfoView()
    
    internal var alertController: ERAlertV2ViewController?
    
    var annotation: Annotation? { didSet { setAnnotation(oldValue: oldValue) } }
    
    var aedAnnotations: [Annotation]? { didSet { setAEDAnnotations() } }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        // topView
        let topView = UIView.view()
        view.addSubview(topView)
        topView.top().leftright().height(multiplier: 0.1).apply()
        topView.backgroundColor = UIColor.colorPrimaryBlue
        
        // topView - emergencyLabel
        let emergencyLabel = UILabel.type1BoldLabel(.headline)
        topView.addSubview(emergencyLabel)
        emergencyLabel.bottom(constant: UIViewPadding.medium).left(constant: UIViewPadding.medium).apply()
        emergencyLabel.text = String.EMERGENCY_CALL.uppercased()
        emergencyLabel.textColor = UIColor.white
        
        // topView - callButton
        let callButton = UIButton.button()
        topView.addSubview(callButton)
        callButton.bottom(constant: UIViewPadding.medium).right(constant: UIViewPadding.medium).widthEqualsHeight().width(constant: 25).apply()
        callButton.setImage(UIImage.iconTelephoneV2(), for: .normal)
        callButton.tintColor = UIColor.white
        callButton.addTarget(self, action: #selector(didTapCall(sender:)), for: .touchDown)
        
        // finishButton
        let finishButton = ERButton()
        view.addSubview(finishButton)
        finishButton.bottom(constant: UIViewPadding.large).left(constant: UIViewPadding.big).width(multiplier: 0.8).apply()
        finishButton.text = String.FINISH_EMERGENCY
        finishButton.backgroundColor = UIColor.colorPrimaryRedV2
        finishButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        finishButton.addTarget(self, action: #selector(didTapFinish(sender:)), for: .touchDown)
        
        /*// metronomeButton
         let metronomeButton = UIButton.button()
         view.addSubview(metronomeButton)
         metronomeButton.bottom(constant: UIViewPadding.large).right(of: finishButton, constant: UIViewPadding.small).height(constant: UIButtonHeight.forScreenSize).width(multiplier: 0.2).apply()
         metronomeButton.setImage(UIImage.iconTempoV2(), for: .normal)
         metronomeButton.backgroundColor = UIColor.gray
         metronomeButton.layer.cornerRadius = 5
         metronomeButton.tintColor = UIColor.white
         metronomeButton.addTarget(self, action: #selector(didTapMetronome(sender:)), for: .touchDown)*/
        
        // infoButton
        let infoButton = UIButton.button()
        view.addSubview(infoButton)
        infoButton.bottom(constant: UIViewPadding.large).right(of: finishButton, constant: UIViewPadding.small).height(constant: UIButtonHeight.forScreenSize).right(constant: UIViewPadding.big).apply()
        infoButton.setImage(UIImage.iconDocInfoV2(), for: .normal)
        infoButton.backgroundColor = UIColor.gray
        infoButton.layer.cornerRadius = 5
        infoButton.tintColor = UIColor.white
        infoButton.addTarget(self, action: #selector(didTapInfo(sender:)), for: .touchDown)
        
        // seperatorView2
        let separatorView2 = UIView.view()
        view.addSubview(separatorView2)
        separatorView2.top(of: finishButton, constant: UIViewPadding.big).leftright().height(constant: 0.8).apply()
        separatorView2.backgroundColor = UIColor.black
        
        // scrollView
        view.addSubview(scrollView)
        scrollView.height(constant: 225).leftright().top(of: separatorView2, constant: 0).apply()
        
        // scrollView - containerView
        scrollView.addSubview(containerView)
        containerView.match().width(constant: view.frame.width).apply()
        
        // seperatorView1
        let separatorView1 = UIView.view()
        view.addSubview(separatorView1)
        separatorView1.top(of: scrollView, constant: 0).leftright().height(constant: 0.8).apply()
        separatorView1.backgroundColor = UIColor.black
        
        // mapView
        view.addSubview(mapView)
        mapView.leftright().bottom(of: topView, constant: 0).top(of: separatorView1, constant: 0).apply()
        mapView.delegate = self
        annotation = Annotation.Emergency(emergency: emergencyState!.emergencyRelation)
        
        // mapView - buttonPushMaps
        mapView.addSubview(buttonPushMaps)
        buttonPushMaps.right(constant: UIViewPadding.big).bottom(constant: UIViewPadding.large).width(constant: 50).widthEqualsHeight().apply()
        
        // mapView - buttonTarget
        mapView.addSubview(buttonTarget)
        buttonTarget.right(constant: UIViewPadding.big).top(of: buttonPushMaps, constant: UIViewPadding.medium).width(constant: 50).widthEqualsHeight().apply()

        setContainerViewElements()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //mapInfoBar.alpha = selectedAnnotation != nil ? 1 : 0
        mapView.showsUserLocation = true
        if !firstTime {
            zoom(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.invalidateIntrinsicContentSize()
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.showsUserLocation = false
    }
    
    private func setAnnotation(oldValue: Annotation?) {
        if oldValue == annotation { return }
        
        mapView.addAnnotation(annotation!)
        //selectedAnnotation = annotation
    }
    
    private func setAEDAnnotations() {
        if let aedAnnotations = aedAnnotations {
            self.mapView.addAnnotations(aedAnnotations)
        }
    }

    // MARK: private functions
    private func setContainerViewElements() {
        
        containerView.taskValLabel.text = emergencyState?.emergencyTaskDescription
        
        containerView.descriptionValLabel.text = emergencyState?.emergencyRelation.informationString

        containerView.addressValLabel.text = emergencyState?.emergencyRelation.address.addressLineString

        containerView.patientNameValLabel.text = emergencyState?.emergencyRelation.patientName
        
        containerView.emergencyNumberValLabel.text = emergencyState!.emergencyRelation.emergencyNumberDC

        containerView.keywordValLabel.text = emergencyState?.emergencyRelation.keyword

        containerView.indicatorValLabel.text = emergencyState?.emergencyRelation.indicatorName

        containerView.objectValLabel.text = emergencyState?.emergencyRelation.objectName
        
        if let coordinate = emergencyState?.emergencyRelation.locationPoint?.coordinate {
            containerView.geoCoordinationValLabel.text = String(format: "%.05f, %.05f", coordinate.latitude, coordinate.longitude)
        }
        
    }
    
    internal func dismissAlertController() {
        if let vc = alertController {
            vc.dismiss(animated: true, completion: nil)
            alertController = nil
        }
    }
    
    // MARK: - ERDataManagerDelegate
    override func dataManagerDidCancelEmergencyState(dataManager: ERDataManager, emergencyState: EREmergencyState) {
        super.dataManagerDidCancelEmergencyState(dataManager: dataManager, emergencyState: emergencyState)
        
        self.dataManager.resetEvaluation()
    }
    
    
    // MARK: - MKMapViewDelegate
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.colorPrimaryRedV2
        renderer.lineWidth = 3
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return mapView.annotationViewFor(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if firstTime {
            firstTime = false
            reloadDefibrillators()
        }
    }
    
    private func zoom(animated: Bool) {
        if let annotation = annotation, mapView.userLocation.coordinate != CLLocationCoordinate2D(latitude: 0, longitude: 0) {
            
            // Zoom Annotation
            self.mapView.showAnnotations([annotation], animated: animated)
            
            self.mapView.alpha = 1
            
            // Load Route
            reloadRoute(animated: animated)
        }
    }
    
    private func reloadDefibrillators() {
        annotationsRequest.requestDefibrillatorsForEmergencyView(southWest: mapView.southWest, northEast: mapView.northEast, location: mapView.userLocation.coordinate) { (defibrillators, error) in
            
            if let defibrillators = defibrillators {
                self.aedAnnotations = defibrillators
            }
            self.zoom(animated: false)
        }
    }
    
    
    func reloadRoute(animated: Bool) {
        
        mapView.route(coordinate: annotation!.coordinate, transportType: .walking, completition: { (route, error) in
            self.mapView.removeOverlays(self.mapView.overlays)
            
            // Add Route
            if let route = route {
                
                let number = NSNumber(value: route.expectedTravelTime / 60)
                let numberFormatter = NumberFormatter()
                numberFormatter.maximumFractionDigits = 0
                
                self.containerView.distanceValLabel.text = "\(Int(route.distance)) m"
                self.containerView.timeValLabel.text     = "\(numberFormatter.string(from: number) ?? "") min"
                
                
                if route.distance < EcoRescueConfig.RouteDistanceTreshold {
                    self.mapView.add(route.polyline)
                    self.mapView.zoomRoute(route: route, contentInset: self.mapContentInsets, animated: animated)
                } else {
                    self.mapView.zoomAnnotation(annotation: self.annotation!, contentInset: self.mapContentInsets, animated: animated)
                }
            }
            
        })
    }

    // MARK: - Actions
    func didTapFinish(sender: Any) {
        alertController = ERAlertV2ViewController()

        alertController?.alertLabel.text = String.FINISH_EMERGENCY_REASON
        alertController?.alertLabel.textColor = UIColor.white
        
        let btn1 = UIButton.button()
        btn1.backgroundColor = UIColor.clear
        btn1.layer.cornerRadius = 5
        btn1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn1.setTitle(String.PATIENT_REACHED, for: .normal)
        btn1.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn1.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn1.layer.borderColor = UIColor.white.cgColor
        btn1.layer.borderWidth = 2
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn1.addTarget(self, action: #selector(didTapPatientReached(sender:)), for: .touchDown)
        alertController!.alertButtons.append(btn1)
        
        let btn2 = UIButton.button()
        btn2.layer.cornerRadius = 5
        btn2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        btn2.setTitle(String.CANCEL_EMERGENCY, for: .normal)
        btn2.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn2.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        btn2.layer.borderColor = UIColor.white.cgColor
        btn2.layer.borderWidth = 2
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.addTarget(self, action: #selector(didTapCancel(sender:)), for: .touchDown)
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
    
    func didTapBack(sender: Any) {
        self.dismissAlertController()
    }
    
    func didTapPatientReached(sender: Any) {
        self.dismissAlertController()
        
        self.emergencyState!.stateValue = .finished
        self.emergencyState!.saveInBackground()
        
        self.dataManager.resetEvaluation()
        
        delegate?.finalizeSteps(with: self.emergencyState!, cancel: false, expired: false)
    }
    
    func didTapCancel(sender: Any) {
        self.dismissAlertController()
        
        self.emergencyState!.stateValue = .cancelled
        self.emergencyState!.saveInBackground()
        
        self.dataManager.resetEvaluation()
        
        delegate?.finalizeSteps(with: self.emergencyState!, cancel: false, expired: false)
    }
    
    func didTapMetronome(sender: Any) {
        
    }
    
    func didTapInfo(sender: Any) {
        delegate?.goNextStep()
    }
    
    func didTapTarget(sender: Any) {
        mapView.zoomUserLocation(contentInset: mapContentInsets, animated: true)
    }
    
    func didTapPushMaps(sender: Any) {
        if let emergencyState = emergencyState, let coordinate = emergencyState.emergencyRelation.locationPoint?.coordinate {
            MKMapView.pushAppleMaps(coordinate: coordinate, name: String.EMERGENCY)
        }
    }
    
    func didTapCall(sender: Any) {
        if let phoneNumber = emergencyState?.emergencyRelation.controlCenterRelation?.phoneNumber {
            UCUtil.call(number: phoneNumber)
        }
    }
    
    // MARK: private variables
    private var mapContentInsets: UIEdgeInsets {
        let padding = UIViewPadding.large
        return UIEdgeInsets(top: self.view.frame.height * 0.1, left: 0, bottom: 300, right: 0)
    }
    
    private lazy var buttonTarget: UIButton = {
        let button = UIButton.button()
        button.backgroundColor = UIColor.colorPrimaryBlue
        button.tintColor = UIColor.white
        button.setImage(UIImage.iconTargetLocationV2(), for: .normal)
        button.layer.cornerRadius = 0.5 * 50
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapTarget(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonPushMaps: UIButton = {
        let button = UIButton.button()
        button.backgroundColor = UIColor.colorPrimaryBlue
        button.tintColor = UIColor.black
        button.setTitle(String.GO.uppercased(), for: .normal)
        button.setTitleColor(UIColor.white, for: UIControlState.normal)
        button.titleLabel?.font = UIFont.openSansRegular(textStyle: .body)
        button.layer.cornerRadius = 0.5 * 50
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapPushMaps(sender:)), for: .touchUpInside)
        return button
    }()

}
