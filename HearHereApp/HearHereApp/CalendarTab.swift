//
//  CalendarTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarTab: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var tableView: UITableView?
    let rowHeight:CGFloat = 60.0
    let rangeInclusive = 0...4
    
    var eventsArray = [Event]()
    var datesArray = [NSDate]()
    
    typealias MonthsIndex = (month: String, dates: [NSDate])
    typealias EventsIndex = (date: String, events: [Event])
    
    let dg = DateGenerator()
    let dc = DateConverter()
    
    var monthsArray = [MonthsIndex]()
    var eventsByDateArray = [EventsIndex]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableY:CGFloat = 125.5
        
        generateData()
        
        DataManager.retrieveAllEvents { events in
            //self.eventsArray = events
            var allEvents = self.dg.buildEventsIndex(events)
            
            if allEvents.count > 5 {
                self.eventsByDateArray += allEvents[self.rangeInclusive]
            } else {
                self.eventsByDateArray += allEvents
            }
            
            if let theTableView = self.tableView {
                theTableView.dataSource = self
                theTableView.reloadData()
            }

        }
        
        for index in 0...5 {
            datesArray.append(NSDate())
        }
        
        // ******************  UITableView ********************* //

        tableView = UITableView(frame: CGRect(x: 0, y: tableY, width: self.view.frame.width, height: self.view.frame.height - tableY - 49.0), style: UITableViewStyle.Plain)
        
        if let theTableView = tableView {
            theTableView.registerClass(CalendarTableViewCell.self, forCellReuseIdentifier: "calendarCell")
            theTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "calendarHeader")
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            theTableView.rowHeight = self.rowHeight
            view.addSubview(theTableView)
        }
        // ******************  /UITableView ********************* //
        
        // ******************  UICollectionView ********************* //
        
        let calUnit:CGFloat = 67.5
        
        var flowLayout:UICollectionViewFlowLayout = StickyHeaderFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: calUnit, height: calUnit)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSize(width: calUnit, height: calUnit)
        
        var __collectionView:UICollectionView? = UICollectionView(frame: CGRectMake(0, tableY - calUnit, self.view.frame.width, calUnit), collectionViewLayout: flowLayout)
        __collectionView?.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "calendarCollectionCell")
        __collectionView?.registerClass(CalendarHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "calendarCollectionHeader")
        __collectionView?.delegate = self
        __collectionView?.dataSource = self
        __collectionView?.backgroundColor = Configuration.darkBlueUIColor
        
        self.view.addSubview(__collectionView!)
        
        // ******************  /UICollectionView ********************* //
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return eventsByDateArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsByDateArray[section].events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarCell", forIndexPath: indexPath) as UITableViewCell
        
        //let event = eventsArray[indexPath.row]
        let event = getEvent(indexPath)
        let timeWidth = self.view.frame.width * 0.18
        
        if cell.viewWithTag(1) == nil {
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: timeWidth, height: self.rowHeight))
            timeLabel.tag = 1
            timeLabel.textColor = Configuration.medBlueUIColor
            timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0)
            timeLabel.textAlignment = .Center
            cell.contentView.addSubview(timeLabel)
        }
        
        let timeLabel = cell.viewWithTag(1) as UILabel
        
        // Populate text labels
        let eventTime = dc.formatTime(event.dateTime)
        timeLabel.text = "\(eventTime)"
        cell.textLabel?.text = "\(event.title)"
        cell.detailTextLabel?.text = "\(event.venue[0].name)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        header.contentView.backgroundColor = Configuration.medBlueUIColor
        header.textLabel.textColor = Configuration.lightBlueUIColor
        header.textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        let sectionDate = self.eventsByDateArray[section].date
        header.textLabel.text = sectionDate
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var edvc = EventDetailViewController()
        edvc.event = eventsArray[indexPath.row]
        navigationController?.showViewController(edvc, sender: indexPath)
//        presentViewController(edvc, animated: true, completion: nil)
    }
    
    // ******************  UICollectionView ********************* //
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return monthsArray.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return monthsArray[section].dates.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "calendarCollectionCell",
            forIndexPath: indexPath) as CalendarCollectionViewCell
        
        let dt = getCalendarDate(indexPath)
        let dayString = dc.getCalendarString(dt, type: "dayofweek", abbv: true)
        let dateInt = dc.getCalendarString(dt, type: "date", abbv: false)
        
        cell.dayLabel.text = dayString
        cell.dateLabel.text = dateInt
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath){
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
                as CalendarCollectionViewCell!
            
            let dt = getCalendarDate(indexPath)
            DataManager.retrieveEventsForDate(dt) { events in
                //self.eventsByDateArray += self.dg.buildEventsIndex(self.eventsArray)
                var allEvents = self.dg.buildEventsIndex(events)
                self.eventsByDateArray.removeAll(keepCapacity: false)
                
                if allEvents.count > 5 {
                    self.eventsByDateArray += allEvents[self.rangeInclusive]
                } else {
                    self.eventsByDateArray += allEvents
                }
                    
                self.tableView?.reloadData()
            }
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
            as CalendarCollectionViewCell!
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var identifier = "calendarCollectionHeader"
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
            withReuseIdentifier: identifier,
            forIndexPath: indexPath) as UICollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader{
            if let header = view as? CalendarHeaderReusableView {
                header.monthLabel.text = "\(monthsArray[indexPath.section].month)"
            }
        }
        return view
    }
    
    func generateData() {
        let daysArray = dg.makeDays(180)
        self.monthsArray += dg.buildIndex(daysArray)
    }
    
    func getCalendarDate(indexPath: NSIndexPath) -> NSDate {
        let currDate = monthsArray[indexPath.section].dates[indexPath.row]
        return currDate
    }
    
    func getEvent(indexPath: NSIndexPath) -> Event {
        let currEvent = eventsByDateArray[indexPath.section].events[indexPath.row]
        return currEvent
    }
    
    
    // ******************  UICollectionView ********************* //
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
