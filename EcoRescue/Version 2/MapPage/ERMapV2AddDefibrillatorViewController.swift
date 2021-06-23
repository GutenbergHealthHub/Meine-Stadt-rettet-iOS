//
//  ERMapV2AddDefibrillatorViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 22.10.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit
import UCKit
import MapKit
import Parse

class ERMapV2AddDefibrillatorViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverPresentationControllerDelegate, ERPopOverTableViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, DefibrillatorImagesViewDelegate, UCViewImageViewControllerDelegate, ERMapV2EditAddressViewControllerDelegate {
    
    private let mapView = MKMapView()
    
    private let mapInfoLabel = UILabel.type2LightLabel(.footnote)
    
    private let seperatorView2 = UIView.seperatorView()
    
    private let scrollView = UIScrollView.scrollView()
    
    private let containerView = UIView.view()
    
    private let bottomView = UIView.view()
    
    private let objectTitleLabel = UILabel.type2SemiBoldLabel()
    
    private let objectTitleTextField = ERRectangleTextField()
    
    private let addressTitleTextField = ERAddDefibrillatorAddressView()
    
    private let aedManufacturerTitleTextField = ERRectangleView()
    
    private let aedModelTitleTextField = ERRectangleTextField()
    
    private let aedTypeTitleTextField = ERRectangleTextField()
    
    private let commentsTextField = UITextView.textView()
    
    private let defibrillatorCollectionView = DefibrillatorImagesView()
    
    private let saveButton = ERButton()
    
    private let activityBarButtonItem = UIBarButtonItem(customView: UIActivityIndicatorView(activityIndicatorStyle: .gray))
    
    private var locationManager: CLLocationManager!
    
    private var annotation: MKPointAnnotation = MKPointAnnotation()
    
    private var coordinate: CLLocationCoordinate2D? { didSet { setCoordinate(oldValue: oldValue) } }
    
    private var isRequestingLocation: Bool = false { didSet { setRequestingLocation(oldValue: oldValue) } }
    
    private var address: UCAddress? { didSet { setAddress(oldValue: oldValue) } }
    
    var defibrillator: ERDefibrillator!
    
    // Properties
    private var information:    String?
    //private var address:        UCAddress?
    //private var coordinate:     CLLocationCoordinate2D?
    private var model:          String?
    private var type:           String?
    private var producer:       (Int, String)?
    
    private var isUpdate = false
    private var allowUpdate = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.white
        self.navigationItem.rightBarButtonItem = activityBarButtonItem
        
        // Manager
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        
        // mapView
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.top().leftright().height(multiplier: 0.3).apply()
        mapView.delegate = self
        
        // mapInfoLabel
        self.view.addSubview(mapInfoLabel)
        mapInfoLabel.bottom(of: mapView, constant: UIViewPadding.tiny).leftright(constant: UIViewPadding.big).apply()
        mapInfoLabel.text = String.LONG_PRESS_MAP_INFO
        mapInfoLabel.textAlignment = .right
        
        // seperatorView2
        self.view.addSubview(seperatorView2)
        seperatorView2.leftright().bottom(of: mapInfoLabel, constant: UIViewPadding.tiny).height(constant: 1).apply()
        seperatorView2.backgroundColor = UIColor.background
        
        // scrollView
        self.view.addSubview(scrollView)
        
        // scrollView - containerView
        scrollView.addSubview(containerView)
        containerView.width(constant: view.frame.width).match().apply()
        
