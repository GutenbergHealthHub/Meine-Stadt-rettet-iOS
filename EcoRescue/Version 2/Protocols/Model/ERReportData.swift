
import UIKit

class ERReportData: NSObject {

    private(set) var data: [ERReportDataItem]
    
    init(data: [ERReportDataItem]) {
        self.data = data
        super.init()
    }
    
    func itemWithText(_ text: String) -> ERReportDataItem? {
        for item in data {
            if item.text == text { return item }
        }
        return nil
    }
    
    func itemWithKey(_ key: NSNumber) -> ERReportDataItem? {
        for item in data {
            if item.key == key as! Int { return item }
        }
        return nil
    }
    
    func itemWithTextArray(_ array: NSArray) -> [ERReportDataItem] {
        var items = [ERReportDataItem]()
        
        for arrayItem in array {
            if let item = itemWithText(arrayItem as! String) {
                items.append(item)
            }
        }
        
        return items
    }
    
    func itemWithKeyArray(_ array: NSArray) -> [ERReportDataItem] {
        var items = [ERReportDataItem]()
        
        for arrayItem in array {
            if let item = itemWithKey(arrayItem as! NSNumber) {
                items.append(item)
            }
        }
        
        return items
    }
    
    var texts: [String] {
        return ERReportData.texts(data)
    }
    
    class func texts(_ data: [ERReportDataItem]) -> [String] {
        var result = [String]()
        for item in data {
            result.append(item.text)
        }
        return result
    }
    
    var keys: [Int] {
        return ERReportData.keys(data)
    }
    
    class func keys(_ data: [ERReportDataItem]) -> [Int] {
        var result = [Int]()
        for item in data {
            result.append(item.key)
        }
        return result
    }
    
    // MARK: - Class Methods - create
    
