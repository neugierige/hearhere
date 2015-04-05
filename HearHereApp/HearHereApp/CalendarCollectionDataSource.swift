//
//  CalendarCollectionDataSource.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 4/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarCollectionDataSource: NSObject, UICollectionViewDataSource {
    
    typealias CollectionViewCellBlock = (cell: UICollectionViewCell, item: AnyObject?) -> ()
    typealias MonthsIndex = (month: String, dates: [NSDate])
    
    let dg = DateGenerator()
    let dc = DateConverter()
    
    var monthsArray = [MonthsIndex]()
    
    let cellIdentifier: String?
    let cellBlock: CollectionViewCellBlock?
    
    init(cellIdentifier: String, cellBlock: CollectionViewCellBlock) {
        self.cellIdentifier = cellIdentifier
        self.cellBlock = cellBlock
        super.init()
        generateData()
    }
    
    func generateData() {
        let daysArray = dg.makeDays(180)
        self.monthsArray += dg.buildIndex(daysArray)
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return monthsArray.count
    }
   
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthsArray[section].dates.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            self.cellIdentifier!,
            forIndexPath: indexPath) as CalendarCollectionViewCell
        
        let item: AnyObject = self.monthsArray[indexPath.section].dates[indexPath.row]
        
        if (self.cellBlock != nil) {
            self.cellBlock!(cell: cell, item: item)
        }
        
//        let dt = monthsArray[indexPath.section].dates[indexPath.row]
//        let dayString = dc.getCalendarString(dt, type: "dayofweek", abbv: true)
//        let dateInt = dc.getCalendarString(dt, type: "date", abbv: false)
//        
//        cell.dayLabel.text = dayString
//        cell.dateLabel.text = dateInt
        
        return cell
    }
}
