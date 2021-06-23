//
//  ERMapV2ViewController.swift
//  EcoRescue
//
//  Created by Birtan on 18.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import MapKit
import CoreData

class ERMapV2ViewController: CenterMenuViewController, UISearchBarDelegate, MKMapViewDelegate, AnnotationsRequestDelegate, ERMapInfoBarDelegate, UCSearchPlacemarkViewControllerDelegate, CLLocationManagerDelegate {
    
    private let searchBar    = UISearchBar()
    private let mapInfoBar   = ERMapInfoBar(position: .top)
    //private let mapBar = ERMapBar()
    
    private var mapView: ERMapView2!
    
    fileprivate var firstTime = true
    
    var defaultAnnotation:      MKAnnotation?   { didSet { p_setDefaultAnnotation(oldValue: oldValue)   } }
    var selectedAnnotation:     MKAnnotation?   { didSet { p_setSelectedAnnotation(oldValue: oldValue)  } }
    var route:                  MKRoute?        { didSet { p_setRoute(oldValue: oldValue)               } }
    
    var annotationsHidden       = false         { didSet { p_setAnnotationsHidden(oldValue: oldValue) } }
    
    // Managers
    private let annotationsRequest  = AnnotationsRequest()
    private let locationManager     = CLLocationManager()
    
    // Annotations
    private var p_annotations = [Annotation]()  { didSet { p_setAnnotations(oldValue: oldValue) } }
    
    //Core Data Annotations
    private var annotationPlaceEntity: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.MAP
        
        annotationsRequest.delegate = self
        locationManager.delegate = self
        
        //Map View
        mapView = ERMapView2()
        mapView.delegate = self
        view.addSubview(mapView)
        
        //Info Bar
        mapInfoBar.delegate = self
        mapInfoBar.subtitle = String.NAVIGATE_WITH_APPLE_MAPS
        view.addSubview(mapInfoBar)
        
        //Error location bar
        view.addSubview(errorLocationMapBar)
        
        //Bottom Container View
        let bottomContainerView = UIView.view()
        view.addSubview(bottomContainerView)
        
        // Bottom Container View - Buttons
        bottomContainerView.addSubview(buttonTarget)
        bottomContainerView.addSubview(buttonDefibrillator)
        bottomContainerView.addSubview(buttonRefresh)
        //bottomContainerView.backgroundColor = UIColor.black
        
        //Top Container View
        let topContainerView = UIView.view()
        topContainerView.backgroundColor = UIColor.background
        view.addSubview(topContainerView)
        
        //Container View - Search Bar
        searchBar.frame = CGRect(x: 0, y: 0, width: view.frame.width - navigationBarHeight, height: navigationBarHeight)
        topContainerView.addSubview(searchBar)
        searchBar.delegate          = self
        searchBar.placeholder       = String.SEARCHING_FOR_PLACES
        searchBar.searchBarStyle    = .minimal
        
