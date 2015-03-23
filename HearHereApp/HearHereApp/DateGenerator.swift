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
    typealias EventsIndex = (String, [Event])
    
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
    
    // Day is Tuesday, March 24, 2015
    func getEventDate(event: Event) -> String {
        let eventDate = dc.formatDate(event.dateTime, type: "full")
        return eventDate
    }
    
    func buildEventsIndex(events: [Event]) -> [EventsIndex] {
        let eventDates = events.map {
            (event) -> String in
            self.getEventDate(event)
        }
        
        let uniqueEventDates = distinct(eventDates)
        
        return uniqueEventDates.map {
            (evDate) -> EventsIndex in
            return (evDate, events.filter {
                (event) -> Bool in
                self.getEventDate(event) == evDate
                })
        }
    } // end buildEventsIndex

        
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