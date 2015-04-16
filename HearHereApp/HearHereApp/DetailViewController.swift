//
//  DetailViewController.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/13/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let table = UITableView()
    let cellIdentifier: String?
    let edvc = EventDetailViewController()
    var event: Event!
    
    var textView = UITextView()
    var scrollView = UIScrollView()
    var margin: CGFloat = 10.0
    
    //***** INFO TO LOAD FROM PARSE
    var textViewText: String?
    
    override func viewDidLoad() {
        //self.event = edvc.event
        
        self.view.backgroundColor = Configuration.lightGreyUIColor
        
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            //textView.frame = CGRect(x: margin/2, y: navBarHeight/2, width: view.frame.width-2*margin, height: view.frame.height)
            table.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }
        tabBarController?.tabBar.hidden = true
        hidesBottomBarWhenPushed = true
        textView.editable = false
        textView.text = textViewText
        //view.addSubview(textView)
        
        //scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.bounds.height)
        //view.addSubview(scrollView)
        
        table.delegate = self
        table.dataSource = self
        table.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        view.addSubview(table)
    }
    
    
    //DATA SOURCE
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layer.borderWidth = 0.0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 11.0)
        cell.textLabel?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200)
        cell.textLabel?.text = event.artistDetail
        return cell
    }
    
    //DELEGATE
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as UITableViewHeaderFooterView
        header.contentView.backgroundColor = Configuration.lightBlueUIColor
        header.textLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        header.textLabel.text = "Artist Information"
    }
    
}