        //Container View - Filter Button
        let filterButton = UIButton.button()
        filterButton.setImage(UIImage.iconFilterGray(), for: UIControlState.normal)
        filterButton.tintColor = UIColor.gray
        filterButton.addTarget(self, action: #selector(didTapFilter(sender:)), for: UIControlEvents.touchDown)
        topContainerView.addSubview(filterButton)

        //Layout
        mapView.match().apply()
        topContainerView.top().leftright().apply()
        mapInfoBar.bottom(of: topContainerView, constant: 0).height(constant: 44).leftright().apply()
        errorLocationMapBar.bottom().leftright().apply()
        bottomContainerView.top(of: errorLocationMapBar, constant: UIViewPadding.big).centerX().height(constant: 80).apply()
        
        //Top Container View Layout
        searchBar.topbottom().apply()
        filterButton.topbottom().right(of: searchBar, constant: 0).right(constant: UIViewPadding.tiny).apply()
        
        //Bottom Container View Layout
        buttonDefibrillator.centerX().topbottom().apply()
        buttonRefresh.right(of: buttonDefibrillator, constant: UIViewPadding.big).topbottom().apply()
        buttonTarget.left(of: buttonDefibrillator, constant: UIViewPadding.big).topbottom().apply()
        
        p_fetchCoreData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        mapInfoBar.alpha = selectedAnnotation != nil ? 1 : 0
        p_zoom(animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        p_reloadAnnotations()
    }
    
    // MARK: - Private Methods - Getters & Setters
    
    private func p_setDefaultAnnotation(oldValue: MKAnnotation?) {
        if let oldValue = oldValue {
            mapView.removeAnnotation(oldValue)
        }
        
        if let defaultAnnotation = defaultAnnotation {
            mapView.addAnnotation(defaultAnnotation)
        }
        
        selectedAnnotation = defaultAnnotation
    }
    
    private func p_setSelectedAnnotation(oldValue: MKAnnotation?) {
        
        // Old Value
        if let _ = oldValue {
            mapInfoBar.fadeOut()
            route = nil
        }
        
        // New Value
        if let selectedAnnotation = selectedAnnotation as? Annotation {
            mapInfoBar.annotation       = selectedAnnotation
            mapInfoBar.infoButtonHidden = selectedAnnotation is Annotation.Emergency
            mapInfoBar.fadeIn()
            
            // Calculate Route
            p_reloadRoute(animated: true)
        }
    }
    
    fileprivate func p_setRoute(oldValue: MKRoute?) {
        if let oldValue = oldValue {
            mapView.remove(oldValue.polyline)
        }
        
        if let route = route {
            mapView.add(route.polyline)
        }
    }
    
    
    private func p_setAnnotations(oldValue: [Annotation]) {
        if p_annotations == oldValue { return }
        
        // Get All Annoations
        let allAnnoations = mapView.annotations.filter({ (annotation) -> Bool in
            if let annotation = annotation as? Annotation, !(annotation is Annotation.Emergency) {
                if let selectedAnnotation = selectedAnnotation as? Annotation {
                    return annotation != selectedAnnotation
                }
                return true
            }
            return false
        }) as! [Annotation]
        
        let itemsToRemove = allAnnoations.filter { (annotation) -> Bool in
            return !p_annotations.contains(annotation)
        }
        
        let itemsToAdd = p_annotations.filter { (annotation) -> Bool in
            return !allAnnoations.contains(annotation)
        }
        
        mapView.removeAnnotations(itemsToRemove, animated: true)
        mapView.addAnnotations(itemsToAdd)
    }
    
    private func p_setAnnotationsHidden(oldValue: Bool)  {
        if annotationsHidden == oldValue { return }
        p_setAnnotationsHidden()
    }
    
    private func p_setAnnotationsHidden()  {
        //buttonPin.tintColor = annotationsHidden ? UIColor.separator : UIColor.theme
        //p_reloadAnnotations()
    }
    
    private func p_reloadRoute(animated: Bool) {
        mapInfoBar.titleColor = UIColor.separator
        mapInfoBar.title = String.ROUTE_IS_CALCULATED
        
        // Remove Route
        self.route = nil
        
        if let selectedAnnotation = selectedAnnotation {
            mapView.route(coordinate: selectedAnnotation.coordinate, transportType: .walking, completition: { (route, error) in
                
                // Title Color
                self.mapInfoBar.titleColor = UIColor.black
                
                // Add Route
                if let route = route {
                    
                    if route.distance < EcoRescueConfig.RouteDistanceTreshold {
                        self.route = route
                        //self.zoomRoute(route: route, animated: animated)
                    } else {
                        //self.zoomAnnotation(annotation: selectedAnnotation, animated: true)
                    }
                    
                    let numberFormatter = NumberFormatter()
                    numberFormatter.maximumFractionDigits = 0
                    
                    let number = NSNumber(value: route.expectedTravelTime / 60)
                    
                    self.mapInfoBar.title = String(format: String.X_MIN_TO_WALK, numberFormatter.string(from: number) ?? "")
                    
                } else {
                    self.mapInfoBar.title = String.ROUTE_UNKNOWN
                }
            })
        } else {
            self.mapInfoBar.title = String.ROUTE_UNKNOWN
        }
        
    }
    
    private func p_zoom(animated: Bool) {
        if firstTime && mapView.userLocation.coordinate != CLLocationCoordinate2D(latitude: 0, longitude: 0) {

            mapView.showAnnotations([defaultAnnotation ?? mapView.userLocation], animated: animated)
            self.mapView.alpha = 1
            
            // Reload Route
            p_reloadRoute(animated: animated)
        }
    }
    
    private func p_reloadAnnotations() {
        let defibrillator   = ERUserDefaultManager.userDefaultMapShowDefi.boolValue       && !annotationsHidden
        let hospital        = ERUserDefaultManager.userDefaultMapShowHospitals.boolValue  && !annotationsHidden
        let firehouse       = ERUserDefaultManager.userDefaultMapShowFirehouses.boolValue && !annotationsHidden
        let doctor          = ERUserDefaultManager.userDefaultMapShowDoctors.boolValue    && !annotationsHidden
        let dentist         = ERUserDefaultManager.userDefaultMapShowDentists.boolValue   && !annotationsHidden
        let pharmacy        = ERUserDefaultManager.userDefaultMapShowPharmacies.boolValue && !annotationsHidden
        
        if let lat = annotationPlaceEntity.first?.value(forKeyPath: "userLat"), let lon = annotationPlaceEntity.first?.value(forKeyPath: "userLon"), inVicinity(lastLocation: CLLocation(latitude: lat as! CLLocationDegrees, longitude: lon as! CLLocationDegrees)) {
            var annotations = [Annotation]()
            
            for annotationPlaceObj in annotationPlaceEntity {
                
                if annotationPlaceObj.value(forKey: "type") as? String == "hospital" && hospital{
                    annotations.append(Annotation.Hospital(place: Place(dictionary: annotationPlaceObj.toDict(), type: .hospital, latitude: annotationPlaceObj.value(forKey: "lat") as! CLLocationDegrees, longtitude: annotationPlaceObj.value(forKey: "lon") as! CLLocationDegrees)))
                } else if annotationPlaceObj.value(forKey: "type") as? String == "doctor" && doctor{
                    annotations.append(Annotation.Doctor(place: Place(dictionary: annotationPlaceObj.toDict(), type: .doctor, latitude: annotationPlaceObj.value(forKey: "lat") as! CLLocationDegrees, longtitude: annotationPlaceObj.value(forKey: "lon") as! CLLocationDegrees)))
                } else if annotationPlaceObj.value(forKey: "type") as? String == "dentist" && dentist{
                    annotations.append(Annotation.Dentist(place: Place(dictionary: annotationPlaceObj.toDict(), type: .dentist, latitude: annotationPlaceObj.value(forKey: "lat") as! CLLocationDegrees, longtitude: annotationPlaceObj.value(forKey: "lon") as! CLLocationDegrees)))
                } else if annotationPlaceObj.value(forKey: "type") as? String == "pharmacy" && pharmacy{
                    annotations.append(Annotation.Pharmacy(place: Place(dictionary: annotationPlaceObj.toDict(), type: .pharmacy, latitude: annotationPlaceObj.value(forKey: "lat") as! CLLocationDegrees, longtitude: annotationPlaceObj.value(forKey: "lon") as! CLLocationDegrees)))
                } else if annotationPlaceObj.value(forKey: "type") as? String == "fire_station" && firehouse{
                    annotations.append(Annotation.Firehouse(place: Place(dictionary: annotationPlaceObj.toDict(), type: .fireStation, latitude: annotationPlaceObj.value(forKey: "lat") as! CLLocationDegrees, longtitude: annotationPlaceObj.value(forKey: "lon") as! CLLocationDegrees)))
                }
            }
            if defibrillator {
                annotationsRequest.requestDefibrillators(southWest: mapView.southWest, northEast: mapView.northEast) { (defibrillators, error) in
                    
                    if let defibrillators = defibrillators {
                        for defib in defibrillators {
                            annotations.append(defib)
                        }
                    }
                    self.p_annotations = annotations
                }
            } else {
                self.p_annotations = annotations
            }
            
        } else {
            annotationsRequest.requestAnnotations(southWest: mapView.southWest, northEast: mapView.northEast, location: mapView.userLocation.coordinate, defibrillator: defibrillator, hospital: hospital, firehouse: firehouse, doctor: doctor, dentist: dentist, pharmacy: pharmacy)
        }
    }
    
    private func inVicinity(lastLocation: CLLocation) -> Bool {
        let currentLocation = CLLocation(latitude: mapView.userLocation.coordinate.latitude, longitude: mapView.userLocation.coordinate.longitude)
        
        return currentLocation.distance(from: lastLocation) < 2000
    }
    
    // MARK: - Core Data Annotations
    
    private func p_fetchCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AnnotationPlaceEntity")
        
        do {
            annotationPlaceEntity = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    private func p_saveCoreData(place: Place) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "AnnotationPlaceEntity", in: managedContext)!
        
        let annotationPlaceObj = NSManagedObject(entity: entity, insertInto: managedContext)
        
        annotationPlaceObj.setValue(place.name , forKeyPath: "name")
        annotationPlaceObj.setValue(place.id , forKeyPath: "id")
        annotationPlaceObj.setValue(place.formattedAddress , forKeyPath: "formattedAddress")
        annotationPlaceObj.setValue(place.vicinity , forKeyPath: "vicinity")
        annotationPlaceObj.setValue(place.website , forKeyPath: "website")
        annotationPlaceObj.setValue(place.phone , forKeyPath: "phone")
        annotationPlaceObj.setValue(Float((place.location?.latitude)!), forKeyPath: "lat")
        annotationPlaceObj.setValue(Float((place.location?.longitude)!), forKeyPath: "lon")
        annotationPlaceObj.setValue(Float(mapView.userLocation.coordinate.latitude), forKeyPath: "userLat")
        annotationPlaceObj.setValue(Float(mapView.userLocation.coordinate.longitude), forKeyPath: "userLon")
        annotationPlaceObj.setValue(place.type.rawValue, forKeyPath: "type")
        
        
        do {
            try managedContext.save()
            annotationPlaceEntity.append(annotationPlaceObj)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func p_clearEntityCoreData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AnnotationPlaceEntity")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.execute(batchDeleteRequest)
            try managedContext.save()
        } catch {
            print ("There was an error")
        }
        
        annotationPlaceEntity.removeAll()
    }
    
