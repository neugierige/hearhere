//
//  CalendarTableDataSource.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 4/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

typealias TableViewCellConfigureBlock = (cell: UITableViewCell, item: AnyObject?) -> ()

class CalendarTableDataSource: NSObject, UITableViewDataSource {
    
    typealias EventsIndex = (date: String, events: [Event])
    var itemsArray = [EventsIndex]()
    var itemIdentifier: String?
    var configureCellBlock: TableViewCellConfigureBlock?
    
    init(items: [EventsIndex], cellIdentifier: String, configureBlock: TableViewCellConfigureBlock) {
        self.itemsArray = items
        self.itemIdentifier = cellIdentifier
        self.configureCellBlock = configureBlock
        super.init()
    }
    
    // **** UITableViewDataSource **** //
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return itemsArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray[section].events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.itemIdentifier!, forIndexPath: indexPath) as UITableViewCell
        
        let item: AnyObject = self.itemsArray[indexPath.section].events[indexPath.row]
        
        if (self.configureCellBlock != nil) {
            self.configureCellBlock!(cell: cell, item: item)
        }
        
        return cell
    }
    
}