    class func createReportStartLocationData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NOT_DOCUMENTED))
        items.append(ERReportDataItem(key: 1, text: String.APARTMENT))
        items.append(ERReportDataItem(key: 2, text: String.RETIREMENT_HOME))
        items.append(ERReportDataItem(key: 3, text: String.OFFICE))
        items.append(ERReportDataItem(key: 4, text: String.DOCTOR_S_OFFICE))
        items.append(ERReportDataItem(key: 5, text: String.LOCATION_STREET))
        items.append(ERReportDataItem(key: 6, text: String.PUBLIC))
        items.append(ERReportDataItem(key: 7, text: String.HOSPITAL))
        items.append(ERReportDataItem(key: 8, text: String.MASS_EVENT))
        items.append(ERReportDataItem(key: 9, text: String.OTHER))
        //items.append(ERReportDataItem(key: 9, text: String.GEBURTSHAUS_EINRICHTUNG))
        items.append(ERReportDataItem(key: 10, text: String.EDUCATIONAL_INSTITUTION))
        items.append(ERReportDataItem(key: 11, text: String.SPORTS_CLUB))
        items.append(ERReportDataItem(key: 12, text: String.BIRTH_HOUSE))
        //items.sortIt()
        
        items.append(ERReportDataItem(key: 99, text: String.UNKNOWN))
        
        return ERReportData(data: items)
    }
    
    class func createReportStartDiagnosisData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.CARDIAL))
        items.append(ERReportDataItem(key: 2, text: String.TRAUMA))
        items.append(ERReportDataItem(key: 3, text: String.DROWNING))
        items.append(ERReportDataItem(key: 4, text: String.HYPOXIA))
        items.append(ERReportDataItem(key: 5, text: String.INTOXICATION))
        items.append(ERReportDataItem(key: 6, text: String.ICB_SAB))
        items.append(ERReportDataItem(key: 7, text: String.SIDS))
        items.append(ERReportDataItem(key: 8, text: String.BLEED_TO_DEATH))
        items.append(ERReportDataItem(key: 9, text: String.STROKE))
        items.append(ERReportDataItem(key: 10, text: String.METABOLIC))
        items.append(ERReportDataItem(key: 11, text: String.OTHERS))
        items.append(ERReportDataItem(key: 12, text: String.SEPSIS))
        items.append(ERReportDataItem(key: 99, text: String.UNKNOWN))

        //items.sortIt()
        
        return ERReportData(data: items)
    }
    
    class func createReportStartReactionData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NOT_DOCUMENTED))
        items.append(ERReportDataItem(key: 1, text: String.NARCOTIZED))
        items.append(ERReportDataItem(key: 2, text: String.AWAKE))
        items.append(ERReportDataItem(key: 3, text: String.RESPONDS_TO_SPEECH))
        items.append(ERReportDataItem(key: 4, text: String.RESPONDS_TO_PAIN))
        items.append(ERReportDataItem(key: 5, text: String.UNCONSCIOUS))
        items.append(ERReportDataItem(key: 6, text: String.SLEEPY))
        items.append(ERReportDataItem(key: 99, text: String.NOT_ASSESSABLE))
        
    
        return ERReportData(data: items)
    }
    
    class func createReportStartOrientationData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.NORMAL))
        items.append(ERReportDataItem(key: 2, text: String.LIMITED_ORIENTED))
        items.append(ERReportDataItem(key: 3, text: String.DISORIENTED))
        items.append(ERReportDataItem(key: 99, text: String.UNKNOWN))
        
        return ERReportData(data: items)
    }
    
    class func createReportStartPupilLeftData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.DILATED))
        items.append(ERReportDataItem(key: 2, text: String.MID_DILATED))
        items.append(ERReportDataItem(key: 3, text: String.NARROW))
        
        return ERReportData(data: items)
    }
    
    class func createReportStartPupilRightData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.DILATED))
        items.append(ERReportDataItem(key: 2, text: String.MID_DILATED))
        items.append(ERReportDataItem(key: 3, text: String.NARROW))
        
        return ERReportData(data: items)
    }
    
    
    
    class func createReportStartBreatheData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NOT_DOCUMENTED))
        items.append(ERReportDataItem(key: 8, text: String.GASPING))
        items.append(ERReportDataItem(key: 9, text: String.APNEA))
        items.append(ERReportDataItem(key: 10, text: String.RESPIRATION))

        
        //items.sortIt()
        items.append(ERReportDataItem(key: 11, text: String.NORMAL_BREATHING))
        items.append(ERReportDataItem(key: 99, text: String.NOT_ASSESSABLE))
        
        return ERReportData(data: items)
    }
    
    class func createReportActivityGeneralData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.RECOVERY_POSITION))
        items.append(ERReportDataItem(key: 1, text: String.FEET_ELEVATED))
        items.append(ERReportDataItem(key: 2, text: String.HEAD_ELEVATED))
        items.append(ERReportDataItem(key: 3, text: String.CREATED_FREE_AIRWAYS))
        
        return ERReportData(data: items)
    }
    
    class func createReportActivityBreatheData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.ACCIDENTALLY_PRESENT_WITNESS))
        items.append(ERReportDataItem(key: 2, text: String.APP_FIRST_RESPONDER))
        items.append(ERReportDataItem(key: 3, text: String.WAS_NOT_CARRIED_OUT))
        items.append(ERReportDataItem(key: 98, text: String.NOT_SPECIFIED_PATIENT_NOT_REANIMATED))
        
        return ERReportData(data: items)
    }
    
    class func createReportActivityHeartData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.ACCIDENTALLY_PRESENT_WITNESS))
        items.append(ERReportDataItem(key: 2, text: String.APP_FIRST_RESPONDER))
        items.append(ERReportDataItem(key: 3, text: String.WAS_NOT_CARRIED_OUT))
        items.append(ERReportDataItem(key: 98, text: String.NOT_SPECIFIED_PATIENT_NOT_REANIMATED))
        
        return ERReportData(data: items)
    }
    
    class func createReportActivityDefiData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.ACCIDENTALLY_PRESENT_WITNESS))
        items.append(ERReportDataItem(key: 2, text: String.APP_FIRST_RESPONDER))
        items.append(ERReportDataItem(key: 3, text: String.WAS_NOT_CARRIED_OUT))
        items.append(ERReportDataItem(key: 98, text: String.NOT_SPECIFIED_PATIENT_NOT_REANIMATED))
        
        return ERReportData(data: items)
    }
    
    
    class func createReportEndReactionData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NOT_DOCUMENTED))
        items.append(ERReportDataItem(key: 1, text: String.NARCOTIZED))
        items.append(ERReportDataItem(key: 2, text: String.AWAKE))
        items.append(ERReportDataItem(key: 3, text: String.RESPONDS_TO_SPEECH))
        items.append(ERReportDataItem(key: 4, text: String.RESPONDS_TO_PAIN))
        items.append(ERReportDataItem(key: 5, text: String.UNCONSCIOUS))
        items.append(ERReportDataItem(key: 6, text: String.DEATH))
        items.append(ERReportDataItem(key: 99, text: String.NOT_ASSESSABLE))
        
        return ERReportData(data: items)
    }
    
    class func createReportEndBreatheData() -> ERReportData {
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NOT_DOCUMENTED))
        items.append(ERReportDataItem(key: 1, text: String.RUNNING_REANIMATION))
        items.append(ERReportDataItem(key: 2, text: String.NORMAL_BREATHING))
        items.append(ERReportDataItem(key: 3, text: String.PATIENT_IS_CONSCIOUS))
        items.append(ERReportDataItem(key: 4, text: String.PATIENT_DECEASED))
        
        return ERReportData(data: items)
    }
    
    class func createReportTimeData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.LATER_THAN_AMBULANCE))
        items.append(ERReportDataItem(key: 1, text: String.EARLIER_THAN_AMBULANCE))
        
        return ERReportData(data: items)
    }
    
    class func createDefiPhases() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.MONOPHASIC))
        items.append(ERReportDataItem(key: 1, text: String.BINOPHASIC))
        
        return ERReportData(data: items)
    }
    
    class func createAgeCategoryData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String(format: String.X_DAYS, "1-7")))
        items.append(ERReportDataItem(key: 2, text: String(format: String.X_DAYS, "8-28")))
        items.append(ERReportDataItem(key: 3, text: String(format: String.YOUNGER_THAN_X_YEAR, "1")))
        items.append(ERReportDataItem(key: 4, text: String.SPECIFY_APPROXIMATE_AGE))
        
        return ERReportData(data: items)
    }
    
    class func createReportSexData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.MALE))
        items.append(ERReportDataItem(key: 1, text: String.FEMALE))
        
        return ERReportData(data: items)
    }
    
    class func createReportResuscitationData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.REANIMATION_01))
        items.append(ERReportDataItem(key: 2, text: String.REANIMATION_02))
        items.append(ERReportDataItem(key: 3, text: String.REANIMATION_03))
        items.append(ERReportDataItem(key: 4, text: String.REANIMATION_04))
        items.append(ERReportDataItem(key: 99, text: String.UNKNOWN))
        
        return ERReportData(data: items)
    }
    
    class func createYesNoData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NO))
        items.append(ERReportDataItem(key: 1, text: String.YES))
        
        return ERReportData(data: items)
    }
    
    class func createReportCollapseObservedData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 1, text: String.ACCIDENTALLY_PRESENT_WITNESS))
        items.append(ERReportDataItem(key: 2, text: String.APP_FIRST_RESPONDER))
        items.append(ERReportDataItem(key: 3, text: String.NOT_OBSERVED))
        items.append(ERReportDataItem(key: 99, text: String.UNKNOWN))
        
        return ERReportData(data: items)
    }
    
    class func createReportShockCountData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NOT_SPECIFIED))
        items.append(ERReportDataItem(key: 1, text: String(format:"1 " + String.SHOCK)))
        items.append(ERReportDataItem(key: 2, text: "2-3"))
        items.append(ERReportDataItem(key: 3, text: "4-6"))
        items.append(ERReportDataItem(key: 4, text: "7-9"))
        items.append(ERReportDataItem(key: 5, text: String(format:String.MORE_THAN + " 9")))
        
        return ERReportData(data: items)
    }
    
    class func createReportAEDManufacturerData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.NOT_SPECIFIED))
        items.append(ERReportDataItem(key: 1, text: String.LAERDAL_PHILLIPS_HP))
        items.append(ERReportDataItem(key: 2, text: String.SCHILLER_BRUKER))
        items.append(ERReportDataItem(key: 3, text: String.GS_ELEKTROMEDIZINISCHE_GERAETE))
        items.append(ERReportDataItem(key: 4, text: String.MEDTRONIC_PHYSIO_CONTROL))
        items.append(ERReportDataItem(key: 5, text: String.MARQUETTE))
        items.append(ERReportDataItem(key: 6, text: String.ZOLL))
        items.append(ERReportDataItem(key: 7, text: String.PRIMEDIC))
        items.append(ERReportDataItem(key: 8, text: String.DRAEGER))
        items.append(ERReportDataItem(key: 9, text: String.WEINMANN))
        items.append(ERReportDataItem(key: 10, text: String.WELCH_ALLYN))
        items.append(ERReportDataItem(key: 11, text: String.GE))
        items.append(ERReportDataItem(key: 12, text: String.DEFIBTECH))
        items.append(ERReportDataItem(key: 13, text: String.HEARTSINE))
        items.append(ERReportDataItem(key: 99, text: String.UNCLASSIFIED))
        return ERReportData(data: items)
    }
    
    class func createPublicAEDData() -> ERReportData {
        
        var items = [ERReportDataItem]()
        items.append(ERReportDataItem(key: 0, text: String.PRIVATE_AED))
        items.append(ERReportDataItem(key: 1, text: String.PUBLIC_AED))
        
        return ERReportData(data: items)
    }
    
}

extension Array {
    
    func sortIt() {
        _ = sorted { (element1, element2) -> Bool in
            if let element1 = element1 as? ERReportDataItem, let element2 = element2 as? ERReportDataItem {
                return element1.text < element2.text
            }
            return false
        }
    }
    
}


class ERReportDataItem: NSObject {
    
    var key: Int
    var text: String
    
    init(key: Int, text: String) {
        self.key = key
        self.text = text
        
        super.init()
    }
    

    
}