    // MARK: - Public Methods - Center
    
    func centerAnnotation(annotation: MKAnnotation, contentInset: UIEdgeInsets = UIEdgeInsets.zero, animated: Bool = false) {
        mapView.centerAnnotation(annotation: annotation, contentInset: contentInset, animated: animated)
    }
    
    func centerUserLocation(contentInset: UIEdgeInsets = UIEdgeInsets.zero, animated: Bool = false) {
        mapView.centerUserLocation(contentInset: contentInset, animated: animated)
    }
    
    func centerCoordinate(coordinate: CLLocationCoordinate2D, contentInset: UIEdgeInsets = UIEdgeInsets.zero, animated: Bool = false) {
        mapView.centerCoordinate(coordinate: coordinate, contentInset: contentInset, animated: animated)
    }
    
    func centerRegion(region: MKCoordinateRegion, contentInset: UIEdgeInsets = UIEdgeInsets.zero, animated: Bool = false) {
        mapView.centerRegion(region: region, contentInset: contentInset, animated: animated)
    }
    
    // MARK: - Public Methods - Zoom
    
    func zoomRoute(route: MKRoute, animated: Bool) {
        mapView.zoomRoute(route: route, contentInset: contentInsets, animated: animated)
    }
    
    func zoomUserLocation(animated: Bool) {
        mapView.zoomUserLocation(contentInset: contentInsets, animated: animated)
    }
    
