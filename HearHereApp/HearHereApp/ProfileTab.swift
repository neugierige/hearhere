//
//  ProfileTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class ProfileTab: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    var tableView: UITableView?
    let rowHeight:CGFloat = 44.0
    let tableY:CGFloat = 64.0
    //var sectionNames = ["Preferences", "Account Information", "Feedback"]
    var sectionNames = ["What are you into?", "Location", "Account Information", "Feedback"]
    //var profileData = [["Update Preferences"], ["Username", "Email Address", "Update Password"], ["Contact Us"]]
    var profileData = [["Update Preferences"], ["Zip Code"], ["Username", "Email Address", "Update Password"], ["Contact Us"]]
    var userData: User!
    var tfs = [UITextField]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var barItem = UIBarButtonItem(image: UIImage(named: "checkmark"), style: UIBarButtonItemStyle.Done, target: self, action: "savePreferences:")
        navigationItem.setRightBarButtonItem(barItem, animated: true)
        navigationItem.rightBarButtonItem?.enabled = false
        
        signInUserIfNecessary()
        
        tableView = UITableView(frame: CGRect(x: 0, y: tableY, width: self.view.frame.width, height: self.view.frame.height - tableY - 49.0), style: UITableViewStyle.Grouped)
        
        if let theTableView = tableView {
            theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
            theTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "profileHeader")
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            view.addSubview(theTableView)
        }
        
