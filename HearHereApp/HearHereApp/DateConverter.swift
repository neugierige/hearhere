//
//  DateConverter.swift
//  UICollectionViewPractice
//
//  Created by Prima Prasertrat on 3/21/15.
//  Copyright (c) 2015 GA. All rights reserved.
//

import Foundation

class DateConverter {
    
    enum Day: Int {
        case Sunday = 1, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday
        
        var title: String {
            switch self {
            case .Sunday:   return "Sunday"
            case .Monday:   return "Monday"
            case .Tuesday:  return "Tuesday"
            case .Wednesday:return "Wednesday"
            case .Thursday: return "Thursday"
            case .Friday:   return "Friday"
            case .Saturday: return "Saturday"
            }
        }
        
        var abbv: String {
            switch self {
            case .Sunday:   return "SUN"
            case .Monday:   return "MON"
            case .Tuesday:  return "TUE"
            case .Wednesday:return "WED"
            case .Thursday: return "THU"
            case .Friday:   return "FRI"
            case .Saturday: return "SAT"
            }
        }
    }

    enum Month: Int {
        case January = 1, February, March, April, May, June, July, August, September, October, November, December
        
        var title: String {
            switch self {
            case .January:  return "January"
            case .February: return "February"
            case .March:    return "March"
            case .April:    return "April"
            case .May:      return "May"
            case .June:     return "June"
            case .July:     return "July"
            case .August:   return "August"
            case .September:return "September"
            case .October:  return "October"
            case .November: return "November"
            case .December: return "December"
            }
        }
        
        var abbv: String {
            switch self {
            case .January:  return "JAN"
            case .February: return "FEB"
            case .March:    return "MAR"
            case .April:    return "APR"
            case .May:      return "MAY"
            case .June:     return "JUN"
            case .July:     return "JUL"
            case .August:   return "AUG"
            case .September:return "SEP"
            case .October:  return "OCT"
            case .November: return "NOV"
            case .December: return "DEC"
            }
        }
    }
    
    func formatTime(dt: NSDate) -> String {
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateStyle = .NoStyle
        timeFormatter.timeZone = NSTimeZone(name: "UTC")
        timeFormatter.timeStyle = .ShortStyle       // 3:30pm
        
        let timeString = timeFormatter.stringFromDate(dt)
        return timeString
    }
    
    func formatDate(dt: NSDate, type: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        dateFormatter.timeStyle = .NoStyle
        
        switch type {
        case "short":
            dateFormatter.dateStyle = .ShortStyle   // 3/21/15
        case "medium":
            dateFormatter.dateStyle = .MediumStyle  // Mar 21, 2015
        case "long":
            dateFormatter.dateStyle = .LongStyle    // March 21, 2015
        case "full":
            dateFormatter.dateStyle = .FullStyle    // Saturday, March 21, 2015
        default:
            dateFormatter.dateStyle = .MediumStyle  // Mar 21, 2015
        }
        
        let dateString = dateFormatter.stringFromDate(dt)
        return dateString
    }
    
    func getCalendarInt(dt:NSDate, type:String) -> Int {
        let flags: NSCalendarUnit = .WeekdayCalendarUnit | .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit
        let dateComponents = NSCalendar.currentCalendar().components(flags, fromDate: dt)
        
        switch type {
        case "year":
            return dateComponents.year      // 2,015 (2015)
        case "month":
            return dateComponents.month     // 3 (March)
        case "date":
            return dateComponents.day       // 21
        case "dayofweek":
            return dateComponents.weekday   // 7 (Saturday)
        default:
            return 1
        }
    }
    
    func getCalendarString(dt:NSDate, type:String, abbv:Bool) -> String {
        let num = getCalendarInt(dt, type: type)
        var str: String
        
        switch type {
        case "year":
            str = String(num)
        case "month":
            str = abbv ? Month(rawValue: num)!.abbv : Month(rawValue: num)!.title
        case "date":
            str = String(num)
        case "dayofweek":
            str = abbv ? Day(rawValue: num)!.abbv : Day(rawValue: num)!.title
        default:
            str = "-"
        }
        return str
    }
    
    
    
}