        // scrollView - objectTitleLabel
        containerView.addSubview(objectTitleLabel)
        objectTitleLabel.top(constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        objectTitleLabel.text = String.OBJECT_TITLE
        
        // scrollView - objectTitleTextField
        containerView.addSubview(objectTitleTextField)
        objectTitleTextField.bottom(of: objectTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        objectTitleTextField.delegate = self
        objectTitleTextField.placeholder = String.OBJECT_TITLE_EXAMPLE
        
        // scrollView - addressTitleLabel
        let addressTitleLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(addressTitleLabel)
        addressTitleLabel.bottom(of: objectTitleTextField, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        addressTitleLabel.text = "\(String.ADDRESS):"
        
        // scrollView - addressTitleTextField
        containerView.addSubview(addressTitleTextField)
        addressTitleTextField.bottom(of: addressTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        addressTitleTextField.label.numberOfLines = 0
        addressTitleTextField.addTarget(target: self, action: #selector(editAddress(_:)))
        
        // scrollView - aedManufacturerTitleLabel
        let aedManufacturerTitleLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(aedManufacturerTitleLabel)
        aedManufacturerTitleLabel.bottom(of: addressTitleTextField, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        aedManufacturerTitleLabel.text = String.AED_MANUFACTURER
        
        // scrollView - aedManufacturerTitleTextField
        containerView.addSubview(aedManufacturerTitleTextField)
        aedManufacturerTitleTextField.bottom(of: aedManufacturerTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).height(constant: 40).apply()
        aedManufacturerTitleTextField.addTarget(target: self, action: #selector(aedManufacturerTapHandler(_:)))

        
        // scrollView - aedModelTitleLabel
        let aedModelTitleLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(aedModelTitleLabel)
        aedModelTitleLabel.bottom(of: aedManufacturerTitleTextField, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        aedModelTitleLabel.text = "\(String.AED_MODEL):"
        
        // scrollView - aedModelTitleTextField
        containerView.addSubview(aedModelTitleTextField)
        aedModelTitleTextField.bottom(of: aedModelTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).apply()
        aedModelTitleTextField.delegate    = self
        aedModelTitleTextField.placeholder = String.AED_MODEL_EXAMPLE
        
        // scrollView - aedTypeTitleLabel
        let aedTypeTitleLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(aedTypeTitleLabel)
        aedTypeTitleLabel.bottom(of: aedModelTitleTextField, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        aedTypeTitleLabel.text = "\(String.AED_TYPE):"
        
        // scrollView - aedTypeTitleTextField
        containerView.addSubview(aedTypeTitleTextField)
        aedTypeTitleTextField.bottom(of: aedTypeTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).height(constant: 40).apply()
        aedTypeTitleTextField.delegate    = self
        aedTypeTitleTextField.placeholder = String.AED_TYPE_EXAMPLE
        
        // scrollView - commentsTitleLabel
        let commentsTitleLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(commentsTitleLabel)
        commentsTitleLabel.bottom(of: aedTypeTitleTextField, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        commentsTitleLabel.text = String.COMMENTS
        
        // scrollView - commentsTextField
        containerView.addSubview(commentsTextField)
        commentsTextField.bottom(of: commentsTitleLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).height(constant: 100).apply()
        commentsTextField.font = UIFont.openSansRegular(textStyle: .body)
        commentsTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        commentsTextField.layer.borderWidth = 1
        commentsTextField.layer.cornerRadius = 2
        commentsTextField.delegate = self
        //commentsTextField.placeholder = "Max. 100 words"
        
        // scrollView - defibrillatorImagesLabel
        let defibrillatorImagesLabel = UILabel.type2SemiBoldLabel()
        containerView.addSubview(defibrillatorImagesLabel)
        defibrillatorImagesLabel.bottom(of: commentsTextField, constant: UIViewPadding.big).left(constant: UIViewPadding.big).apply()
        defibrillatorImagesLabel.text = String.IMAGES
        
        // scrollView - defibrillatorCollectionView
        containerView.addSubview(defibrillatorCollectionView)
        defibrillatorCollectionView.bottom(of: defibrillatorImagesLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.big).height(constant: 160).apply()
        defibrillatorCollectionView.delegate = self
        
        // Long Press Gesture for Adding Pin
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didTapLong(sender:)))
         gestureRecognizer.minimumPressDuration = 1.0
         mapView.addGestureRecognizer(gestureRecognizer)
        
        (activityBarButtonItem.customView as! UIActivityIndicatorView).hidesWhenStopped = true
        
        setViews()
        
        setDefibrillator()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.height(constant: 4 * objectTitleTextField.frame.height + 7 * objectTitleLabel.frame.height + addressTitleTextField.frame.height + commentsTextField.frame.height + defibrillatorCollectionView.frame.height + 8 * UIViewPadding.large).apply()

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: private functions
    private func setCoordinate(oldValue: CLLocationCoordinate2D?) {
        if coordinate == oldValue { return }
        
        if let coordinate = coordinate {
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        } else {
            mapView.removeAnnotation(annotation)
        }
    }
    
    private func setRequestingLocation(oldValue: Bool) {
        if oldValue == isRequestingLocation { return }
        
        let activityIndicatorView = activityBarButtonItem.customView as! UIActivityIndicatorView
        
        if isRequestingLocation {
            activityIndicatorView.startAnimating()
            addressTitleTextField.isUserInteractionEnabled = false
            saveButton.isEnabled = false
        } else {
            activityIndicatorView.stopAnimating()
            addressTitleTextField.isUserInteractionEnabled = true
            saveButton.isEnabled = true
        }
    }
    
    private func setAddress(oldValue: UCAddress?) {
        if address == oldValue { return }
        
        self.addressTitleTextField.label.text = address?.addressLinesString
    }
    
    private func setViews() {
        if let defibrillator = self.defibrillator, let state = defibrillator.state, state == 3 || state == 4  {
            scrollView.bottom(of: seperatorView2, constant: UIViewPadding.tiny).leftright().bottom().apply()
        } else {
            // bottomView
            self.view.addSubview(bottomView)
            bottomView.bottom().leftright().height(multiplier: 0.1).apply()
            
            // seperatorView
            let seperatorView = UIView.seperatorView()
            self.bottomView.addSubview(seperatorView)
            seperatorView.leftright().top().height(constant: 1).apply()
            seperatorView.backgroundColor = UIColor.background
            
            // saveButton
            bottomView.addSubview(saveButton)
            saveButton.centerY().leftright(constant: UIViewPadding.big).apply()
            saveButton.text = String.SAVE_DEFIBRILLATOR
            saveButton.setTitle(String.SAVE_DEFIBRILLATOR, for: .normal)
            saveButton.addTarget(self, action: #selector(didTapSave(sender:)), for: .touchDown)
            
            scrollView.bottom(of: seperatorView2, constant: UIViewPadding.tiny).leftright().top(of: bottomView, constant: UIViewPadding.tiny).apply()
        }
    }
    
    private func setDefibrillator() {
        if let defibrillator = self.defibrillator {
            objectTitleTextField.text   = defibrillator.object
            self.address                = defibrillator.address
            aedTypeTitleTextField.text  = defibrillator.type
            aedModelTitleTextField.text = defibrillator.model
            commentsTextField.text      = defibrillator.information
            self.coordinate             = defibrillator.address?.coordinate
            
            if let images = defibrillator.files {
                for image in images {
                    defibrillatorCollectionView.appendFile(file: image)
                }
            }
            
            producer = defibrillator.producerValue
            aedManufacturerTitleTextField.label.text = producer?.1
            saveButton.setTitle(String.UPDATE_DEFIBRILLATOR, for: .normal)
            
            isUpdate = true
            if let state = defibrillator.state, state == 3 || state == 4 {
                allowUpdate = false
                objectTitleTextField.isUserInteractionEnabled = false
                aedManufacturerTitleTextField.isUserInteractionEnabled = false
                aedTypeTitleTextField.isUserInteractionEnabled = false
                aedModelTitleTextField.isUserInteractionEnabled = false
                commentsTextField.isUserInteractionEnabled = false
                defibrillatorCollectionView.allowUpdate = false
                mapView.isUserInteractionEnabled = false
                saveButton.removeFromSuperview()
                bottomView.backgroundColor = UIColor.colorPrimaryBlue
            }
            self.notify(address: address!, coordinate: coordinate!)
        } else {
            didTapLocate(self)
        }
    }
    
    private func updateAuthorizationStatus() {
        let status = CLLocationManager.authorizationStatus()
        activityBarButtonItem.isEnabled = status == .authorizedAlways || status == .authorizedWhenInUse
    }
    
    // MARK: - Private Methods - Notify
    
    private func notify(address: UCAddress, coordinate: CLLocationCoordinate2D) {
        print("Notify Address Change.")
        self.address    = address
        self.coordinate = coordinate
        
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
        let top         = topLayoutGuide.length
        let bottom      = mapView.frame.height
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
        updateAuthorizationStatus()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        if let location = locations.first, isRequestingLocation {
            notify(coordinate: location.coordinate, completion: {
                self.isRequestingLocation = false
            })
        } else {
            isRequestingLocation = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        isRequestingLocation = false
        
        let alertController = UIAlertController(title: String.LOCALIZATION_ERROR, message: nil, preferredStyle: .alert)
        alertController.message = String.LOCATION_ERROR_DETAIL
        alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 200
    }
    
    //MARK: ERPopOverTableViewControllerDelegate
    func selectedText(text: String, index: Int) {
        aedManufacturerTitleTextField.label.text = text
        producer = ERDefibrillator.producerTuple[index]
    }
    
    //MARK: UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    //MARK: ERMapV2EditAddressViewControllerDelegate
    func addressTableViewDidChangeAddress(address: UCAddress) {
        MKMapView.placemark(address: address.addressLineString) { (placemark) in
            if let clregion = placemark?.region as? CLCircularRegion  {
                self.notify(address: address, coordinate: clregion.center)
            }
        }
    }
    
    
    // MARK: - Actions
    func didTapLocate(_ sender: AnyObject) {
        isRequestingLocation = true
        locationManager.startUpdatingLocation()
    }
    
    func didTapLong(sender: UILongPressGestureRecognizer) {
        
        // Get Coordinate
        let point   = sender.location(in: mapView)
        coordinate  = mapView.convert(point, toCoordinateFrom: mapView)
        
        // Notify
        notify(coordinate: coordinate!)
    }
    
    func didTapSave(sender: Any) {
        if let address = address, let coordinate = coordinate, let object = objectTitleTextField.text {
            address.object = object
            if address.zip != nil && !address.zip!.isEmpty
                && address.city != nil && !address.city!.isEmpty
                && address.object != nil && !address.object!.isEmpty {
                
               if !isUpdate {
                    defibrillator = ERDefibrillator()
                }

                defibrillator.address       = address
                defibrillator.location      = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
                defibrillator.information   = commentsTextField.text
                defibrillator.files         = defibrillatorCollectionView.files
                defibrillator.creator       = ERUser.current()
                defibrillator.producerDefiValue = producer?.0 as NSNumber?
                defibrillator.type          = aedTypeTitleTextField.text
                defibrillator.model         = aedModelTitleTextField.text
                
                ResponderStateManager.shared.getState(completion: { (state) in
                    if state == .active{
                        self.defibrillator.state = 3
                        self.defibrillator.activated = true
                    }
                    else {
                        self.defibrillator.state = 1
                        self.defibrillator.activated = false
                    }
                    self.saveDefibrillator()
                })
                
                
            } else {
                let alertController = UIAlertController(title: String.ADDRESS_IS_MISSING, message: nil, preferredStyle: .alert)
                alertController.message = String.OBJECT_CITY_POSTAL_CODE_MUST_BE_SPECIFIED
                alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            
        } else {
            let alertController = UIAlertController(title: String.ADDRESS_IS_MISSING, message: nil, preferredStyle: .alert)
            alertController.message = String.ADDRESS_OF_THE_DEFIBRILLATOR_DESCRIPTION_AED_MANUFACTURER_MUST_BE_SPECIFIED
            alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    private func saveDefibrillator() {
        print(defibrillator)
        
        let alertController = UIAlertController(title: String.PLEASE_WAIT, message: nil, preferredStyle: .alert)
        alertController.message = String.DEFIBRILLATOR_IS_SAVED
        present(alertController, animated: true, completion: nil)
        
        ERCommunicationManager.sharedManager.save(defibrillator: defibrillator, completion: { (success, error) in
            
            alertController.dismiss(animated: true, completion: {
                
                if let _ = error {
                    let alertController = UIAlertController(title: String.ERROR, message: nil, preferredStyle: .alert)
                    alertController.message = String.DEFIBRILLATOR_COULD_NOT_BE_SAVED
                    alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    
                } else {
                    
                    let alertController = UIAlertController(title: String.DEFIBRILLATOR_IS_SAVED, message: nil, preferredStyle: .alert)
                    alertController.message = String.THANKS_FOR_YOUR_HELP
                    alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                        self.navigationController?.pop(animated: true)
                    }))
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
        }, progressBlock: { (file, progress) in
            
        })
    }
    
    func aedManufacturerTapHandler(_ sender: Any) {
        let vc = ERPopOverTableViewController()
        vc.delegate = self
        vc.popOverData = ERDefibrillator.producerTuple.map( { $1 } )
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize   = CGSize(width: (aedManufacturerTitleTextField).frame.width, height: 300)
        
        if let pres = vc.presentationController {
            pres.delegate = self
        }
        
        self.present(vc, animated: true)
        if let ppc = vc.popoverPresentationController {
            ppc.sourceView = (aedManufacturerTitleTextField)
            ppc.sourceRect = (aedManufacturerTitleTextField).bounds
            ppc.permittedArrowDirections = .up
        }
        
    }
    
    func editAddress(_ sender: Any) {
        let vc = ERMapV2EditAddressViewController()
        vc.delegate = self
        if let address = self.address {
            vc.address = address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let i = info[UIImagePickerControllerOriginalImage] as? UIImage,
            let d = UIImageJPEGRepresentation(i, 0.5),
            let f = PFFileObject(name: "image.jpg", data: d) {
            
            defibrillatorCollectionView.appendFile(file: f)
            //tableView.reloadData()
            
        } else {
            print("ERROR")
        }
    }
    
    // MARK: DefibrillatorImagesViewDelegate
    
    fileprivate func presentEditProfilePictureAlertController() {
        
        let cancelAction = UIAlertAction(title: String.CANCEL, style: .cancel, handler: nil)
        let cameraAction = UIAlertAction(title: String.TAKE_A_PHOTO, style: .default) { (action) in
            self.openPhotoSource(type: .camera)
        }
        let libraryAction = UIAlertAction(title: String.OPEN_MEDIA_CENTER, style: .default) { (action) in
            self.openPhotoSource(type: .photoLibrary)
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(libraryAction)
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func didSelectFile(file: PFFileObject, image: UIImage) {
        let viewImageViewController = UCViewImageViewController()
        viewImageViewController.canDelete = allowUpdate
        viewImageViewController.image = image
        viewImageViewController.delegate = self
        
        navigationController?.pushViewController(viewImageViewController, animated: true)
    }
    
    // MARK: - UCViewImageViewControllerDelegate
    
    func viewImageViewController(viewImageViewController: UCViewImageViewController, shouldDeleteImage image: UIImage?) {
        if let image = image, let file = defibrillatorCollectionView.fileFor(image: image) {
            defibrillatorCollectionView.removeFile(file: file)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func openPhotoSource(type: UIImagePickerControllerSourceType) {
        let imagePicker             = UIImagePickerController()
        imagePicker.delegate        = self
        imagePicker.sourceType      = type
        imagePicker.allowsEditing   = true
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            present(imagePicker, animated: true, completion: nil)
        } else {
            // Error
        }
    }


}

fileprivate protocol DefibrillatorImagesViewDelegate {
    func didSelectFile(file: PFFileObject, image: UIImage)
    func presentEditProfilePictureAlertController()
}

fileprivate class DefibrillatorImagesView: UIView, UCCollectionViewDataSource, UCCollectionViewDelegate, UICollectionViewDelegateFlowLayout, EmptyCollectionViewCellDelegate {
    
    var delegate: DefibrillatorImagesViewDelegate?
    
    private(set) var files  = [PFFileObject]()
    private var imagesMap   = [PFFileObject: UIImage]()
    private var filesMap    = [UIImage: PFFileObject]()
    
    // Views
    private let collectionView  = UCCollectionView()
    private let flowLayout      = UICollectionViewFlowLayout()
    
    var allowUpdate: Bool = true
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        /*layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 2*/
        
        // Layout
        flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 2 * UIViewPadding.big) * 0.3, height: 150)
        flowLayout.minimumInteritemSpacing = UIViewPadding.medium
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: UIViewPadding.small, left: UIViewPadding.small, bottom: UIViewPadding.small, right: UIViewPadding.small)
        
        // Collection View
        collectionView.register(cellClass: ImageCollectionViewCell.self, forCellReuseIdentifier: ImageCollectionViewCell.id)
        collectionView.register(cellClass: EmptyCollectionViewCell.self, forCellReuseIdentifier: EmptyCollectionViewCell.id)
        
        collectionView.layout = flowLayout
        
        collectionView.dataSource   = self
        collectionView.delegate     = self
        
        collectionView.alwaysBounceVertical = false
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.match().apply()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imageFor(file: PFFileObject) -> UIImage? {
        return imagesMap[file]
    }
    
    func fileFor(image: UIImage) -> PFFileObject? {
        return filesMap[image]
    }
    
    func appendFile(file: PFFileObject) {
        files.append(file)
        
        ERImageManager.image(from: file, completion: { (image, error) in
            
            // Update Maps
            self.imagesMap[file] = image
            if let image = image { self.filesMap[image] = file }
            
            // Reload Collection View
            self.collectionView.reloadData()
        })
    }
    
    func removeFile(file: PFFileObject) {
        if let index = files.index(of: file) {
            files.remove(at: index)
            
            // Update Maps
            if let image = imagesMap[file] { filesMap[image] = nil }
            imagesMap[file] = nil
            
            // Reload Collection View
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UCCollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UCCollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item + 1 > files.count {
            let cell = collectionView.dequeueReusableCell(identifier: EmptyCollectionViewCell.id, indexPath: indexPath) as! EmptyCollectionViewCell
            cell.delegate = self
            cell.button.isEnabled = allowUpdate
            return cell
        } else {
            let file = files[indexPath.item]
            let cell = collectionView.dequeueReusableCell(identifier: ImageCollectionViewCell.id, indexPath: indexPath) as! ImageCollectionViewCell
            cell.image = imagesMap[file]
            return cell
        }
    }
    
    func collectionView(collectionView: UCCollectionView, didSelectItemAtIndexPath indexPath: IndexPath) {
        if collectionView.cellForItemAt(indexPath: indexPath) is ImageCollectionViewCell {
            let file = files[indexPath.item]
            delegate?.didSelectFile(file: file, image: imagesMap[file]!)
        }
    }
    
    // MARK: EmptyCollectionViewCellDelegate
    
    func didTapAdd() {
        delegate?.presentEditProfilePictureAlertController()
    }
    
}

fileprivate protocol EmptyCollectionViewCellDelegate {
    func didTapAdd()
}

private class EmptyCollectionViewCell: UICollectionViewCell {
    
    static let id = "EmptyCollectionViewCell"
    
    let button = UIButton(type: .system)
    
    var delegate: EmptyCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        button.frame = CGRect(x: bounds.midX - 25, y: bounds.midY - 25, width: 50, height: 50)
        button.backgroundColor = UIColor.colorPrimaryBlue
        button.tintColor = UIColor.white
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        //button.layer.borderColor = UIColor.white.cgColor
        //button.layer.borderWidth = 4
        button.clipsToBounds = true
        button.setImage(UIImage.iconAddV2(), for: .normal)
        button.addTarget(self, action: #selector(didTapAdd(sender:)), for: .touchUpInside)
        contentView.addSubview(button)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        context!.setLineWidth(4);
        context!.setStrokeColor(UIColor.gray.cgColor);
        context!.setLineDash(phase: 3, lengths: [5, 7])
        context!.addRect(rect);
        context!.strokePath();
    }
    
    func didTapAdd(sender: Any) {
        delegate?.didTapAdd()
    }
    
}

private class ImageCollectionViewCell: UICollectionViewCell {
    
    static let id = "ImageCollectionViewCell"
    
    var image:  UIImage?    { didSet { p_setImage(oldValue: oldValue) } }
    
    // Views
    private let imageView = UIImageView.imageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.match().apply()
        imageView.contentMode = .scaleAspectFit
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    
    private func p_setImage(oldValue: UIImage?) {
        if image == oldValue { return }
        
        if let image = image {
            imageView.image = image
        } else {
            imageView.image = nil
        }
    }
    
}

