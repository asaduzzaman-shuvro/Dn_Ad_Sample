//
//  NewsDateFormatter.swift
//  DNApp
//
//  Created by Ashif Iqbal on 4/1/16.
//  Copyright © 2016 ALi.apps.no. All rights reserved.
//

import Foundation
import UIKit

class NewsDateFormatter {
    static let norwegianDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "nb_NO")
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        
        return dateFormatter
    }()
    
    lazy var serverDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        return dateFormatter
    }()
    
    static let shared = NewsDateFormatter()
    
    func format(serverTime time: String) -> Date {
        self.serverDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        if let date = self.serverDateFormatter.date(from: time) {
            return date
        }
        return Date()
    }

    class func format(_ date: Date, forInvestor: Bool = false) -> String {
        return formatToSisteTime(date: date)
//        return
    }
    
    class func formatToSisteTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = isRepresntingTodaysDate(givenDate: date) ? "HH:mm" : "HH:mm dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func getDownloadedEditionUpdatedAt(dateStr: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        if let newsFeedUpdatedAt = dateFormatter.date(from: dateStr){
            if let dayadded = Calendar.current.date(byAdding: .day, value: 1, to: newsFeedUpdatedAt){
                return formatToNorwegian(dayadded)
            }
        }
        return ""
    }
    
    class func dateFromSeconds(_ secs : Double) -> Date{
        
        let date = Date(timeIntervalSince1970: secs)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        
        let localDate = dateFormatter.string(from: date)
        return dateFormatter.date(from: localDate)!
    }
    
    class func formatToTime(_ date: Date, forInvestor: Bool = false) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    class func formatToMonth(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    class func formatToDay(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.timeZone = TimeZone.current
//        print("NSTimeZone.knownTimeZoneNames(): \(NSTimeZone.knownTimeZoneNames())")
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    class func formatToNorwegian(_ date: Date) -> String {
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "dd-MM-yyyy"
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        
        return norwayFormatter.string(from: date)
    }
    
    class func formatToNorwegianForEdition(date: Date, forEkspress: Bool = false) -> String{
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "EEEE"
        norwayFormatter.locale = Locale(identifier: "nb_NO")
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        var dayName = norwayFormatter.string(from: date)
        let height = UIScreen.main.bounds.size.height
        if !forEkspress{
            if height < 736 || height == 812 {
                norwayFormatter.dateFormat = "EEE"
                dayName = norwayFormatter.string(from: date)
            }
        }
        norwayFormatter.dateFormat = "dd. MMM yyyy"
        let dateInfo = norwayFormatter.string(from: date)
        return "\(dayName.capitalized) \(dateInfo)"
    }
    
    class func formatToNorwegianForEditionDateSelection(dateStr: String) -> String{
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "dd-MM-yyyy"
        norwayFormatter.locale = Locale(identifier: "nb_NO")
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        let date = norwayFormatter.date(from: dateStr)
        norwayFormatter.dateFormat = "EEEE dd. MMMM"
        let dateInfo = norwayFormatter.string(from: date!)
        return dateInfo
    }
    
    class func formatToNorwegianForEditionTitle(dateStr: String) -> String{
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "dd-MM-yyyy"
        norwayFormatter.locale = Locale(identifier: "nb_NO")
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        let date = norwayFormatter.date(from: dateStr)
        norwayFormatter.dateFormat = "EEEE dd. MMM yyyy"
        let dateInfo = norwayFormatter.string(from: date!)
        return dateInfo
    }
    
    class func formatToNorwegianForFordel(_ date: Date) -> String {
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "dd.MM.yyyy"
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        
        return norwayFormatter.string(from: date)
    }
    
    class func formatToNorwegianForAnalytics(_ date: Date) -> String {
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "EEE LLL dd yyyy HH:mm:ss ZZZZ"
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
//        print("norwayFormatterNorway \(norwayFormatter.string(from: date))")
        norwayFormatter.timeZone = TimeZone.current
//        print("norwayFormatterUser \(norwayFormatter.string(from: date))")
        return norwayFormatter.string(from: date)
    }
    
    class func formatToDateFromString(dateStr: String) -> Date{
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "dd-MM-yyyy"
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        if let date = norwayFormatter.date(from: dateStr){
            return date
        }
        return Date()
    }
    
    class func fordelRemainingValidDays(date: Date) -> String{
        let norwayFormatter = DateFormatter()
        norwayFormatter.dateFormat = "dd.MM.yyyy"
        norwayFormatter.timeZone = TimeZone(identifier: "Europe/Oslo")
        
        let nowDateStr = formatToNorwegianForFordel(Date())
        
        let now = norwayFormatter.date(from: nowDateStr)
        
        let dateToCompareStr = formatToNorwegianForFordel(date)
        
        let dateToCompare = norwayFormatter.date(from: dateToCompareStr)
        
        let calendar = Calendar.current
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDay(for: now!)
        let date2 = calendar.startOfDay(for: dateToCompare!)
        
        let flags = NSCalendar.Unit.day
        let components = (calendar as NSCalendar).components(flags, from: date1, to: date2, options: NSCalendar.Options())
        
//        print("components.day \(String(describing: components.day))")
        return "\(components.day!)"
    }
    
    class func formatToFeatureTimeStamp(_ date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }

    class func timeStringOlderThanYear(_ date:Date, forInvestor: Bool = false) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date)
    }
    
    class func timeStringOlderThanDay(_ date:Date, forInvestor: Bool = false) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.string(from: date).lowercased()
    }
    
    class func timeAgoSinceDate(_ date:Date, forInvestor: Bool = false) -> String {
        
        guard date.timeIntervalSinceNow.sign == .minus else{
            return NSLocalizedString("dateFormatter_justNow", comment: "")
        }
        
        let calendar = Calendar.current
        
        let now = Date()
        
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if components.year! >= 1
        {
            return self.timeStringOlderThanYear(date)
        }
        else if components.day! >= 1 || components.month! >= 1 || components.weekOfYear! >= 1
        {
            return self.timeStringOlderThanDay(date)
        }
        else if components.hour! >= 1 || components.minute! >= 1
        {
            return self.formatToTime(date)
        }
        else
        {
            return NSLocalizedString("dateFormatter_justNow", comment: "")
        }
    }
    
    class func formatToInvestorTime(timeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        //dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = isRepresntingTodaysDate(givenDate: date) ? "HH:mm:ss" : "dd MMM, HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    class func isRepresntingTodaysDate(givenDate: Date) -> Bool {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return (dateFormatter.string(from: currentDate) == dateFormatter.string(from: givenDate))
    }
    
    
//    // let timeStamp = 1521191232.0
//    let timeStamp = 1519729976.0
//    printConvertedTime(timeStamp: timeStamp)
    
    class func formateSearchDate(for date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
    
    class func formatNewsletterSubscriptionSummaryDate(givenDate: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: givenDate)
    }
    
    class func getCurrentMonthNameInNorwegian() -> String {
        norwegianDateFormatter.dateFormat = "MMMM"
        return norwegianDateFormatter.string(from: Date())
    }
    
    class func getNextMonthNameInNorwegian() -> String {
        norwegianDateFormatter.dateFormat = "MMMM"
        let incrementedDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
        return norwegianDateFormatter.string(from: incrementedDate)
    }
}
