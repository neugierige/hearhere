//
//  ViewController.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let scrollView = UIScrollView()
    let table = UITableView()
    let margin: CGFloat = 10
    let cellReuseID = "cell"
    
    
    //*****INFO TO LOAD FROM PARSE
    var eventNameText = "New York Philharmonic & Warner Bros. Present Bugs Bunny at the Symphony"
    var dateTimeLabelText = "7:30PM Wednesday, September 30"
    var venueNameLabelText = "Carnegie Hall, Isaac Stern Auditorium"
    var price = "$20-$55"
    var programInfoText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
    var ticketLink = "http://www.google.com"
    var arrayOfTags = [UIView]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var navBarHeight = self.navigationController?.navigationBar.frame.maxY ?? view.frame.minY
        var maxWidth: CGFloat = view.frame.width-2*margin
        var titleTextHeight: CGFloat = 30
        var bodyTextHeight: CGFloat = 18
        
        addScrollView()
        var containerView: UIScrollView = scrollView
        
        //IMAGE
        var image = UIView(frame: CGRect(x: margin, y: margin, width: maxWidth, height: maxWidth/2))
        image.backgroundColor = UIColor.blueColor()
        containerView.addSubview(image)
        
        //EVENT NAME
        var eventName = UILabel(frame: CGRect(x: margin, y: image.frame.maxY+margin, width: maxWidth, height: titleTextHeight*2))
        eventName.numberOfLines = 2
        eventName.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        containerView.addSubview(eventName)
        eventName.text = eventNameText
        //eventName.sizeToFit()
        //eventName.layoutIfNeeded()
        eventName.backgroundColor = UIColor.clearColor()
        
        //DATE&TIME
        var dateTimeLabel = UILabel(frame: CGRect(x: margin, y: eventName.frame.maxY+margin, width: maxWidth*3/4, height: bodyTextHeight))
        containerView.addSubview(dateTimeLabel)
        dateTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        dateTimeLabel.text = dateTimeLabelText
        dateTimeLabel.backgroundColor = eventName.backgroundColor
        
        //VENUE NAME
        var venueNameLabel = UILabel(frame: CGRect(x: margin, y: dateTimeLabel.frame.maxY, width: dateTimeLabel.frame.width, height: bodyTextHeight))
        containerView.addSubview(venueNameLabel)
        venueNameLabel.font = dateTimeLabel.font
        venueNameLabel.text = venueNameLabelText
        venueNameLabel.backgroundColor = eventName.backgroundColor
        
        //TICKET BUTTON
        var ticketButton = UIButton(frame: CGRect(x: dateTimeLabel.frame.maxX, y: dateTimeLabel.frame.minY, width: maxWidth/4, height: bodyTextHeight*2))
        containerView.addSubview(ticketButton)
        ticketButton.layer.cornerRadius = 6
        ticketButton.setTitle("\(price)", forState: UIControlState.Normal)
        ticketButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        ticketButton.addTarget(self, action: "openWeb", forControlEvents: UIControlEvents.TouchUpInside)
        ticketButton.backgroundColor = UIColor.blueColor()
        
        //PROGRAM INFO
        var programInfo = UITextView(frame: CGRect(x: margin, y: venueNameLabel.frame.maxY+margin, width: maxWidth, height: bodyTextHeight*5))
        containerView.addSubview(programInfo)
        programInfo.font = UIFont.systemFontOfSize(12)
        programInfo.editable = false
        programInfo.text = programInfoText
        programInfo.sizeToFit()
        
        
        //TAGS CONTAINER
        var tagsContainer = UIView(frame: CGRect(x: margin, y: programInfo.frame.maxY+margin, width: maxWidth, height: 300))
        
        
        //TABLE
        table.frame = CGRect(x: 0, y: tagsContainer.frame.maxY+margin, width: view.frame.width, height: 2*44)
        containerView.addSubview(table)
        table.scrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor.grayColor()
        table.registerNib(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: cellReuseID)
        
        //SHARE BUTTON
        var shareButton = UIButton(frame: CGRect(x: margin, y: table.frame.maxY+margin, width: maxWidth, height: 44))
        containerView.addSubview(shareButton)
        shareButton.backgroundColor = UIColor(red: 0.247, green: 0.341, blue: 0.396, alpha: 1.0)
        shareButton.setTitle("Share", forState: UIControlState.Normal)
        shareButton.addTarget(self, action: "openShare", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    //CONFIGURE TABLE
    var tableCellContent = ["Artist Information", "Venue Information"]
    var selectedIndex = NSNotFound
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    var cellInTable = CustomCell()
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }
        cell?.textLabel?.text = "\(tableCellContent[indexPath.row])"
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell?.selectionStyle = .None
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var detailVC = DetailViewController()
        if indexPath.row == 0 {
            detailVC.textViewText = "artist information"
        } else {
            detailVC.textViewText = "venue information"
        }
        
        showViewController(detailVC, sender: indexPath)
    }
    
    
    
    //WEBVIEW
    func openWeb() {
        
        if let url = NSURL(string: ticketLink) {
            var webVC = WebViewController()
            webVC.request = NSURLRequest(URL: url)
            showViewController(webVC, sender: nil)
        }
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        if identifier == "openTicketingWeb" {
            println("opening ticketing site")
        }
    }

    
    
    //SHARE
    func openShare() {
        let textToShare = "text to share"
        if let myWebsite = NSURL(string: ticketLink) {
            let objectsToShare = [textToShare, myWebsite]
            let shareVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(shareVC, animated: true, completion: nil)
        }
    }
    
    //CONFIGURE SCROLLVIEW
    func addScrollView() {
        scrollView.backgroundColor = UIColor(red: 0.741, green: 0.831, blue: 0.871, alpha: 1.0)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.bounds.height)
        self.view.addSubview(scrollView)
    }
    
}