//        var tapRecognizer = UITapGestureRecognizer(target: self, action: "viewTapped:")
//        tapRecognizer.delegate = self
//        view.addGestureRecognizer(tapRecognizer)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.selectionStyle = .None
        
        let s = self.profileData[indexPath.section][indexPath.row] as String
        cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: 14.0)
        cell.textLabel?.text = s
        
        if cell.viewWithTag(1) == nil {
            let tf = UITextField(frame: CGRect(x: self.view.frame.width / 2 - 15, y: 0, width: self.view.frame.width / 2, height: self.rowHeight))
            tf.tag = 1
            tf.textColor = UIColor.lightGrayColor()
            tf.font = UIFont(name: "HelveticaNeue", size: 14.0)
            tf.textAlignment = .Right
            tf.delegate = self

            
            let accessory = UILabel(frame: CGRect(x: self.view.frame.width / 2 - 15, y: 0, width: self.view.frame.width / 2, height: self.rowHeight))
            accessory.tag = 2
            accessory.textColor = UIColor.lightGrayColor()
            accessory.font = UIFont(name: "HelveticaNeue", size: 14.0)
            accessory.textAlignment = .Right
            //accessory.text = ">"
            
            switch self.sectionNames[indexPath.section] {
            case "Preferences":
                cell.contentView.addSubview(accessory)
            case "Feedback":
                cell.contentView.addSubview(accessory)
            default:
                cell.contentView.addSubview(tf)
                tfs.append(tf)
            }
            
        }
    
        if UserRouter.sessionToken != nil {
            switch s {
            case "Zip Code":
                tfs[0].placeholder = "10001"
            case "Username":
                tfs[1].placeholder = LocalCache.currentUser.username
            case "Email Address":
                tfs[2].placeholder = LocalCache.currentUser.email
            case "Update Password":
                tfs[3].secureTextEntry = true
                tfs[3].placeholder = LocalCache.currentUser.password
            default:
                println("haha")
            }
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch self.profileData[indexPath.section][indexPath.row] {
        case "Update Preferences":
            performSegueWithIdentifier("ProfileShowTags", sender: self)
        case "Contact Us":
            let mailComposeViewController = EmailContactViewController()
            presentViewController(mailComposeViewController, animated: true, completion: nil)
        default:
            println("No segue")
        }
    }
    func savePreferences(sender: UIBarButtonItem) {
        if UserRouter.sessionToken != nil {
            navigationItem.rightBarButtonItem?.enabled = false
            if tfs[1].text != "" { userData.username = tfs[1].text }
            if tfs[2].text != "" { userData.email = tfs[2].text }
            if tfs[3].text != "" { userData.password = tfs[3].text }
            DataManager.saveUser(userData) { success, error in
                var alertMessage: String!
                if (success != nil) {
                    alertMessage = "Saved"
                    self.tfs.map { $0.text = "" }
                    self.tfs[1].placeholder = self.userData.username
                    self.tfs[2].placeholder = self.userData.email
                    self.tfs[3].placeholder = self.userData.password
                } else {
                    if let e = error {
                        alertMessage = e
                    }
                }
                var saveController = UIAlertController(title: "Preferences", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
                var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                saveController.addAction(okAction)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(saveController, animated: true) { _ in
                        self.textFieldDidEndEditing(self.tfs[0])
                    }
                }
            }
        } else {
            signInUserIfNecessary()
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ProfileShowTags" {
            var tvc = segue.destinationViewController as! TagsViewController
            tvc.appearedFromProfile = true
        }
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return UIInterfaceOrientation.Portrait.rawValue
    }
    
    func signInUserIfNecessary() {
        DataManager.getCurrentUserModel { currentUser in
            if let currentUser = currentUser {
                self.userData = currentUser
                dispatch_async(dispatch_get_main_queue()) {
                    if let tableView = self.tableView {
                        tableView.reloadData()
                    }
                }
            } else {
                
                self.signInAlert() { currentUser in
                    if let currentUser = currentUser {
                        self.userData = currentUser
                        dispatch_async(dispatch_get_main_queue()) {
                            if let tableView = self.tableView {
                                tableView.reloadData()
                            }
                        }
                    } else {
                        // unsuccessful print error to alert and try again
                    }
                }
            }
        }
    }

    func signInAlert(completion: User? -> Void) {
//        weak var weakSelf = self
        
        let alertController = UIAlertController(title: "Login", message: "to continue", preferredStyle: .Alert)
        let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
            let loginTextField = alertController.textFields![0] as! UITextField
            let passwordTextField = alertController.textFields![1] as! UITextField
            var u = User(username: loginTextField.text, password: passwordTextField.text)
            
            func signInUser(completion: (User -> Void)!) {
                DataManager.signInUser(u) { error, user in
                    if let user = user {
                        completion(user)
                    } else {
                        // TODO: all this code is brittle, redo
//                        dispatch_async(dispatch_get_main_queue()) {
//                        alertController.dismissViewControllerAnimated(true) { _ in self.signInUserIfNecessary()}
//                        }
//                        completion(nil)
                    }
                }
            }
            
            signInUser() { user in
                completion(user)
            }
        }
        loginAction.enabled = false
        
        let signUpAction = UIAlertAction(title: "Sign Up", style: .Destructive) { (_) in
//            var tagVC = TagsViewController()
//            self.view.window?.rootViewController?.navigationController?.pushViewController(tagVC, animated: true)
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

    override func viewWillAppear(animated: Bool) {
        // TODO: This cause warning "Presenting view controllers on detached view controllers is discouraged "
        // but will crash if not here and coming back from SignUpVC without signing up
//        signInUserIfNecessary()
        tableView?.reloadData()
    }
    
//    func viewTapped(sender: UITapGestureRecognizer) {
//        tfs.map { $0.resignFirstResponder() }
//    }
    func textFieldDidBeginEditing(textField: UITextField) {
        navigationItem.rightBarButtonItem?.enabled = true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        tfs.map { $0.resignFirstResponder() }
        return false
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        tfs.map { $0.resignFirstResponder() }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        var prefsChanged: Bool = false
        for tf in tfs {
            if tf.text != "" {
                prefsChanged = true
                break
            }
        }
        navigationItem.rightBarButtonItem?.enabled = prefsChanged

    }
//    override func viewWillDisappear(animated: Bool) {
//        NSNotificationCenter.defaultCenter().removeObserver()
//    }


}
