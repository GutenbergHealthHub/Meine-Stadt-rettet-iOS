/*

Copyright (c) 2015 - Alex Leite (al7dev)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

import Foundation

public extension Date {
    
    public func isOnSameDay(days: [Int]) -> Bool {
        var weekday = Calendar.current.component(.weekday, from: self) - 1
        
        if weekday == 0 {
            weekday = 7
        }
        
        for day in days {
            if day == weekday {
                return true
            }
        }
        
        return false
    }
    
    public func isTimeBetween(from: Date, to: Date) -> Bool {
        let fromComponents = Calendar.current.dateComponents([.hour, .minute], from: from)
        let toComponents   = Calendar.current.dateComponents([.hour, .minute], from: to)
        let nowComponents  = Calendar.current.dateComponents([.hour, .minute], from: self)
        
        let fromSeconds = fromComponents.hour! * 3600 + fromComponents.minute! * 60
        let toSeconds   = toComponents.hour! * 3600 + toComponents.minute! * 60
        let nowSeconds  = nowComponents.hour! * 3600 + nowComponents.minute! * 60
        
        if fromSeconds < toSeconds {
            return nowSeconds >= fromSeconds && nowSeconds <= toSeconds
        } else {
            return nowSeconds >= fromSeconds || nowSeconds <= toSeconds
        }
        
    }
        
    public func plusSeconds(_ s: UInt) -> Date {
        return self.addComponentsToDate(seconds: Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minusSeconds(_ s: UInt) -> Date {
        return self.addComponentsToDate(seconds: -Int(s), minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plusMinutes(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minusMinutes(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: -Int(m), hours: 0, days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plusHours(_ h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func minusHours(_ h: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: -Int(h), days: 0, weeks: 0, months: 0, years: 0)
    }
    
    public func plusDays(_ d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func minusDays(_ d: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: -Int(d), weeks: 0, months: 0, years: 0)
    }
    
    public func plusWeeks(_ w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: Int(w), months: 0, years: 0)
    }
    
    public func minusWeeks(_ w: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: -Int(w), months: 0, years: 0)
    }
    
    public func plusMonths(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: Int(m), years: 0)
    }
    
    public func minusMonths(_ m: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: -Int(m), years: 0)
    }
    
    public func plusYears(_ y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: Int(y))
    }
    
    public func minusYears(_ y: UInt) -> Date {
        return self.addComponentsToDate(seconds: 0, minutes: 0, hours: 0, days: 0, weeks: 0, months: 0, years: -Int(y))
    }
    
    fileprivate func addComponentsToDate(seconds sec: Int, minutes min: Int, hours hrs: Int, days d: Int, weeks wks: Int, months mts: Int, years yrs: Int) -> Date {
        var dc:DateComponents = DateComponents()
        dc.second = sec
        dc.minute = min
        dc.hour = hrs
        dc.day = d
        dc.weekOfYear = wks
        dc.month = mts
        dc.year = yrs
        return (Calendar.current as NSCalendar).date(byAdding: dc, to: self, options: [])!
    }
    
    public func midnightUTCDate() -> Date {
        var dc:DateComponents = (Calendar.current as NSCalendar).components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day], from: self)
        dc.hour = 0
        dc.minute = 0
        dc.second = 0
        dc.nanosecond = 0
        (dc as NSDateComponents).timeZone = TimeZone(secondsFromGMT: 0)
        
        return Calendar.current.date(from: dc)!
    }
    
    public static func secondsBetween(date1 d1:Date, date2 d2:Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.second, from: d1, to: d2, options:[])
        return dc.second!
    }
    
    public static func minutesBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: d1, to: d2, options: [])
        return dc.minute!
    }
    
    public static func hoursBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: d1, to: d2, options: [])
        return dc.hour!
    }
    
    public static func daysBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: d1, to: d2, options: [])
        return dc.day!
    }

    public static func weeksBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.weekOfYear, from: d1, to: d2, options: [])
        return dc.weekOfYear!
    }
    
    public static func monthsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.month, from: d1, to: d2, options: [])
        return dc.month!
    }
    
    public static func yearsBetween(date1 d1: Date, date2 d2: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.year, from: d1, to: d2, options: [])
        return dc.year!
    }
    
    //MARK- Self added
    
    public func daysBetween(_ date: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.day, from: self, to: date, options: [])
        return dc.day!
    }
    
    public func hoursBetween(_ date: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.hour, from: self, to: date, options: [])
        return dc.hour!
    }
    
    public func minutesBetween(_ date: Date) -> Int {
        let dc = (Calendar.current as NSCalendar).components(NSCalendar.Unit.minute, from: self, to: date, options: [])
        return dc.minute!
    }
    
    public static func isSameDay(date1 d1: Date, date2 d2: Date) -> Bool {
        let calendar: Calendar = Calendar.current
        let dd1 = calendar.startOfDay(for: d1)
        let dd2 = calendar.startOfDay(for: d2)
        return Date.daysBetween(date1: dd1, date2: dd2) == 0
    }
    
    //MARK- Comparison Methods
    
    public func isGreaterThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedDescending)
    }
    
    public func isLessThan(_ date: Date) -> Bool {
        return (self.compare(date) == .orderedAscending)
    }
    
    //MARK- Computed Properties
    
    public var day: UInt {
        return UInt((Calendar.current as NSCalendar).component(.day, from: self))
    }
    
    public var month: UInt {
        return UInt((Calendar.current as NSCalendar).component(.month, from: self))
    }
    
    public var year: UInt {
        return UInt((Calendar.current as NSCalendar).component(.year, from: self))
    }
    
    public var hour: UInt {
        return UInt((Calendar.current as NSCalendar).component(.hour, from: self))
    }
    
    public var minute: UInt {
        return UInt((Calendar.current as NSCalendar).component(.minute, from: self))
    }
    
    public var second: UInt {
        return UInt((Calendar.current as NSCalendar).component(.second, from: self))
    }
    
    //MARK- String
    
    public func toDateString() -> String {
        let dateFormatter = DateFormatter()
        
        let preferredLanguage = Locale.preferredLanguages[0] as String
        if preferredLanguage == "en" {
            dateFormatter.dateFormat = "MMM d, yyyy"
        } else {
            dateFormatter.dateFormat = "dd.MM.yyyy"
        }
        return dateFormatter.string(from: self)
    }
    
    public func toDayString() -> String {
        // NormalizeString
        let calendar = Calendar.current
        let d1 = calendar.startOfDay(for: self)
        let d2 = calendar.startOfDay(for: Date())
        
        let dateFormatter = DateFormatter()
        
        let daysBetween = d1.daysBetween(d2)
        if daysBetween == 0 {
            return "\(String.TODAY)"
            
        } else {
            let preferredLanguage = Locale.preferredLanguages[0] as String
            if preferredLanguage == "en" {
                dateFormatter.dateFormat = "MMM d, yyyy"
            } else {
                dateFormatter.dateFormat = "dd. MMM yyyy"
            }
            return dateFormatter.string(from: self)
        }
    }
    
    public func toString() -> String {
        let preferredLanguage = Locale.preferredLanguages[0] as String
        let dateFormatter = DateFormatter()
        
        if self.daysBetween(Date()) != 0 {
            if preferredLanguage == "en" {
                dateFormatter.dateFormat = "MMM d, yyyy, h:mm a"
            } else {
                dateFormatter.dateFormat = "dd.MM.yyyy, HH:mm"
            }
            return dateFormatter.string(from: self)
            
        } else {
            if preferredLanguage == "en" {
                dateFormatter.dateFormat = "h:mm a"
            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            return "\(String.TODAY), \(dateFormatter.string(from: self))"
        }
    }

}
