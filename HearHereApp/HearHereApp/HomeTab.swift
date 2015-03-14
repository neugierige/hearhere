//
//  ViewController.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class HomeTab: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?
    let rowHeight:CGFloat = 140.0
    let tableY:CGFloat = 108.0
    var eventsArray = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var event1 = Event(eventID: "AAAA", name: "Beethoven, Berlioz, and Adès", dateTime: NSDate(), venue: "Avery Fisher Hall", image: "avery-fisher-hall.jpg")
        
        for index in 0...20 {
            eventsArray.append(event1)
        }
        
        tableView = UITableView(frame: CGRect(x: 0, y: tableY, width: self.view.frame.width, height: self.view.frame.height - tableY - 49.0), style: UITableViewStyle.Plain)
        
        if let theTableView = tableView {
            theTableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "identifier")
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            theTableView.rowHeight = self.rowHeight
            theTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            view.addSubview(theTableView)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("identifier", forIndexPath: indexPath) as UITableViewCell
        
        let event = eventsArray[indexPath.row]
        let cellColors = chooseColors(indexPath.row)
        
        // Create background image
        let backgroundView = UIImageView()
        backgroundView.contentMode = .ScaleToFill
        backgroundView.image = UIImage(named: event.image)
        cell.backgroundView = backgroundView
        
        // Tint background image
        let colorOverlay = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.rowHeight))
        colorOverlay.autoresizingMask = .FlexibleWidth
        colorOverlay.backgroundColor = cellColors.bkgColor
        if let background = cell.backgroundView {
            for view in background.subviews {
                view.removeFromSuperview()
            }
            background.addSubview(colorOverlay)
        }
        
        // Populate text labels
        let dateTime = formatDateTime(event.dateTime)
        
        cell.textLabel?.text = "\(event.name)\n"
        cell.textLabel?.textColor = cellColors.txtColor
        
        cell.detailTextLabel?.text = "\(dateTime)\n\(event.venue)"
        cell.detailTextLabel?.textColor = cellColors.txtColor
        return cell
    }
    
    func chooseColors(index: Int) -> (bkgColor: UIColor, txtColor: UIColor) {
        var bkgColor = UIColor()
        var txtColor = UIColor.whiteColor()
        
        switch index % 3 {
        case 0:
            bkgColor = UIColor(red: 0.247, green: 0.341, blue: 0.396, alpha: 0.75) // med blue
        case 1:
            bkgColor = UIColor(red: 0.741, green: 0.831, blue: 0.871, alpha: 0.85) // light blue
            txtColor = UIColor(red: 0.168, green: 0.227, blue: 0.258, alpha: 1.0) // dark blue
        case 2:
            bkgColor = UIColor(red: 0.906, green: 0.298, blue: 0.235, alpha: 0.75) // orange
        default:
            bkgColor = UIColor(red: 0.247, green: 0.341, blue: 0.396, alpha: 0.75) // med blue
        }
        return (bkgColor, txtColor)
    }
    
    func formatDateTime(dt: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let dateString = dateFormatter.stringFromDate(dt)
        return dateString
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


}

