//
//  ERUser.swift
//  EcoRescue
//
//  Created by Christoph Erl on 15.06.16.
//  Copyright © 2016 Christoph Erl. All rights reserved.
//

import UIKit
import UCKit
import Parse

private let kERUserKeyFirstname     = "firstname"
private let kERUserKeyLastname      = "lastname"

private let kERUserKeyActivation    = "activation"
private let kERUserKeyDatePaused    = "datePaused"

private let kERUserKeyLocation      = "location"

private let kERUserKeyAddressStreet     = "thoroughfare"
private let kERUserKeyAddressPostCode   = "zip"
private let kERUserKeyAddressNumber     = "subThoroughfare"
private let kERUserKeyAddressCity       = "city"

private let kERUserKeyPhoneNumber       = "phoneNumber"
private let kERUserKeyPhoneCode         = "phoneCode"

enum UserResponderState {
    case inactive, active, paused
}

enum ERUserActivationType: Int {
    case    ok      = 2,
    review  = 1,
    email   = 0
}

class ERUser: PFUser {
    
    @NSManaged var firstname:   String?
    @NSManaged var lastname:    String?
    
    @NSManaged var code:            String?
    
    @NSManaged var country:         String?
    @NSManaged var city:            String?
    @NSManaged var zip:             String?
    @NSManaged var thoroughfare:    String?
    @NSManaged var subThoroughfare: String?
    
    @NSManaged var phoneNumber:     NSNumber?
    @NSManaged var phoneCode:       NSNumber?
    
    @NSManaged var emailVerified:   NSNumber?
    
    @NSManaged var profilePicture:  PFFileObject?
    
    @NSManaged var pausedUntil:     Date?
    @NSManaged var activated:      NSNumber?
    
    @NSManaged var sound:           String?
    
    @NSManaged var profession:      String?
    @NSManaged var qualification:   String?
    
    @NSManaged var location:        PFGeoPoint?
    
    @NSManaged var birthdate:     Date?
    
    @NSManaged var certificateFR:   ERCertificate?
    @NSManaged var certificates:    [ERCertificate]?
    
    @NSManaged var mobileAED: NSNumber?
    @NSManaged var mobileAEDStatus: NSNumber?
    @NSManaged var mobileAEDProducer: NSNumber?
    @NSManaged var mobileAEDType: String?
    @NSManaged var mobileAEDImage: PFFileObject?
    
    @NSManaged var dutyFrom: Date?
    @NSManaged var dutyTo: Date?
    @NSManaged var dutyHome: NSNumber?
    @NSManaged var dutyOff: NSNumber?
    @NSManaged var dutyDays: NSArray?
    
    @NSManaged var receivesPracticeAlarm: NSNumber?
    
    @NSManaged var origin: String?
    
    // Basic Contract
    @NSManaged var userContractBasic:   ERUserContract?
    
    
    var initials:           String  { return p_getInitials()        }
    var formattedName:      String? { return p_getFormattedName()   }
    var formattedStreet:    String? { return getFormattedStreet()  }
    var formattedCity:      String? { return getFormattedCity()   }
    var formattedAddress:   String? { return getFormattedAddress()   }
    
    var formattedPhone:      String? { return getFormattedPhone()   }
    var formattedBirthdate:  String? { return getFormattedBirthdate()   }
    
    // MARK: - Public Methods
    
    func add(certificate: ERCertificate) {
        add(certificate, forKey: "certificates")
    }
    
    func remove(certificate: ERCertificate) {
        remove(certificate, forKey: "certificates")
    }
    
    var activatedValue: Bool {
        set(newValue)   { activated = NSNumber(value: newValue as Bool) }
        get             { return activated?.boolValue ?? false }
    }
    
    var emailVerifiedValue: Bool {
        set(newValue)   { emailVerified = NSNumber(value: newValue as Bool) }
        get             { return emailVerified?.boolValue ?? false }
    }
    
    var address: UCAddress {
        let address = UCAddress()
        address.street  = thoroughfare
        address.number  = subThoroughfare
        address.zip     = zip
        address.city    = city
        return address
    }
    
    // MARK: - Private Methods
    fileprivate func p_getFormattedName() -> String {
        var output = ""
        
        // FirstName
        if let firstname = firstname { output += firstname }
        
        // Space
        if firstname != nil && lastname != nil { output += " " }
        
        // LastName
        if let lastname = lastname { output += lastname }
        
        return output
    }
    
    fileprivate func getFormattedCity() -> String?  {
        let cityString = (city ?? "")
        let zipString = (zip ?? "")
        
        return zipString + " " + cityString
    }
    
    fileprivate func getFormattedStreet() -> String? {
        let street = (thoroughfare ?? "")
        let number = (subThoroughfare ?? "")
        
        return street + " " + number
    }
    
    fileprivate func getFormattedAddress() -> String? {
        let street  = getFormattedStreet() ?? ""
        let city    = getFormattedCity() ?? ""
        
        return street + "\n" + city
    }
    
    fileprivate func getFormattedBirthdate() -> String? {
        if let birthdate = birthdate {
            let dateFormatter       = DateFormatter()
            dateFormatter.dateStyle = .long
            return dateFormatter.string(from: birthdate)
        }
        
        return nil
    }
    
    fileprivate func p_getInitials() -> String {
        let defaultCharacter: Character = " "
        
        let l1 = firstname?.characters.first ?? defaultCharacter
        let l2 = lastname?.characters.first ?? defaultCharacter
        
        return "\(l1)" + "\(l2)"
    }
    
    fileprivate func getFormattedPhone() -> String? {
        if let phoneCode = phoneCode, let phoneNumber = phoneNumber {
            return "+\(phoneCode.stringValue)" + " " + "\(phoneNumber.stringValue)"
        }
        
        return nil
    }
    
