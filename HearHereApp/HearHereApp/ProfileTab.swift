//
//  ProfileTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class ProfileTab: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: UITableView?
    let rowHeight:CGFloat = 44.0
    let tableY:CGFloat = 64.0
    var sectionNames = ["Preferences", "Location", "Account Information", "Feedback"]
    var profileData = [["Update Preferences"], ["Zip Code"], ["Email Address", "Update Password"], ["Contact Us"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: CGRect(x: 0, y: tableY, width: self.view.frame.width, height: self.view.frame.height - tableY - 49.0), style: UITableViewStyle.Grouped)
        
        if let theTableView = tableView {
            theTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
            theTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "profileHeader")
            theTableView.dataSource = self
            theTableView.delegate = self
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            view.addSubview(theTableView)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionNames.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("defaultCell", forIndexPath: indexPath) as UITableViewCell
        
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
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if sectionNames[indexPath.section] == "Preferences" {
            performSegueWithIdentifier("profileSegue", sender: self)
        } else {
            println("No segue")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
