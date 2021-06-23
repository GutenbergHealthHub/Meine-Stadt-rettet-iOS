//
//  ERPersonalSecondViewController.swift
//  EcoRescue
//
//  Created by Birtan on 29.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import MapKit

class ERPersonalSecondViewController: StepsViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    
    private let containerView = UIView.view()
    
    private let streetLabel   = UILabel.type2SemiBoldLabel()
    private let numberLabel   = UILabel.type2SemiBoldLabel()
    private let postcodeLabel = UILabel.type2SemiBoldLabel()
    private let cityLabel     = UILabel.type2SemiBoldLabel()
    private let countryLabel  = UILabel.type2SemiBoldLabel()
    
    private let streetTextfield   = ERRectangleTextField()
    private let numberTextfield   = ERRectangleTextField()
    private let postcodeTextfield = ERRectangleTextField()
    private let cityTextfield     = ERRectangleTextField()
    private let countryTextfield  = ERRectangleTextField()
    
    private var activeTextfield = UITextField()
    
    private var locationManager: CLLocationManager!
    
    private var addLocationProgressController: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Manager
        locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.delegate = self
        
        headerTitleLabel.text    = String.ADDRESS
        headerSubtitleLabel.text = String.PROFILE_INFO_SECOND_PAGE
        
        // Container View
        view.addSubview(containerView)
        containerView.bottom(of: progressView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).top(of: progressView2, constant: UIViewPadding.big).apply()
        
        // Container View - streetLabel
        containerView.addSubview(streetLabel)
        streetLabel.top().left().apply()
        streetLabel.text = String.STREET
        
        // Container View - streetTextfield
        containerView.addSubview(streetTextfield)
        streetTextfield.bottom(of: streetLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        streetTextfield.placeholder = String.EXAMPLE_STREET
        streetTextfield.delegate    = self
        
        // Container View - numberLabel
        containerView.addSubview(numberLabel)
        numberLabel.bottom(of: streetTextfield, constant: UIViewPadding.big).left().apply()
        numberLabel.text = String.NUMBER
        
        // Container View - numberTextfield
        containerView.addSubview(numberTextfield)
        numberTextfield.bottom(of: numberLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.small).width(constant: view.frame.midX - UIViewPadding.small - 2 * UIViewPadding.big).apply()
        numberTextfield.placeholder = String.EXAMPLE_NUMBER
        numberTextfield.delegate    = self
        
        // Container View - postcodeTextfield
        containerView.addSubview(postcodeTextfield)
        postcodeTextfield.top(to: numberTextfield, constant: 0).right(constant: UIViewPadding.small).width(constant: view.frame.midX - UIViewPadding.small - 2 * UIViewPadding.big).apply()
        postcodeTextfield.placeholder  = String.EXAMPLE_POSTAL_CODE
        postcodeTextfield.delegate     = self
        postcodeTextfield.keyboardType = .numberPad
        postcodeTextfield.addDoneToolbar()
        
        // Container View - postcodeLabel
        containerView.addSubview(postcodeLabel)
        postcodeLabel.top(to: numberLabel, constant: 0).top(of: postcodeTextfield, constant: UIViewPadding.small).left(to: postcodeTextfield, constant: -UIViewPadding.small).apply()
        postcodeLabel.text = String.POSTAL_CODE
        
        // Container View - cityLabel
        containerView.addSubview(cityLabel)
        cityLabel.bottom(of: numberTextfield, constant: UIViewPadding.big).left().apply()
        cityLabel.text = "\(String.CITY):"
        
        // Container View - surnameTextfield
        containerView.addSubview(cityTextfield)
        cityTextfield.bottom(of: cityLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        cityTextfield.placeholder = String.EXAMPLE_CITY
        cityTextfield.delegate    = self
        
        // Container View - countryLabel
        containerView.addSubview(countryLabel)
        countryLabel.bottom(of: cityTextfield, constant: UIViewPadding.big).left().apply()
        countryLabel.text = String.COUNTRY
        
        // Container View - countryTextfield
        containerView.addSubview(countryTextfield)
        countryTextfield.bottom(of: countryLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        countryTextfield.placeholder = String.EXAMPLE_COUNTRY
        countryTextfield.delegate    = self
        
        // Container view - addLocationButton
        let addLocationButton = UIButton.button()
        containerView.addSubview(addLocationButton)
        addLocationButton.bottom(of: countryTextfield, constant: 0).leftright(constant: UIViewPadding.small).apply()
        addLocationButton.addTarget(self, action: #selector(didTapAddLocation(sender:)), for: .touchDown)
        //addLocationButton.titleLabel?.numberOfLines = 0
        addLocationButton.titleLabel?.textAlignment = .left
        addLocationButton.titleLabel?.adjustsFontSizeToFitWidth = true
        addLocationButton.titleLabel?.minimumScaleFactor = 0.8
        
        let attributedTitle = NSMutableAttributedString(string: String.TO_ADD_LOCATION_AUTOMATICALLY, attributes: [NSFontAttributeName: UIFont.openSansLight(textStyle: .callout), NSForegroundColorAttributeName: UIColor.black])
        attributedTitle.append(NSAttributedString(string: String.PRESS_HERE, attributes: [NSFontAttributeName: UIFont.openSansLight(textStyle: .callout), NSForegroundColorAttributeName: UIColor.colorPrimaryRedV2
            ]))
        addLocationButton.setAttributedTitle(attributedTitle, for: .normal)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Keyboard Observes
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Keyboard Observer
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Keyboard
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let yIndex = containerView.frame.minY + activeTextfield.frame.maxY + navigationBarHeight + self.view.frame.origin.y
            if yIndex > keyboardSize.minY {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y -= yIndex - keyboardSize.minY + self.activeTextfield.frame.height
                })
            }
        }
        
    }
    
    func keyboardWillHide(_ notification: Notification) {
        if (((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y != 0 {
                UIView.animate(withDuration: 0.1, animations: { () -> Void in
                    self.view.frame.origin.y += -self.view.frame.origin.y
                })
            }
        }
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextfield = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == postcodeTextfield {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newString.characters.count <= 6
        } else if textField == numberTextfield {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newString.characters.count <= 4
        }
        
        return true
    }
    
    //MARK: Getters
    func getStreet() -> String? {
        return streetTextfield.text
    }
    
    func getNumber() -> String? {
        return numberTextfield.text
    }
    
    func getPostcode() -> String? {
        return postcodeTextfield.text
    }
    
    func getCity() -> String? {
        return cityTextfield.text
    }
    
    func getCountry() -> String? {
        return countryTextfield.text
    }
    
    //MARK: Setters
    func setTextWith(street: String?, number: String?, postcode: String?, city: String?, country: String?) {
        streetTextfield.text   = street
        numberTextfield.text   = number
        postcodeTextfield.text = postcode
        cityTextfield.text     = city
        countryTextfield.text  = country
    }
    
    func didTapAddLocation(sender: Any) {
        self.addLocationProgressController = UIAlertController.createIndicatorAlertController(with: nil)
        self.present(addLocationProgressController, animated: true, completion: nil)
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        if let location = locations.first {
            MKMapView.address(coordinate: location.coordinate, closure: { (address) in
                self.streetTextfield.text = address?.street
                self.numberTextfield.text = address?.number
                self.postcodeTextfield.text = address?.zip
                self.cityTextfield.text = address?.city
                self.countryTextfield.text = address?.country
                self.addLocationProgressController.dismiss(animated: true, completion: nil)
            })
        } else {
            self.addLocationProgressController.dismiss(animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.addLocationProgressController.dismiss(animated: true, completion: nil)
        
        let alertController = UIAlertController(title: String.LOCALIZATION_ERROR, message: nil, preferredStyle: .alert)
        alertController.message = String.LOCATION_ERROR_DETAIL
        alertController.addAction(UIAlertAction(title: String.BACK, style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
}
