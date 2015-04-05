//
//  CalendarTableDataSource.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 4/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

typealias TableViewCellConfigureBlock = (cell: UITableViewCell, item: AnyObject?) -> ()

class CalendarTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias EventsIndex = (date: String, events: [Event])
    let dg = DateGenerator()
    var eventsByDateArray = [EventsIndex]()
    
    var itemsArray = [EventsIndex]()
    var itemIdentifier: String?
    var configureCellBlock: TableViewCellConfigureBlock?
    let navigationController: UINavigationController?
    
    init(items: [EventsIndex], cellIdentifier: String, navigationController: UINavigationController, configureBlock: TableViewCellConfigureBlock) {
        self.itemsArray = items
        self.itemIdentifier = cellIdentifier
        self.navigationController = navigationController
        self.configureCellBlock = configureBlock
        super.init()
    }
    
    func buildItemsArray(events: [Event]) {
        var allEvents = self.dg.buildEventsIndex(events)
        
        if allEvents.count > 5 {
            self.eventsByDateArray += allEvents[0...4]
        } else {
            self.eventsByDateArray += allEvents
        }

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
    
    // **** UITableViewDelegate **** //
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        header.contentView.backgroundColor = Configuration.medBlueUIColor
        header.textLabel.textColor = Configuration.lightBlueUIColor
        header.textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        header.textLabel.text = self.itemsArray[section].date
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var edvc = EventDetailViewController()
        edvc.event = self.itemsArray[indexPath.section].events[indexPath.row]
        self.navigationController?.showViewController(edvc, sender: indexPath)
    }
    
}
