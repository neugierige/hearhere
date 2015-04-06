//
//  CalendarCollectionDataSource.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 4/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

protocol ScrollCalendarDelegate {
    func updateList(dt: NSDate)
}

class CalendarCollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    typealias CollectionViewCellBlock = (cell: UICollectionViewCell, item: AnyObject?) -> ()
    typealias MonthsIndex = (month: String, dates: [NSDate])
    
    let dg = DateGenerator()
    let dc = DateConverter()
    
    var monthsArray = [MonthsIndex]()
    
    let cellIdentifier: String?
    let cellBlock: CollectionViewCellBlock?
    var delegate: ScrollCalendarDelegate?
    
    init(numDays: Int, cellIdentifier: String, cellBlock: CollectionViewCellBlock) {
        self.cellIdentifier = cellIdentifier
        self.cellBlock = cellBlock
        super.init()
        generateData(numDays)
    }
    
    func generateData(numDays: Int) {
        let daysArray = dg.makeDays(numDays)
        self.monthsArray += dg.buildIndex(daysArray)
    }
    
    // **** UICollectionViewDataSource **** //

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
                
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var identifier = "calendarCollectionHeader"

        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: identifier, forIndexPath: indexPath) as UICollectionReusableView
    
        if kind == UICollectionElementKindSectionHeader {
            if let header = view as? CalendarHeaderReusableView {
                header.monthLabel.text = "\(monthsArray[indexPath.section].month)"
            }
        }
        return view
    }
    
    // **** UICollectionViewDelegate **** //
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as CalendarCollectionViewCell!
        
        let dt = monthsArray[indexPath.section].dates[indexPath.row]
        self.delegate?.updateList(dt)
    }
    
}
