//
//  ViewController.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //*****CONSTANTS
    let scrollView = UIScrollView()
    let containerView = UIView()
    let table = UITableView()
    let margin: CGFloat = 10
    let cellReuseID = "cell"
    let shareButton = UIButton()
    
    //*****COLORS
    var darkBlue = Configuration.darkBlueUIColor
    var medBlue = Configuration.medBlueUIColor
    var lightBlue = Configuration.lightBlueUIColor
    var lightGrey = Configuration.lightGreyUIColor
    var orange = Configuration.orangeUIColor
    
    //*****INFO TO LOAD FROM PARSE
    var eventNameText = "New York Philharmonic & Warner Bros. Present Bugs Bunny at the Symphony"
    var dateTimeLabelText = "7:30PM Wednesday, September 30"
    var venueNameLabelText = "Carnegie Hall, Isaac Stern Auditorium"
    var price = "$20-$55"
    var programInfoText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
    var ticketLink = "http://www.google.com"
    var arrayOfTags: [String] = ["foo", "bar", "matt", "Prima", "sean","travis","Rudd"]
    
    
    override func viewWillAppear(animated: Bool) {
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: shareButton.frame.maxY + margin)
        containerView.layoutIfNeeded()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.redColor()
        
        
        addContainerView()
        addScrollView()
        
        //CONSTANTS
        var navBarHeight = self.navigationController?.navigationBar.frame.maxY ?? view.frame.minY
        var maxWidth: CGFloat = view.frame.width-2*margin
        var titleTextHeight: CGFloat = 30
        var bodyTextHeight: CGFloat = 18
        
        
        //IMAGE
        var image = UIView(frame: CGRect(x: margin, y: margin, width: maxWidth, height: maxWidth/2))
        image.backgroundColor = medBlue
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
        ticketButton.backgroundColor = medBlue
        
        //PROGRAM INFO
        var programInfo = UITextView(frame: CGRect(x: margin, y: venueNameLabel.frame.maxY+margin, width: maxWidth, height: bodyTextHeight*5))
        containerView.addSubview(programInfo)
        programInfo.font = UIFont.systemFontOfSize(12)
        programInfo.editable = false
        programInfo.text = programInfoText
        programInfo.sizeToFit()
        
        
        //TAGS
        let origin = CGPointMake(margin, programInfo.frame.maxY+margin)
        let size = CGSizeMake(maxWidth, 200)
        var tagsContainer = TagListView(frame: CGRect(origin: origin, size: size))
        
        containerView.addSubview(tagsContainer)
        tagsContainer.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
        TagView.color1 = Configuration.tagUIColorB
        TagView.fontName = "HelveticaNeue"
        TagView.cornerRadius = 5
        TagView.textPadding  = CGPointMake(10, 5)
        for tag in arrayOfTags {
            tagsContainer.addTagView(TagView(tagName: tag)) { [weak self] TagView in
                if let strongSelf = self {
                }
            }
        }
        tagsContainer.frame.size.height = tagsContainer.contentSize.height - 45
        
        
        //TABLE
        table.frame = CGRect(x: 0, y: tagsContainer.frame.maxY+margin, width: view.frame.width, height: 2*44)
        containerView.addSubview(table)
        table.scrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
        table.registerNib(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: cellReuseID)
        
        //SHARE BUTTON
        shareButton.frame = CGRect(x: margin, y: table.frame.maxY+margin, width: maxWidth, height: 44)
        containerView.addSubview(shareButton)
        shareButton.backgroundColor = medBlue
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
            //performSegueWithIdentifier("openTicketingWeb", sender: url)
            var webVC = WebViewController()
            webVC.request = NSURLRequest(URL: url)
            showViewController(webVC, sender: nil)
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
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        //scrollView.contentSize = CGSize(width: containerView.bounds.width, height: containerView.bounds.height + margin)
        //println("\(containerView.bounds.width), \(containerView.bounds.height)")
    }
    
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: containerView.bounds.width, height: containerView.bounds.height + margin)
        println("\(containerView.bounds.width), \(containerView.bounds.height)")
    }
    
    //CONFIGURE CONTAINER VIEW
    func addContainerView() {
        scrollView.addSubview(containerView)
        containerView.backgroundColor = lightBlue
        //containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 850) //shareButton.frame.maxY + margin)
        scrollView.layoutIfNeeded()
    }
    
}