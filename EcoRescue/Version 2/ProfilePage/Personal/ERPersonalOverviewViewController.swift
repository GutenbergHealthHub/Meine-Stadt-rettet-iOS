//
//  ERPersonalOverviewViewController.swift
//  EcoRescueASB
//
//  Created by Birtan on 30.10.18.
//  Copyright © 2018 Birtan Gültekin. All rights reserved.
//

import UIKit

class ERPersonalOverviewViewController: UIViewController {
    
    private let scrollView = UIScrollView.scrollView()
    
    private let containerView = UIView.view()
    
    private let nameLabel     = UILabel.bodyBoldLabel
    private let surnameLabel  = UILabel.bodyBoldLabel
    private let birthdayLabel = UILabel.bodyBoldLabel
    private let phoneLabel    = UILabel.bodyBoldLabel
    
    private let nameTextfield      = ERRectangleTextField()
    private let surnameTextfield   = ERRectangleTextField()
    private let birthdayTextfield  = ERRectangleTextField()
    private let phonecodeTextfield = ERRectangleTextField()
    private let phoneTextfield     = ERRectangleTextField()
    
    private let streetLabel   = UILabel.bodyBoldLabel
    private let numberLabel   = UILabel.bodyBoldLabel
    private let postcodeLabel = UILabel.bodyBoldLabel
    private let cityLabel     = UILabel.bodyBoldLabel
    private let countryLabel  = UILabel.bodyBoldLabel
    
    private let streetTextfield   = ERRectangleTextField()
    private let numberTextfield   = ERRectangleTextField()
    private let postcodeTextfield = ERRectangleTextField()
    private let cityTextfield     = ERRectangleTextField()
    private let countryTextfield  = ERRectangleTextField()
    
    private let qualificationLabel = UILabel.bodyBoldLabel
    private let professionLabel    = UILabel.bodyBoldLabel
    private let mobileAEDLabel     = UILabel.bodyBoldLabel
    
    private let qualificationView = ERRectangleTextField()
    private let professionView    = ERRectangleTextField()
    private let mobileAEDView     = ERRectangleTextField()
    
    private let seperatorView1 = UIView.seperatorView()
    private let seperatorView2 = UIView.seperatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage.iconEditV2(), style: .plain, target: self, action: #selector(didTappedAdd(sender:)))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        view.addSubview(scrollView)
        scrollView.match().apply()
        
        scrollView.addSubview(containerView)
        containerView.match().width(constant: view.frame.width).apply()
        
        // Container View - namelabel
        containerView.addSubview(nameLabel)
        nameLabel.top(constant: UIViewPadding.large).left(constant: UIViewPadding.large).apply()
        nameLabel.text = String.NAME
        
