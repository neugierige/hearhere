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
    //    var popoverController = HomeTabPopoverViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataManager.retrieveAllEvents { events in
            self.eventsArray = events
            if let theTableView = self.tableView {
                theTableView.dataSource = self
                theTableView.reloadData()
            }
        }
        
        var segTitles = ["Feed", "Distance", "Going"]
        var control = UISegmentedControl(items: segTitles)
        control.frame = CGRectMake(0, tableY, view.bounds.width, 30)
        control.addTarget(self, action: "segmentedControlAction:", forControlEvents: .ValueChanged)
        control.selectedSegmentIndex = 0
        control.tintColor = Configuration.lightGreyUIColor
        view.addSubview(control)
        //        if let filterImg = UIImage(named: "filter") {
        //            var filterButton = UIButton(frame: CGRectMake(0, 0, 22, 22))
        //            filterButton.setBackgroundImage(filterImg, forState: .Normal)
        //            filterButton.addTarget(self, action: "filterPressed:", forControlEvents: .TouchUpInside)
        //            filterButton.showsTouchWhenHighlighted = true
        ////            var navB = UIBarButtonItem(title: "filter", style: UIBarButtonItemStyle.Plain, target: self, action: "filterPressed:")
        ////            var navButton = UIBarButtonItem(customView: filterButton)
        //            navigationController?.navigationBar.addSubview(filterButton)
        ////            navigationController?.navigationItem.leftBarButtonItem = navB
        //        }
        
        tableView = UITableView(frame: CGRect(x: 0, y: control.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - control.frame.maxY - 49.0), style: UITableViewStyle.Plain)
        
        if let theTableView = tableView {
            theTableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
            theTableView.dataSource = nil
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            theTableView.rowHeight = self.rowHeight
            theTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            view.addSubview(theTableView)
        }
        
    }
    func segmentedControlAction(sender: UISegmentedControl) {
        var user = User(id: "")
        DataManager.getCurrentUserModel() { currentUser in
            if let currentUser = currentUser {
                user = currentUser
                println(user.location)
            } else {
                self.signInAlert() { currentUser in
                    if let currentUser = currentUser {
                        user = currentUser
                        var u = Data.currentUser
                        println(u)
                    }
                }
            }
        }
//        while user?.location == nil { }
//        switch sender.selectedSegmentIndex {
//        case 0:
//            DataManager.sortUserEventsByTag { events in
//                if let events = events {
//                    self.eventsArray = events
//                    self.tableView?.reloadData()
//                } else {
//                    // add tags in user preferences to get suggestions
//                }
//            }
//        case 1:
//            DataManager.sortEventsByDistance(user!.location, events: self.eventsArray) { events in
//                if let events = events {
//                    self.eventsArray = events
//                    self.tableView?.reloadData()
//                }
//            }
//        case 2:
//            println("c")
//        default:
//            println("d")
//        }
    }
    func signInAlert(completion: User? -> Void) {
        let alertController = UIAlertController(title: "Login", message: "to continue", preferredStyle: .Alert)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField
            var u = User(username: loginTextField.text, password: passwordTextField.text)
            
            func signInUser(completion: (User -> Void)!) {
                DataManager.signInUser(u) { success in
//                    dispatch_async(dispatch_get_main_queue()) {
                        completion(u)
//                    }
                }
            }
            
            signInUser() { user in
                completion(user)
            }

        }
        loginAction.enabled = false
        
        let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .Destructive) { (_) in }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Login"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                loginAction.enabled = textField.text != ""
            }
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        }
        
        alertController.addAction(loginAction)
        alertController.addAction(forgotPasswordAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    //    func filterPressed(sender: UIButton) {
    //        popoverController = HomeTabPopoverViewController()
    //        popoverController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    //        popoverController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
    //        popoverController.filterDelegate = self
    //        presentViewController(popoverController, animated: true, completion: nil)
    //    }
    //    func filterTypeChosen(type: TagView) {
    //        println("you")
    //    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as UITableViewCell
        
        let event = eventsArray[indexPath.row]
        let cellColors = chooseColors(indexPath.row)
        
        // Create background image
        let backgroundView = UIImageView()
        backgroundView.contentMode = .ScaleToFill
        backgroundView.image = event.photo
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
        
        cell.textLabel?.text = "\(event.title)"
        cell.textLabel?.textColor = cellColors.txtColor
        
        if event.dateTime != nil {
            var date = formatDateTime(event.dateTime)
            cell.detailTextLabel?.text = "\(date)\n\(event.venue[0])"
        }
        cell.detailTextLabel?.textColor = cellColors.txtColor
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        navigationController?.showViewController(EventDetailViewController(), sender: indexPath)
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
    
    
}
