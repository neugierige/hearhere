//
//  CalendarTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarTab: UIViewController, UICollectionViewDelegateFlowLayout, ScrollCalendarDelegate {
    
    var tableView: UITableView?
    let rowHeight:CGFloat = 60.0
    
    var eventsArray = [Event]()
    
    var tableDataSource: CalendarTableDataSource?
    var collectionDataSource: CalendarCollectionDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tableY:CGFloat = 125.5
        
        DataManager.retrieveAllEvents { events in
            self.eventsArray = events
            
            self.tableDataSource = CalendarTableDataSource(eventsArray: self.eventsArray, cellIdentifier: "calendarCell", navController: self.navigationController!, cellBlock: {
                (cell, item) -> () in
                if let actualCell = cell as? CalendarTableViewCell {
                    if let actualItem: AnyObject = item {
                        actualCell.configureCellData(actualItem)
                    }
                }
            })
            
            if let theTableView = self.tableView {
                theTableView.dataSource = self.tableDataSource
                theTableView.delegate = self.tableDataSource
                theTableView.reloadData()
            }
            
        }
        
        // ******************  UITableView ********************* //
        
        tableView = UITableView(frame: CGRect(x: 0, y: tableY, width: self.view.frame.width, height: self.view.frame.height - tableY - 49.0), style: UITableViewStyle.Plain)
        
        if let theTableView = tableView {
            
            theTableView.registerClass(CalendarTableViewCell.self, forCellReuseIdentifier: "calendarCell")
            theTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "calendarHeader")
            
            theTableView.dataSource = self.tableDataSource
            theTableView.delegate = self.tableDataSource
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            theTableView.rowHeight = self.rowHeight
            view.addSubview(theTableView)
        }
        
        
        // ******************  UICollectionView ********************* //
        
        let calUnit:CGFloat = 67.5
        
        var flowLayout:UICollectionViewFlowLayout = StickyHeaderFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: calUnit, height: calUnit)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSize(width: calUnit, height: calUnit)
        
        var collectionView:UICollectionView? = UICollectionView(frame: CGRectMake(0, tableY - calUnit, self.view.frame.width, calUnit), collectionViewLayout: flowLayout)
        collectionView?.backgroundColor = Configuration.darkBlueUIColor
        collectionView?.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "calendarCollectionCell")
        collectionView?.registerClass(CalendarHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "calendarCollectionHeader")
        
        self.collectionDataSource = CalendarCollectionDataSource(numDays: 180, cellIdentifier: "calendarCollectionCell", cellBlock: { (cell, item) -> () in
            if let actualCell = cell as? CalendarCollectionViewCell {
                if let actualItem: AnyObject = item {
                    actualCell.configureCellData(actualItem)
                }
            }
        })
        
        collectionView?.dataSource = self.collectionDataSource
        collectionView?.delegate = self.collectionDataSource
        
        self.collectionDataSource?.delegate = self
        self.view.addSubview(collectionView!)
        
    }
    
    func updateList(dt: NSDate) {
        DataManager.retrieveEventsForDate(dt) { events in
            self.eventsArray = events
            self.tableDataSource?.loadEvents(self.eventsArray)
            self.tableView?.reloadData()
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