    func zoomAnnotation(annotation: MKAnnotation, animated: Bool) {
        mapView.zoomAnnotation(annotation: annotation, contentInset: contentInsets, animated: animated)
    }
    
    func zoomAnnotationStepwise(annotation: MKAnnotation, animated: Bool) {
        mapView.zoomAnnotationStepwise(annotation: annotation, contentInset: contentInsets, animated: animated)
    }
    
    // MARK: - AnnotationsRequestDelegate
    
    func annotationRequestDidBeginLoading(annotationsRequest: AnnotationsRequest) {
        //mapBar.setActivityHidden(hidden: false, forItem: buttonPin)
    }
    
    func annotationRequestDidFinishLoading(annotationsRequest: AnnotationsRequest, annotations: [Annotation]?, error: Error?) {
        if let annotations = annotations {
            if !annotationPlaceEntity.isEmpty {
                p_clearEntityCoreData()
            }
            for annotation in annotations {
                if let a = annotation as? Annotation.PlaceAnnotation {
                    p_saveCoreData(place: a.place)
                }
            }
            p_annotations = annotations
        }
        
        //mapBar.setActivityHidden(hidden: true, forItem: buttonPin)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is Annotation {
            selectedAnnotation = view.annotation
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        selectedAnnotation = defaultAnnotation
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.theme
        renderer.lineWidth = 3
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return mapView.annotationViewFor(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for annotationView in views {
            annotationView.transform = CGAffineTransform(scaleX: 0, y: 0)
            
            UIView.animate(withDuration: 0.3, animations: {
                annotationView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { (success) in
                
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        if firstTime {
            p_zoom(animated: true)
            firstTime = false
            p_reloadAnnotations()
        }
    }
    
    // MARK: - ERMapInfoBarDelegate
    
    func mapInfoBarDidTapInfo(ERMapInfoBar: ERMapInfoBar, annotation: Annotation) {
        let vc = ERMapV2InfoViewController()
        vc.annotation = annotation
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func mapInfoBarDidTapNavigate(ERMapInfoBar: ERMapInfoBar, annotation: Annotation) {
        MKMapView.pushAppleMaps(coordinate: annotation.coordinate, name: annotation.title ?? "")
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let mapSearchViewController = UCSearchPlacemarkViewController()
        mapSearchViewController.delegate = self
        present(mapSearchViewController.pack(), animated: false, completion: nil)
    }
    
    // MARK: - UCSearchPlacemarkViewControllerDelegate
    
    func searchPlacemarkViewController(viewController: UCSearchPlacemarkViewController, didSelectPlacemark placemark: MKPlacemark) {
        if let clregion = placemark.region as? CLCircularRegion  {
            let radius = max(clregion.radius, 1000)
            let region = MKCoordinateRegionMakeWithDistance(clregion.center, radius*2, radius*2)
            centerRegion(region: region)
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        p_didChangeAuthorization()
    }
    
    private func p_didChangeAuthorization() {
        let status = CLLocationManager.authorizationStatus()
        buttonTarget.isEnabled = status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    // MARK: - Targets
    
    func didTapErrorLocation(sender: Any) {
        let viewController = LocationAuthorizationViewController(accessLevel: .guest)
        NotificationTransition.present(from: self, to: viewController.pack())
    }
    
    func didTapRefreshButton(sender: Any) {
        p_reloadAnnotations()
    }
    
    func didTapTargetButton(sender: AnyObject) {
        zoomUserLocation(animated: true)
    }
    
    func didTapDefibrillator(sender: AnyObject) {
        if let _ = ERUser.current() {
            let vc = ERMapV2DefibrillatorsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
            alertController.title   = String.ONLY_FOR_ACTIVE_FIRST_RESPONDERS
            alertController.message = String.PLEASE_LOGIN_IN_ORDER_TO_ADD_DEFIBRILLATORS
            alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Private Variables
    
    private var contentInsets: UIEdgeInsets {
        let top         = topLayoutGuide.length + searchBar.frame.height + (mapInfoBar.alpha == 1 ? 44 : 0)
        let bottom      = bottomLayoutGuide.length + UIViewPadding.medium + 44
        let leftright   = UIViewPadding.large
        return UIEdgeInsets(top: top, left: leftright, bottom: bottom, right: leftright)
    }
    
    private lazy var buttonTarget: UIButton = {
        let button = UIButton(type: .system)
        //button.translatesAutoresizingMaskIntoConstraints = false
        button.frame = CGRect(x: 0, y: 10, width: 50, height: 50)
        button.backgroundColor = UIColor.colorPrimaryBlue
        button.tintColor = UIColor.white
        button.setImage(UIImage.iconTargetLocationV2(), for: .normal)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapTargetButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonDefibrillator: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 60, y: 0, width: 70, height: 70)
        button.backgroundColor = UIColor.colorPrimaryBlue
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.setImage(UIImage.iconDefiAdd(), for: .normal)
        button.addTarget(self, action: #selector(didTapDefibrillator(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonRefresh: UIButton = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 140, y: 10, width: 50, height: 50)
        button.backgroundColor = UIColor.colorPrimaryBlue
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.setImage(UIImage.iconUpdate(), for: .normal)
        button.addTarget(self, action: #selector(didTapRefreshButton(sender:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLocationMapBar: ErrorLocationMapBar = {
        let view = ErrorLocationMapBar()
        view.addTarget(self, action: #selector(didTapErrorLocation(sender:)), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Actions
    
    func didTapFilter(sender: Any) {
        /*
        let vc = ERMapV2FilterViewController()
        vc.delegate = self*/
        let vc = ERMapV2FilterTableViewController()
        navigationController?.pushViewController(vc, animated: true)

    }
}


