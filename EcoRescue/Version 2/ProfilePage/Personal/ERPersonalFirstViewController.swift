//
//  ERPersonalFirstViewController.swift
//  EcoRescue
//
//  Created by Birtan on 29.08.18.
//  Copyright © 2018 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit

class ERPersonalFirstViewController: StepsViewController, UITextFieldDelegate, UCCountryPickerDelegate {
    
    private let countryPicker = UCCountryPicker()
    private let datePicker    = UIDatePicker()
    
    private let containerView = UIView.view()
    
    private let nameLabel     = UILabel.type2SemiBoldLabel()
    private let surnameLabel  = UILabel.type2SemiBoldLabel()
    private let birthdayLabel = UILabel.type2SemiBoldLabel()
    private let phoneLabel    = UILabel.type2SemiBoldLabel()
    
    private let nameTextfield      = ERRectangleTextField()
    private let surnameTextfield   = ERRectangleTextField()
    private let birthdayTextfield  = ERRectangleTextField()
    private let phonecodeTextfield = ERRectangleTextField()
    private let phoneTextfield     = ERRectangleTextField()
    
    private var activeTextfield = UITextField()
    
    private var date: Date? { didSet { setDate(oldValue: oldValue) } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        headerTitleLabel.text    = String.PERSONAL_INFORMATION
        headerSubtitleLabel.text = String.PROFILE_INFO_FIRST_PAGE
        
        // Container View
        view.addSubview(containerView)
        containerView.bottom(of: progressView, constant: UIViewPadding.big).leftright(constant: UIViewPadding.big).top(of: progressView2, constant: UIViewPadding.big).apply()
        
        // Container View - namelabel
        containerView.addSubview(nameLabel)
        nameLabel.top().left().apply()
        nameLabel.text = String.NAME
        
        // Container View - nameTextfield
        containerView.addSubview(nameTextfield)
        nameTextfield.bottom(of: nameLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        nameTextfield.delegate = self
        nameTextfield.placeholder = String.EXAMPLE_NAME
        
        // Container View - surnameLabel
        containerView.addSubview(surnameLabel)
        surnameLabel.bottom(of: nameTextfield, constant: UIViewPadding.big).left().apply()
        surnameLabel.text = String.SURNAME
        
        // Container View - surnameTextfield
        containerView.addSubview(surnameTextfield)
        surnameTextfield.bottom(of: surnameLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.small).apply()
        surnameTextfield.delegate = self
        surnameTextfield.placeholder = String.EXAMPLE_SURNAME
        
        // Container View - birthdayLabel
        containerView.addSubview(birthdayLabel)
        birthdayLabel.bottom(of: surnameTextfield, constant: UIViewPadding.big).left().apply()
        birthdayLabel.text = String.BIRTHDAY
        
        // Container View - birthdayImageView
        let birthdayImageView = UIImageView.imageView()
        birthdayImageView.image = UIImage.iconCalender()
        containerView.addSubview(birthdayImageView)
        birthdayImageView.bottom(of: birthdayLabel, constant: UIViewPadding.medium).left(constant: UIViewPadding.small).height(constant: 30).widthEqualsHeight().apply()
        
        // Container View - birthdayTextfield
        containerView.addSubview(birthdayTextfield)
        birthdayTextfield.bottom(of: birthdayLabel, constant: UIViewPadding.small).right(of: birthdayImageView, constant: UIViewPadding.big).right().apply()
        birthdayTextfield.placeholder = String.EXAMPLE_DATE
        birthdayTextfield.inputView = datePicker
        birthdayTextfield.addDoneToolbar()
        birthdayTextfield.addTarget(self, action: #selector(textFieldChanged(_:)), for: UIControlEvents.touchDown)
        
        // Container View - phoneLabel
        containerView.addSubview(phoneLabel)
        phoneLabel.bottom(of: birthdayTextfield, constant: UIViewPadding.big).left().apply()
        phoneLabel.text = "\(String.PHONE):"
        
        // Container View - phonecodeTextfield
        containerView.addSubview(phonecodeTextfield)
        phonecodeTextfield.bottom(of: phoneLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.small).width(constant: 60).apply()
        phonecodeTextfield.placeholder = String.EXAMPLE_PHONE_CODE
        phonecodeTextfield.inputView = countryPicker
        phonecodeTextfield.addTarget(self, action: #selector(textFieldChanged(_:)), for: UIControlEvents.touchDown)
        
        // Container View - phoneTextfield
        containerView.addSubview(phoneTextfield)
        phoneTextfield.top(to: phonecodeTextfield, constant: 0).right(of: phonecodeTextfield, constant: UIViewPadding.big).right(constant: UIViewPadding.small).apply()
        phoneTextfield.delegate = self
        phoneTextfield.placeholder = String.EXAMPLE_PHONE_NUMBER
        phoneTextfield.keyboardType = .numberPad
        phoneTextfield.addDoneToolbar()
        
        countryPicker.countryPickerDelegate = self
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
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
    
    func textFieldChanged(_ sender: UITextField) {
        self.activeTextfield = sender
    }
    
    func dateChanged(_ sender: UIDatePicker) {
        self.date = sender.date
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
        
        if textField == phoneTextfield {
            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            return newString.characters.count <= 12
        }
        
        return true
    }
    
    //MARK: UCCountryPickerDelegate
    func countryPicker(countryPicker: UCCountryPicker, didSelectCountry country: UCCountry) {
        phonecodeTextfield.text = "+\(country.phoneCode)"
        phonecodeTextfield.resignFirstResponder()
    }
    
    //MARK: Getters
    func getName() -> String? {
        if let text = nameTextfield.text, !text.isEmpty{
            return text
        }
        return nil
    }
    
    func getSurname() -> String? {
        if let text = surnameTextfield.text, !text.isEmpty{
            return text
        }
        return nil
    }
    
    func getDate() -> Date? {
        return date
    }
    
    func getPhonecode() -> NSNumber? {
        if let text = phonecodeTextfield.text {
            let formatter = NumberFormatter()
            return formatter.number(from: text.trimNonNumeric())
        }
        return nil
    }
    
    func getPhonenumber() -> NSNumber? {
        if let text = phoneTextfield.text {
            let formatter = NumberFormatter()
            return formatter.number(from: text)
        }
        return nil
    }
    
    //MARK: Setters
    func setTextWith(name: String?, surname: String?, birthdate: Date?, phoneCode: NSNumber?, phoneNumber: NSNumber?) {
        nameTextfield.text    = name
        surnameTextfield.text = surname
        date = birthdate
        
        if let phoneCode = phoneCode {
            phonecodeTextfield.text = "+\(phoneCode.stringValue)"
            countryPicker.countryPhoneCode = phoneCode.stringValue
        }
        
        if let phoneNumber = phoneNumber {
            phoneTextfield.text = phoneNumber.stringValue
        }
        
    }
    
    func setDate(oldValue: Date?) {
        if date == oldValue { return }
        
        if let date = date {
            let dateFormatter       = DateFormatter()
            dateFormatter.dateFormat = "dd / MM / yyyy"
            birthdayTextfield.text  = dateFormatter.string(from: date)
        }
    }
    
    
}
