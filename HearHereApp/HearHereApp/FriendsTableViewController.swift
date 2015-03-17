//
//  FriendsTableViewController.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/13/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class FriendsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SearchViewProtocol, FriendsTableViewCellProtocol {
    
    private var tableView: UITableView!
    private var searchView: UIView!
    private let screenSize = UIScreen.mainScreen().bounds.size
    private var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Configuration.lightBlueUIColor
        
        // Search View Section
        searchView = makeSearchView()
        view.addSubview(searchView)
        
        tableView = UITableView(frame: CGRectMake(0, searchView.frame.maxY, screenSize.width, screenSize.height-searchView.frame.maxY))
        tableView.tableFooterView = UIView(frame: CGRectZero)
        tableView.backgroundColor = Configuration.lightBlueUIColor
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        tableView.separatorColor = Configuration.darkBlueUIColor
        view.addSubview(tableView)
        
    }

    // MARK: - Table view data source

    internal func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friends") as? FriendsTableViewCell ?? FriendsTableViewCell(style: .Default, reuseIdentifier: "friends")
    
        cell.username.text = users[indexPath.row].username
        cell.email.text = users[indexPath.row].email
        cell.followButton.setTitle("Follow", forState: .Normal)
        cell.followButton.tag = indexPath.row
        cell.delegate = self
        println("\(cell.username.text!) \(cell.email.text!)")
        return cell
    }

    private func makeSearchView() -> UIView {
        let origin = CGPointMake(0, topLayoutGuide.length)
        let size = CGSizeMake(screenSize.width, screenSize.height*0.125)
        let v = SearchView(frame: CGRect(origin: origin,size: size))
        v.searchField.placeholder = "Enter Username or Email."
        v.delegate = self
        return v
    }
    
    func searchViewDidInputText(uppercaseString: String) {
            // Uppercase text to search and search if more than one character in field
            if countElements(uppercaseString) > 1 {
                DataManager.retrieveUsersWithPredicate(uppercaseString) { users in
                    self.users = users
                    self.tableView.reloadData()
                }
            } else if countElements(uppercaseString) == 0 {

            }
    }
    
    func searchViewLeftButtonPressed(sender: UIButton) {
        
    }
    
    // MARK: SearchView delegate method keyboard behaviors
    
    func searchViewRightButtonPressed(sender: UIButton) {

    }
    
    func searchViewKeyboardWillShow(keyboardEndFrame: CGRect){}
    func searchViewKeyboardDidHide() {}
    
    func followButtonPressed(button: UIButton) {
        if let isFriends = DataManager.toggleFriend(users[button.tag]) {
            
        }
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
