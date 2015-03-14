//
//  CalendarTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarTab: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView?
    let rowHeight:CGFloat = 80.0
    let tableY:CGFloat = 108.0
    var eventsArray = [Event]()
    var sectionNames = ["Date One", "Date Two", "Date Three", "Date Four"]
    var datesArray = [NSDate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var event1 = Event(eventID: "BBBB", name: "Masterworks Festival Chorus New York City Chamber Orchestra", dateTime: NSDate(), venue: "Carnegie Hall", image: "")
        
        for index in 0...20 {
            eventsArray.append(event1)
        }
        
        for index in 0...5 {
            datesArray.append(NSDate())
        }
        
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
        
        // Populate text labels
        let eventTime = formatDateTime(event.dateTime, type: "time")
        cell.textLabel?.text = eventTime
        cell.detailTextLabel?.text = "\(event.name)\n\n\(event.venue)"
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
