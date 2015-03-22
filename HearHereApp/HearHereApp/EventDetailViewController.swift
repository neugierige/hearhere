//
//  ViewController.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var event: Event!
    let cornerRadius:CGFloat = 5
    
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
    
    
    override func viewWillAppear(animated: Bool) {
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: shareButton.frame.maxY + margin)
        containerView.layoutIfNeeded()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addContainerView()
        addScrollView()
        
        //CONSTANTS
        var navBarHeight = self.navigationController?.navigationBar.frame.maxY ?? view.frame.minY
        var maxWidth: CGFloat = view.frame.width-2*margin
        var titleTextHeight: CGFloat = 30
        var bodyTextHeight: CGFloat = 18
        
        
        //IMAGE
        var image = UIImageView(image: event.photo)
        image.frame = CGRect(x: margin, y: margin, width: maxWidth, height: maxWidth/2)
        image.layer.cornerRadius = cornerRadius
        image.layer.masksToBounds = true
        image.contentMode = UIViewContentMode.ScaleAspectFill
        containerView.addSubview(image)
        
        //EVENT NAME
        var eventName = UILabel(frame: CGRect(x: margin, y: image.frame.maxY+margin, width: maxWidth, height: titleTextHeight*2))
        eventName.lineBreakMode = NSLineBreakMode.ByWordWrapping
        eventName.numberOfLines = 2
        eventName.font = UIFont(name: "HelveticaNeue", size: 20)
        containerView.addSubview(eventName)
        eventName.text = event.title
        eventName.backgroundColor = UIColor.clearColor()
        
        //DATE&TIME
        var dateTimeLabel = UILabel(frame: CGRect(x: margin, y: eventName.frame.maxY+margin, width: maxWidth*3/4, height: bodyTextHeight))
        containerView.addSubview(dateTimeLabel)
        dateTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        var dateFormatted = NSDateFormatter()
        dateFormatted.dateFormat = "h:mma EEE, MMM d"
        dateTimeLabel.text = dateFormatted.stringFromDate(event.dateTime)
        dateTimeLabel.backgroundColor = eventName.backgroundColor
        
        //VENUE NAME
        var venueNameLabel = UILabel(frame: CGRect(x: margin, y: dateTimeLabel.frame.maxY, width: dateTimeLabel.frame.width, height: bodyTextHeight))
        containerView.addSubview(venueNameLabel)
        venueNameLabel.font = dateTimeLabel.font
        venueNameLabel.text = event.venue[0].name
        venueNameLabel.backgroundColor = eventName.backgroundColor
        
        //TICKET BUTTON
        var ticketButton = UIButton(frame: CGRect(x: dateTimeLabel.frame.maxX, y: dateTimeLabel.frame.minY, width: maxWidth/4, height: bodyTextHeight*2))
        containerView.addSubview(ticketButton)
        ticketButton.layer.cornerRadius = cornerRadius
        
        if event.priceMin == 0 {
            ticketButton.setTitle("Free", forState: .Normal)
        } else if event.priceMax == nil {
            ticketButton.setTitle("$\(Int(event.priceMin))", forState: .Normal)
        } else {
            ticketButton.setTitle("$\(Int(event.priceMin))-$\(Int(event.priceMax))", forState: UIControlState.Normal)
        }
        
        ticketButton.titleLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        ticketButton.titleLabel?.textAlignment = NSTextAlignment.Center
        ticketButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        ticketButton.addTarget(self, action: "openWeb", forControlEvents: UIControlEvents.TouchUpInside)
        ticketButton.backgroundColor = medBlue
        
        //PROGRAM INFO
        var programInfo = UITextView(frame: CGRect(x: margin, y: venueNameLabel.frame.maxY+margin, width: maxWidth, height: bodyTextHeight*5))
        programInfo.font = UIFont.systemFontOfSize(12)
        programInfo.editable = false
        programInfo.scrollEnabled = false
        programInfo.text = event.program
        programInfo.backgroundColor = lightGrey
        programInfo.sizeToFit()
        
        var programBackground = UIView(frame: CGRect(x: margin, y: programInfo.frame.minY, width: maxWidth, height: programInfo.frame.height))
        programBackground.backgroundColor = programInfo.backgroundColor
        containerView.addSubview(programBackground)
        containerView.addSubview(programInfo)
        
        //TAGS
        let origin = CGPointMake(margin, programInfo.frame.maxY+margin)
        let size = CGSizeMake(maxWidth, 50)
        var tagsContainer = TagListView(frame: CGRect(origin: origin, size: size))
        tagsContainer.scrollEnabled = false
        
        containerView.addSubview(tagsContainer)
        tagsContainer.backgroundColor = lightGrey
        TagView.color1 = Configuration.tagUIColorB
        TagView.color2 = Configuration.tagFontUIColor
        var tagNames = event.categories.map { $0.name }
        for tag in tagNames {
            tagsContainer.addTagView(TagView(tagName: tag)) { [weak self] TagView in
                if let strongSelf = self {
                    // TO DO: add tag to user's preferences
                }
            }
        }
        tagsContainer.frame.size.height = tagsContainer.contentSize.height - 45
        
        //TABLE
        table.frame = CGRect(x: 0, y: tagsContainer.frame.maxY+margin, width: view.frame.width, height: 44)
        containerView.addSubview(table)
        table.scrollEnabled = false
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = lightGrey
        
        //SHARE BUTTON
        shareButton.frame = CGRect(x: margin, y: table.frame.maxY+margin, width: maxWidth, height: 44)
        containerView.addSubview(shareButton)
        shareButton.backgroundColor = medBlue
        shareButton.layer.cornerRadius = cornerRadius
        shareButton.setTitle("Share", forState: UIControlState.Normal)
        shareButton.addTarget(self, action: "openShare", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    //CONFIGURE TABLE
    var tableCellContent = ["Artist Information"]
    var selectedIndex = NSNotFound
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
        }
        cell?.backgroundColor = lightGrey
        cell?.textLabel?.text = "\(tableCellContent[indexPath.row])"
        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell?.selectionStyle = .None
        return cell!
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var detailVC = DetailViewController()
        if indexPath.row == 0 {
            detailVC.textViewText = "artist information"
        }
        showViewController(detailVC, sender: indexPath)
    }
    
    
    
    //WEBVIEW
    func openWeb() {
        if let url = NSURL(string: event.ticketURL) {
            var webVC = WebViewController()
            webVC.hidesBottomBarWhenPushed = true
            webVC.request = NSURLRequest(URL: url)
            showViewController(webVC, sender: nil)
        }
    }
    
    
    //SHARE
    func openShare() {
        let textToShare = "\(event.title) on HearHere: \(event.ticketURL)"
        if let myWebsite = NSURL(string: event.ticketURL) {
            let objectsToShare = [textToShare, myWebsite]
            let shareVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(shareVC, animated: true, completion: nil)
        }
    }
    
    
    //CONFIGURE SCROLLVIEW
    func addScrollView() {
        self.view.addSubview(scrollView)
        scrollView.backgroundColor = lightGrey
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize = CGSize(width: containerView.bounds.width, height: containerView.bounds.height + margin)
    }
    
    //CONFIGURE CONTAINER VIEW
    func addContainerView() {
        scrollView.addSubview(containerView)
        containerView.backgroundColor = lightBlue
        scrollView.layoutIfNeeded()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
}