    // MARK: - Calculations
    
    var activationStateString: String {
        return activatedValue ? "" : String.IN_PROCESS
    }
    
    // MARK: - Computed Variables
    
    var responderState: UserResponderState {
        if active       { return .active    }
        else if paused  { return .paused    }
        else            { return .inactive  }
    }
    
    var paused: Bool {
        return !activeService && activeCertificateFR && activeUserContractBasic && activePersonal
    }
    
    var active: Bool {
        return activeService && activeCertificateFR && activeUserContractBasic && activePersonal
    }
    
    var activeUserContractBasic: Bool {
        if let userContractBasic = userContractBasic, let contractBasic = userContractBasic.contract {
            return contractBasic.valid && userContractBasic.stateValue == .signed
        }
        return false
    }
    
    var activeCertificateFR: Bool {
        if let certificateFR = certificateFR {
            return certificateFR.verified
        }
        return false
    }
    
    var activeService: Bool {
        return Date().isGreaterThan(pausedUntil ?? Date())
    }
    
    var activePersonal: Bool {
        return validPhoneNumber && validCode && validAddress && validBirthdate && validProfession
    }
    
    var activeColor: UIColor {
        return active ? UIColor.active : UIColor.inactive
    }
    
    var activeString: String? {
        return active ? String.ACTIVE : String.INACTIVE
    }
    
    var qualificationValue: String? {
        if let qualification = qualification {
            for item in ERUser.qualificationTuple {
                if item.0 == qualification { return item.1 }
            }
        }
        return nil
    }
    
    var mobileAEDProducerValue: (Int, String)? {
        if let prod = mobileAEDProducer {
            for item in ERDefibrillator.producerTuple{
                if item.0 == Int(prod) { return item }
            }
        }
        return nil
    }
    
    var dutyDaysValue: [String] {
        var arr: [String] = []
        if let days = dutyDays {
            for item in ERUser.daysTuple {
                if days.contains(item.0) {
                    arr.append(item.1)
                }
            }
        }
        return arr
    }
    
    // MARK: - Static Variables
    
    static var professionStrings: [String] {
        var p_professionStrings = [String]()
        p_professionStrings.append(String.DOCTOR)
        p_professionStrings.append(String.DENTIST)
        p_professionStrings.append(String.DOCTOR_S_ASSISTANT)
        p_professionStrings.append(String.PARAMEDIC)
        p_professionStrings.append(String.RESCUE_ASSISTANT)
        p_professionStrings.append(String.POLICE)
        p_professionStrings.append(String.FIRE_DEPARTMENT_PRO)
        p_professionStrings.append(String.FIRE_DEPARTMENT_VOLUNTARY)
        p_professionStrings.append(String.NURSE)
        p_professionStrings.append(String.AID_ORGANIZATION)
        p_professionStrings.append(String.THERAPIST)
        p_professionStrings.append(String.ARMY)
        p_professionStrings.append(String.STUDENT)
        p_professionStrings.append(String.EMERGENCY_PARAMEDIC)
        p_professionStrings.sort()
        return p_professionStrings
    }
    
    static var qualificationTuple: [(String, String)] {
        var p_qualificationTuple = [(String, String)]()
        p_qualificationTuple.append(("1", String.BLS_COURSE))
        p_qualificationTuple.append(("2", String.FA_COURSE))
        p_qualificationTuple.append(("3", String.PARAMEDIC))
        p_qualificationTuple.append(("4", String(format: String.RESCUE_ASSISTANT + "/" + String.EMERGENCY_PARAMEDIC)))
        p_qualificationTuple.append(("5", String.DOCTOR))
        p_qualificationTuple.append(("6", String.DOCTOR_WITH_SUBSPECIALTY_EMERGENCY_MEDICINE))
        p_qualificationTuple.append(("7", String.PARAMEDIC_TRAINING))
        p_qualificationTuple.append(("8", String.RESCUE_WORKER))
        return p_qualificationTuple
    }
    
    static var daysTuple: [(Int, String)] {
        var p_daysTuple = [(Int, String)]()
        p_daysTuple.append((1, String.MONDAY))
        p_daysTuple.append((2, String.TUESDAY))
        p_daysTuple.append((3, String.WEDNESDAY))
        p_daysTuple.append((4, String.THURSDAY))
        p_daysTuple.append((5, String.FRIDAY))
        p_daysTuple.append((6, String.SATURDAY))
        p_daysTuple.append((7, String.SUNDAY))
        return p_daysTuple
    }
    
    // MARK: - Static User
    private static let kUserPinName = "User"
    
    private static var p_user: ERUser?
    
    static func setCurrent(user: ERUser?) {
        p_user = user
        
        if let user = user {
            user.pinInBackground(withName: kUserPinName)
        } else {
            PFObject.unpinAllObjectsInBackground(withName: kUserPinName)
        }
    }
    
    static override func current() -> ERUser? {
        if let localUser = p_user, let _ = PFUser.current() {
            return localUser
        }
        return nil
    }
    
    // MARK: - Public Methods - Validity
    
    var validPhoneNumber: Bool {
        return phoneNumber != nil && phoneCode != nil
    }
    
    var validCode: Bool {
        return !String.isEmpty(string: code)
    }
    
    var validBirthdate: Bool {
        return birthdate != nil
    }
    
    var validAddress: Bool {
        return !String.isEmpty(string: thoroughfare) && !String.isEmpty(string: subThoroughfare) && !String.isEmpty(string: city) && !String.isEmpty(string: zip)
    }
    
    var validProfession: Bool {
        return !String.isEmpty(string: profession)
    }
    
}

