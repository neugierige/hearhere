//
//  ViewController.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

@IBDesignable
class EventDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let scrollView = UIScrollView()
    //let containerView = UIView()
    let table = UITableView()
    let margin: CGFloat = 10
    let cellReuseID = "cell"
    
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
        var eventName = UITextView(frame: CGRect(x: margin, y: image.frame.maxY+margin, width: maxWidth, height: titleTextHeight*2))
        eventName.editable = false
        eventName.font = UIFont(name: "HelveticaNeue-UltraLight", size: 20)
        containerView.addSubview(eventName)
        eventName.text = "New York Philharmonic & Warner Bros. Present Bugs Bunny at the Symphony"
        //eventName.sizeToFit()
        //eventName.layoutIfNeeded()
        eventName.backgroundColor = UIColor.clearColor()
        
        //DATE&TIME
        var dateTimeLabel = UILabel(frame: CGRect(x: margin, y: eventName.frame.maxY+margin, width: maxWidth*3/4, height: bodyTextHeight))
        containerView.addSubview(dateTimeLabel)
        dateTimeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        dateTimeLabel.text = "7:30PM Wednesday, September 30"
        dateTimeLabel.backgroundColor = eventName.backgroundColor
        
        //VENUE NAME
        var venueNameLabel = UILabel(frame: CGRect(x: margin, y: dateTimeLabel.frame.maxY, width: dateTimeLabel.frame.width, height: bodyTextHeight))
        containerView.addSubview(venueNameLabel)
        venueNameLabel.font = dateTimeLabel.font
        venueNameLabel.text = "Carnegie Hall, Isaac Stern Auditorium"
        venueNameLabel.backgroundColor = eventName.backgroundColor
        
        //TICKET BUTTON
        var ticketButton = UIButton(frame: CGRect(x: dateTimeLabel.frame.maxX, y: dateTimeLabel.frame.minY, width: maxWidth/4, height: bodyTextHeight*2))
        containerView.addSubview(ticketButton)
        ticketButton.layer.cornerRadius = 6
        var price = "$20-$55"
        ticketButton.setTitle("\(price)", forState: UIControlState.Normal)
        ticketButton.titleLabel?.font = UIFont.systemFontOfSize(12)
        ticketButton.addTarget(self, action: "openWeb", forControlEvents: UIControlEvents.TouchUpInside)
        ticketButton.backgroundColor = UIColor.blueColor()
        
        //PROGRAM INFO
        var programInfo = UITextView(frame: CGRect(x: margin, y: venueNameLabel.frame.maxY+margin, width: maxWidth, height: bodyTextHeight*5))
        containerView.addSubview(programInfo)
        programInfo.font = UIFont.systemFontOfSize(12)
        programInfo.editable = false
        programInfo.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"
        programInfo.sizeToFit()
        //programInfo.layoutIfNeeded()
        
        
        //TABLE
        table.frame = CGRect(x: 0, y: programInfo.frame.maxY+margin, width: view.frame.width, height: 2*44)
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
    
    
    func openShare() {
        let textToShare = "text to share"
        if let myWebsite = NSURL(string: "http://google.com/") {
            let objectsToShare = [textToShare, myWebsite]
            let shareVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.presentViewController(shareVC, animated: true, completion: nil)
        }
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
        cellInTable = tableView.dequeueReusableCellWithIdentifier(cellReuseID, forIndexPath: indexPath) as CustomCell
        cellInTable.labelLeft.text = "\(tableCellContent[indexPath.row])"
        cellInTable.textView.text = "lajsdlakjsdlakjsd asld asldkj laskdjl akjslkajsdl kjasld kjalsd kjlskj asdlkja sdlkja sdlkja sdlkajs dlkajlkjlkajsldkj laksdjlk jasdl kja ldskj lakjl kasdlkjas asdlkjasd aslkj sdklj lkjasdlkjasd dlkjalksd lkjasdlkj laskjd lkjasd lajsdlakjsdlakjsd asld asldkj laskdjl akjslkajsdl kjasld kjalsd kjlskj asdlkja sdlkja sdlkja sdlkajs dlkajlkjlkajsldkj laksdjlk jasdl kja ldskj lakjl kasdlkjas asdlkjasd aslkj sdklj lkjasdlkjasd dlkjalksd lkjasdlkj laskjd lkjasd"
        cellInTable.labelRight.font = UIFont.systemFontOfSize(18)
        cellInTable.labelRight.textColor = UIColor.blueColor()
        cellInTable.labelRight.text = "+"
        return cellInTable
    }
    
    //    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    //        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
    //        if cell == nil {
    //            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "Cell")
    //        }
    //        cell?.textLabel?.text = "\(tableCellContent[indexPath.row])"
    //        cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    //        return cell!
    //    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if selectedIndex == indexPath.row {
            self.view.layoutIfNeeded()
            return 128
        } else {
            scrollView.contentSize = CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
            return 44
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var arrayOfIndexPaths = [NSIndexPath]()
        if selectedIndex == indexPath.row {
            selectedIndex = NSNotFound
            arrayOfIndexPaths.append(indexPath)
            table.beginUpdates()
            table.reloadRowsAtIndexPaths(arrayOfIndexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
            table.endUpdates()
            //            UIView.animateWithDuration(0.3) {
            //                self.table.frame.size = self.table.contentSize
            //            }
            return
        }
        
        if selectedIndex != NSNotFound {
            var prevPath = NSIndexPath(forRow: selectedIndex, inSection: 0)
            selectedIndex = indexPath.row
            arrayOfIndexPaths.append(prevPath)
            table.beginUpdates()
            table.reloadRowsAtIndexPaths(arrayOfIndexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
            table.endUpdates()
            //            UIView.animateWithDuration(0.3) {
            //                self.table.frame.size = self.table.contentSize
            //            }
        }
        
        selectedIndex = indexPath.row
        arrayOfIndexPaths.append(indexPath)
        table.beginUpdates()
        table.reloadRowsAtIndexPaths(arrayOfIndexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        table.endUpdates()
        //        UIView.animateWithDuration(0.3) {
        //            self.table.frame.size = self.table.contentSize
        //        }
    }
    
    
    //WEBVIEW
    func openWeb() {
        if let url = NSURL(string: "http://google.com") {
            performSegueWithIdentifier("openTicketingWeb", sender: NSURLRequest(URL: url))
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let request = sender as? NSURLRequest {
            var destinationViewController = segue.destinationViewController as WebViewController
            destinationViewController.request = request
        }
    }
    
    
    //CONFIGURE SCROLLVIEW
    func addScrollView() {
        scrollView.backgroundColor = UIColor(red: 0.741, green: 0.831, blue: 0.871, alpha: 1.0)
        scrollView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.bounds.height)
        self.view.addSubview(scrollView)
    }
    
}

