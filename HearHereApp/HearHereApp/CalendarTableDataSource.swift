//
//  CalendarTableDataSource.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 4/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias TableViewCellBlock = (cell: UITableViewCell, item: AnyObject?) -> ()
    typealias EventsIndex = (date: String, events: [Event])
    
    let dg = DateGenerator()

    var tableArray = [EventsIndex]()
    let cellIdentifier: String?
    let cellBlock: TableViewCellBlock?
    let navController: UINavigationController?
    
    init(eventsArray: [Event], cellIdentifier: String, navController: UINavigationController, cellBlock: TableViewCellBlock) {
        self.cellIdentifier = cellIdentifier
        self.navController = navController
        self.cellBlock = cellBlock
        super.init()
        loadEvents(eventsArray)
    }
    
    func loadEvents(eventsArray: [Event]) {
        tableArray.removeAll(keepCapacity: false)
        
        var eventsIndexArray = dg.buildEventsIndex(eventsArray)
        
        if eventsIndexArray.count > 5 {
            tableArray += eventsIndexArray[0...4]
        } else {
            tableArray += eventsIndexArray
        }
    }
    
    // **** UITableViewDataSource **** //
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableArray[section].events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.cellIdentifier!, forIndexPath: indexPath) as UITableViewCell
        
        let item: AnyObject = self.tableArray[indexPath.section].events[indexPath.row]
        
        if (self.cellBlock != nil) {
            self.cellBlock!(cell: cell, item: item)
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
        header.textLabel.text = self.tableArray[section].date
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var edvc = EventDetailViewController()
        edvc.event = self.tableArray[indexPath.section].events[indexPath.row]
        CalendarTab().title = "Calendar"
        self.navController?.showViewController(edvc, sender: indexPath)
    }
    
}
