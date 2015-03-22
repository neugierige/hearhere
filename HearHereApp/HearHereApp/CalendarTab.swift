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
    let rowHeight:CGFloat = 80.0
    let tableY:CGFloat = 108.0
    var eventsArray = [Event]()
    var sectionNames = ["Date One", "Date Two", "Date Three", "Date Four"]
    var datesArray = [NSDate]()
    
    typealias MonthsIndex = (month: String, dates: [NSDate])
    let dg = DateGenerator()
    let dc = DateConverter()
    let calHeight:CGFloat = 50.0
    var dataArray = [MonthsIndex]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateData()
        
        DataManager.retrieveAllEvents { events in
            self.eventsArray = events
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
        
        var flowLayout:UICollectionViewFlowLayout = StickyHeaderFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: 50, height: 50)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSize(width: 50, height: 50)
        
        var __collectionView:UICollectionView? = UICollectionView(frame: CGRectMake(0, tableY - 50.0, self.view.frame.width, 51), collectionViewLayout: flowLayout)
        __collectionView?.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "calendarCollectionCell")
        __collectionView?.registerClass(CalendarHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "calendarCollectionHeader")
        __collectionView?.delegate = self
        __collectionView?.dataSource = self
        __collectionView?.backgroundColor = UIColor.blackColor()
        
        self.view.addSubview(__collectionView!)
        
        // ******************  /UICollectionView ********************* //
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sectionNames.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("calendarCell", forIndexPath: indexPath) as UITableViewCell
        
        let event = eventsArray[indexPath.row]
        
        if cell.viewWithTag(1) == nil {
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width / 5, height: self.rowHeight))
            timeLabel.tag = 1
            // med blue
            timeLabel.textColor = UIColor(red: 0.247, green: 0.341, blue: 0.396, alpha: 1.0)
            timeLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
            timeLabel.textAlignment = .Center
            cell.contentView.addSubview(timeLabel)
        }
        
        let timeLabel = cell.viewWithTag(1) as UILabel
        
        // Populate text labels
        let eventTime = formatDateTime(event.dateTime, type: "time")
        timeLabel.text = "\(eventTime)"
        cell.textLabel?.text = "\(event.title)"
        cell.detailTextLabel?.text = "\(event.venue[0].name)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        
        // med blue
        header.contentView.backgroundColor = UIColor(red: 0.247, green: 0.341, blue: 0.396, alpha: 1.0)
        // light blue
        header.textLabel.textColor = UIColor(red: 0.741, green: 0.831, blue: 0.871, alpha: 1.0)
        let sectionDate = formatDateTime(self.datesArray[section], type: "date")
        header.textLabel.text = sectionDate
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var edvc = EventDetailViewController()
        edvc.event = eventsArray[indexPath.row]
        presentViewController(edvc, animated: true, completion: nil)
    }
    func formatDateTime(dt: NSDate, type: String) -> String {
        let dateFormatter = NSDateFormatter()
        
        switch type {
        case "date":
            dateFormatter.dateStyle = .FullStyle
            dateFormatter.timeStyle = .NoStyle
        case "time":
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
        default:
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .ShortStyle
        }
        
        let dtString = dateFormatter.stringFromDate(dt)
        return dtString
    }
    
    // ******************  UICollectionView ********************* //
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataArray[section].dates.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "calendarCollectionCell",
            forIndexPath: indexPath) as CalendarCollectionViewCell
        
        let dt = getCurrItem(indexPath)
        let dayString = dc.getCalendarString(dt, type: "dayofweek", abbv: true)
        let dateInt = dc.getCalendarString(dt, type: "date", abbv: false)
        
        cell.dayLabel.text = dayString
        cell.dateLabel.text = dateInt
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath){
            
            let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
                as UICollectionViewCell!
            
            let dt = getCurrItem(indexPath)
            DataManager.retrieveEventsForDate(dt) { events in
                self.eventsArray = events
                self.tableView?.reloadData()
            }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedCell = collectionView.cellForItemAtIndexPath(indexPath)
            as UICollectionViewCell!
        
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        var identifier = "calendarCollectionHeader"
        
        let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
            withReuseIdentifier: identifier,
            forIndexPath: indexPath) as UICollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader{
            if let header = view as? CalendarHeaderReusableView {
                header.monthLabel.text = "\(dataArray[indexPath.section].month)"
            }
        }
        return view
    }
    
    func generateData() {
        let datesArray = dg.makeDays(180)
        self.dataArray += dg.buildIndex(datesArray)
    }
    
    func getCurrItem(indexPath: NSIndexPath) -> NSDate {
        let currDate = dataArray[indexPath.section].dates[indexPath.row]
        return currDate
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