        // Container View - nameTextfield
        containerView.addSubview(nameTextfield)
        nameTextfield.bottom(of: nameLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        nameTextfield.isUserInteractionEnabled = false
        
        // Container View - surnameLabel
        containerView.addSubview(surnameLabel)
        surnameLabel.bottom(of: nameTextfield, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        surnameLabel.text = String.SURNAME
        
        // Container View - surnameTextfield
        containerView.addSubview(surnameTextfield)
        surnameTextfield.bottom(of: surnameLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        surnameTextfield.isUserInteractionEnabled = false
        
        // Container View - birthdayLabel
        containerView.addSubview(birthdayLabel)
        birthdayLabel.bottom(of: surnameTextfield, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        birthdayLabel.text = String.BIRTHDAY
        
        // Container View - birthdayImageView
        let birthdayImageView = UIImageView.imageView()
        birthdayImageView.image = UIImage.iconCalender()
        containerView.addSubview(birthdayImageView)
        birthdayImageView.bottom(of: birthdayLabel, constant: UIViewPadding.medium).left(constant: UIViewPadding.large).height(constant: 30).widthEqualsHeight().apply()
        
        // Container View - birthdayTextfield
        containerView.addSubview(birthdayTextfield)
        birthdayTextfield.bottom(of: birthdayLabel, constant: UIViewPadding.small).right(of: birthdayImageView, constant: UIViewPadding.big).right(constant: UIViewPadding.large).apply()
        birthdayTextfield.isUserInteractionEnabled = false
        
        // Container View - phoneLabel
        containerView.addSubview(phoneLabel)
        phoneLabel.bottom(of: birthdayTextfield, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        phoneLabel.text = "\(String.PHONE)"
        
        // Container View - phonecodeTextfield
        containerView.addSubview(phonecodeTextfield)
        phonecodeTextfield.bottom(of: phoneLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.large).width(constant: 60).apply()
        phonecodeTextfield.isUserInteractionEnabled = false
        
        // Container View - phoneTextfield
        containerView.addSubview(phoneTextfield)
        phoneTextfield.top(to: phonecodeTextfield, constant: 0).right(of: phonecodeTextfield, constant: UIViewPadding.big).right(constant: UIViewPadding.large).apply()
        phoneTextfield.isUserInteractionEnabled = false
        
        // Container View - seperatorView1
        containerView.addSubview(seperatorView1)
        seperatorView1.bottom(of: phoneTextfield, constant: UIViewPadding.large).leftright(constant: UIViewPadding.medium).height(constant: 2).apply()
        seperatorView1.backgroundColor = UIColor.black
        
        // Container View - streetLabel
        containerView.addSubview(streetLabel)
        streetLabel.bottom(of: seperatorView1, constant: UIViewPadding.large).left(constant: UIViewPadding.large).apply()
        streetLabel.text = String.STREET
        
        // Container View - streetTextfield
        containerView.addSubview(streetTextfield)
        streetTextfield.bottom(of: streetLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        streetTextfield.isUserInteractionEnabled = false
        
        // Container View - numberLabel
        containerView.addSubview(numberLabel)
        numberLabel.bottom(of: streetTextfield, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        numberLabel.text = String.NUMBER
        
        // Container View - numberTextfield
        containerView.addSubview(numberTextfield)
        numberTextfield.bottom(of: numberLabel, constant: UIViewPadding.small).left(constant: UIViewPadding.large).width(constant: view.frame.midX - UIViewPadding.small - 2 * UIViewPadding.big).apply()
        numberTextfield.isUserInteractionEnabled = false
        
        // Container View - postcodeTextfield
        containerView.addSubview(postcodeTextfield)
        postcodeTextfield.top(to: numberTextfield, constant: 0).right(constant: UIViewPadding.large).width(constant: view.frame.midX - UIViewPadding.small - 2 * UIViewPadding.big).apply()
        postcodeTextfield.isUserInteractionEnabled = false
        
        // Container View - postcodeLabel
        containerView.addSubview(postcodeLabel)
        postcodeLabel.top(to: numberLabel, constant: 0).top(of: postcodeTextfield, constant: UIViewPadding.small).left(to: postcodeTextfield, constant: -UIViewPadding.small).apply()
        postcodeLabel.text = String.POSTAL_CODE
        
        // Container View - cityLabel
        containerView.addSubview(cityLabel)
        cityLabel.bottom(of: numberTextfield, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        cityLabel.text = "\(String.CITY):"
        
        // Container View - cityTextfield
        containerView.addSubview(cityTextfield)
        cityTextfield.bottom(of: cityLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        cityTextfield.isUserInteractionEnabled = false
        
        // Container View - countryLabel
        containerView.addSubview(countryLabel)
        countryLabel.bottom(of: cityTextfield, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        countryLabel.text = String.COUNTRY
        
        // Container View - countryTextfield
        containerView.addSubview(countryTextfield)
        countryTextfield.bottom(of: countryLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        countryTextfield.isUserInteractionEnabled = false
        
        // Container View - seperatorView2
        containerView.addSubview(seperatorView2)
        seperatorView2.bottom(of: countryTextfield, constant: UIViewPadding.large).leftright(constant: UIViewPadding.medium).height(constant: 2).apply()
        seperatorView2.backgroundColor = UIColor.black
        
        // Container View - qualificationLabel
        containerView.addSubview(qualificationLabel)
        qualificationLabel.bottom(of: seperatorView2, constant: UIViewPadding.large).left(constant: UIViewPadding.large).apply()
        qualificationLabel.text = String.MY_QUALIFICATION_FOR_REANIMATION
        
        // Container View - qualificationView
        containerView.addSubview(qualificationView)
        qualificationView.bottom(of: qualificationLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        qualificationView.isUserInteractionEnabled = false
        
        // Container View - professionLabel
        containerView.addSubview(professionLabel)
        professionLabel.bottom(of: qualificationView, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        professionLabel.text = String.MY_JOB
        
        // Container View - professionView
        containerView.addSubview(professionView)
        professionView.bottom(of: professionLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        professionView.isUserInteractionEnabled = false
        
        // Container View - mobileAEDLabel
        containerView.addSubview(mobileAEDLabel)
        mobileAEDLabel.bottom(of: professionView, constant: UIViewPadding.big).left(constant: UIViewPadding.large).apply()
        mobileAEDLabel.text = String.MOBILE_AED
        
        // Container View - mobileAEDView
        containerView.addSubview(mobileAEDView)
        mobileAEDView.bottom(of: mobileAEDLabel, constant: UIViewPadding.small).leftright(constant: UIViewPadding.large).apply()
        mobileAEDView.isUserInteractionEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        containerView.height(constant: 11 * UITextFieldHeight.forScreenSize + 11 * nameLabel.frame.height + 14 * UIViewPadding.large).apply()
        
        reloadData()
    }
    
    private func reloadData() {
        if let user = ERUser.current() {
            nameTextfield.text      = user.firstname
            surnameTextfield.text   = user.lastname
            birthdayTextfield.text  = ""
            phonecodeTextfield.text = ""
            phoneTextfield.text     = ""
            
            streetTextfield.text   = user.thoroughfare
            numberTextfield.text   = user.subThoroughfare
            postcodeTextfield.text = user.zip
            cityTextfield.text     = user.city
            countryTextfield.text  = user.country
            
            qualificationView.text = user.qualificationValue
            professionView.text    = user.profession
            mobileAEDView.text     = user.mobileAED as! Bool ? String.YES : String.NO
            
            if let date = user.birthdate {
                let dateFormatter       = DateFormatter()
                dateFormatter.dateFormat = "dd / MM / yyyy"
                birthdayTextfield.text  = dateFormatter.string(from: date)
            }
            
            if let phoneCode = user.phoneCode {
                phonecodeTextfield.text = "+\(phoneCode.stringValue)"
            }
            
            if let phoneNumber = user.phoneNumber {
                phoneTextfield.text = phoneNumber.stringValue
            }
            
            
        }
    }
    
    func didTappedAdd(sender: Any) {
        let vc = ERPersonalPageViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }


}
