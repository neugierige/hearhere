//
//  DateGenerator.swift
//  UICollectionViewPractice
//
//  Created by Prima Prasertrat on 3/21/15.
//  Copyright (c) 2015 GA. All rights reserved.
//

import Foundation

class DateGenerator {
    
    typealias MonthsIndex = (String, [NSDate])
    let dc = DateConverter()
    let now = NSDate()
    
    func distinct<T: Equatable>(source: [T]) -> [T] {
        var unique = [T]()
        for item in source {
            if !contains(unique, item) {
                unique.append(item)
            }
        }
        return unique
    }
    
    func makeDays(numDays: Int) -> [NSDate] {
        var daysArray = [now]
        
        for i in 0..<numDays {
            daysArray.append(daysArray[i].dateByAddingTimeInterval(86400))
        }
        return daysArray
    }
    
    func getMonth(dt: NSDate) -> String {
        let month = dc.getCalendarString(dt, type: "month", abbv: true)
        return month
    }
    
    func buildIndex(dates: [NSDate]) -> [MonthsIndex] {
        let months = dates.map {
            (day) -> String in
            self.getMonth(day)
        }
        
        let uniqueMonths = distinct(months)
        
        return uniqueMonths.map {
            (month) -> MonthsIndex in
            return (month, dates.filter {
                (day) -> Bool in
                self.getMonth(day) == month
                })
        }
    } // end buildIndex
    
}