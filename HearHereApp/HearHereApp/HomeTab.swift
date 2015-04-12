//
//  ViewController.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import MapKit

var anonymousUser = User(id: "")

class HomeTab: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    var tableView: UITableView?
    let rowHeight:CGFloat = 192.0
    let tablePadding:CGFloat = 5.0
    let paddingX: CGFloat = 10.0
    let dc = DateConverter()
    var eventsArray = [Event]()
    var spinner: UIActivityIndicatorView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        var navBottom = navigationController?.navigationBar.frame.maxY
        var segContainer = UIView(frame: CGRectMake(0, navBottom!, view.bounds.width, 41))
        view.addSubview(segContainer)
        
        var segTitles = ["Feed", "Distance", "Going"]
        var control = UISegmentedControl(items: segTitles)
        control.frame = CGRectMake(paddingX, 8, view.bounds.width-paddingX*2, 25)
        control.addTarget(self, action: "segmentedControlAction:", forControlEvents: .ValueChanged)
        control.selectedSegmentIndex = 0
        control.tintColor = Configuration.orangeUIColor
        //segContainer.addSubview(control)
        
        if let navMaxY = navigationController?.navigationBar.frame.maxY {
            if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
                tableView = UITableView(frame: CGRect(x: tablePadding, y: navMaxY, width: self.view.frame.width - tablePadding * 2, height: self.view.frame.height - navMaxY - tabBarHeight), style: UITableViewStyle.Plain)
            }
        }
        
        if let theTableView = tableView {
            theTableView.registerClass(HomeTableViewCell.self, forCellReuseIdentifier: "homeCell")
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            theTableView.rowHeight = self.rowHeight
            theTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            view.addSubview(theTableView)
        }
        
        spinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        spinner.center.x = view.center.x
        spinner.center.y = segContainer.center.y
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        tableView?.addSubview(spinner)
        
        
    }
    
    func loadData() {
        if LocalCache.events.count == 0 {
            DataManager.retrieveAllEvents { events in
                self.eventsArray = events
                if let theTableView = self.tableView {
                    theTableView.dataSource = self
                    theTableView.reloadData()
                }
            }
        } else {
            self.eventsArray = LocalCache.events
            if let tableView = self.tableView {
                tableView.dataSource = self
                tableView.reloadData()
            }
            
        }
        if let location = getUserLocation() {
            DataManager.updateUserToEventDistances(location, events: eventsArray, completion: nil)
        }
    }
    
    func getUserLocation() -> CLLocation? {
        if DataManager.userLoggedIn() {
            return(LocalCache.currentUser.location)
        } else {
            return(anonymousUser.location)
        }
    }
    
    func segmentedControlAction(sender: UISegmentedControl) {
        var l: CLLocation!
        l = getUserLocation()
            switch sender.selectedSegmentIndex {
            case 0:
                if DataManager.userLoggedIn() {
                    DataManager.sortUserEventsByTag { events in
                        if let events = events {
                            self.eventsArray = events
                            self.tableView?.reloadData()
                        } else {
                            // add tags in user preferences to get suggestions
                        }
                    }
                } else {
                    // give option for signInAlert to login
                }
            case 1:
                DataManager.sortEventsByDistance(l, events: LocalCache.events) { events in
                    if let events = events {
                        self.eventsArray = events
                        self.tableView?.reloadData()
                    }
                }
            case 2:
                if DataManager.userLoggedIn() {
                    // return everything they are going to, or popular
                }
            default:
                println("figaro")
            }
        
    }
    
    // TODO: Put this in its own class and call for this and profile tab
    func signInAlert(completion: User? -> Void) {
        let alertController = UIAlertController(title: "Login", message: "to continue", preferredStyle: .Alert)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField
            var u = User(username: loginTextField.text, password: passwordTextField.text)
            
            func signInUser(completion: (User -> Void)!) {
                DataManager.signInUser(u) { success, user in
                    if let user = user {
                        completion(user)
                    }
                }
            }
            
            signInUser() { user in
                completion(user)
            }
            
        }
        loginAction.enabled = false
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .Destructive) { (_) in
            self.performSegueWithIdentifier("signup", sender: self)
        }
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
        alertController.addAction(signUpAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("homeCell", forIndexPath: indexPath) as UITableViewCell
        
        let event = eventsArray[indexPath.row]
        
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        cell.backgroundView = backgroundView
        
        let backgroundPhoto = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 140))
        backgroundPhoto.contentMode = .ScaleToFill
        backgroundPhoto.image = event.photo
        
        let textBackground = UIView(frame: CGRect(x: 0, y: 140, width: self.view.frame.width, height: 47))
        let bottomBorder = UIView(frame: CGRect(x: 0, y: self.rowHeight - tablePadding, width: self.view.frame.width, height: tablePadding))
        
        textBackground.backgroundColor = Configuration.medBlueUIColor
        bottomBorder.backgroundColor = UIColor.whiteColor()
        
        if let background = cell.backgroundView {
            background.addSubview(backgroundPhoto)
            background.addSubview(textBackground)
            background.addSubview(bottomBorder)
        }
        
        // Populate text labels
        cell.backgroundColor = UIColor.orangeColor()
        cell.textLabel?.text = "\(event.title)"
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        if event.dateTime != nil {
            var day = dc.getCalendarString(event.dateTime, type: "dayofweek", abbv: true)
            var date = dc.formatDate(event.dateTime, type: "short")
            var time = dc.formatTime(event.dateTime)

            cell.detailTextLabel?.text = "\(day), \(date), \(time) | \(event.venue[0])"
        }
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        // Distance
//        let distanceLabel = UILabel(frame: CGRectMake(0, 0, 50, 15))
//        distanceLabel.text = String(format: "%.1f mi", event.distance ?? "-")
//        distanceLabel.font = UIFont.systemFontOfSize(12)
//        distanceLabel.textColor = UIColor.whiteColor()
//        distanceLabel.autoresizingMask = .FlexibleRightMargin | .FlexibleBottomMargin
//        cell.accessoryView = distanceLabel
        spinner.stopAnimating()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var evdc = EventDetailViewController()
        evdc.event = eventsArray[indexPath.row]
        navigationController?.showViewController(evdc, sender: indexPath)
    }
    
    override func viewWillAppear(animated: Bool) {
        loadData()
        //println(self.eventsArray)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if DataManager.userLoggedIn() {
            DataManager.saveUserLocation(locations[0] as CLLocation)
        } else {
            anonymousUser.location = locations[0] as CLLocation
        }
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
