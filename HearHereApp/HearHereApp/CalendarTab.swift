//
//  CalendarTab.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/4/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarTab: UIViewController, ScrollCalendarDelegate {
    
    var tableView: UITableView?
    var collectionView: UICollectionView?
    
    let rowHeight:CGFloat = 60.0
    let tableY:CGFloat = 125.5
    let calUnit:CGFloat = 67.5
    
    var eventsArray = [Event]()
    
    var tableDataSource: CalendarTableDataSource?
    var collectionDataSource: CalendarCollectionDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        // ******************  UICollectionView ********************* //
        
        var flowLayout:UICollectionViewFlowLayout = StickyHeaderFlowLayout()
        
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize(width: calUnit, height: calUnit)
        flowLayout.scrollDirection = .Horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.headerReferenceSize = CGSize(width: calUnit, height: calUnit)
        
        var navBarHeight = navigationController?.navigationBar.frame.maxY ?? self.view.frame.minY
        
        collectionView = UICollectionView(frame: CGRectMake(0, navBarHeight, self.view.frame.width, calUnit), collectionViewLayout: flowLayout)
        
        
        
        // ******************  UITableView ********************* //
        
        var tableMinY = navBarHeight + calUnit
        tableView = UITableView(frame: CGRect(x: 0, y: tableMinY, width: self.view.frame.width, height: self.view.frame.height - tableY - 49.0), style: UITableViewStyle.Plain)
        
        if let theTableView = tableView {
            
            theTableView.registerClass(CalendarTableViewCell.self, forCellReuseIdentifier: "calendarCell")
            theTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "calendarHeader")
            
            theTableView.dataSource = self.tableDataSource
            theTableView.delegate = self.tableDataSource
            theTableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
            theTableView.rowHeight = self.rowHeight
            view.addSubview(theTableView)
        }
        
        

        self.collectionDataSource = CalendarCollectionDataSource(numDays: 180, cellIdentifier: "calendarCollectionCell", cellBlock: { (cell, item) -> () in
            if let actualCell = cell as? CalendarCollectionViewCell {
                if let actualItem: AnyObject = item {
                    actualCell.configureCellData(actualItem)
                }
            }
        })
        
        // delegate to pass collectionview data back to tableview
        self.collectionDataSource?.delegate = self
        
        if let theCollectionView = collectionView {
            theCollectionView.registerClass(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: "calendarCollectionCell")
            theCollectionView.registerClass(CalendarHeaderReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "calendarCollectionHeader")
            
            theCollectionView.backgroundColor = Configuration.darkBlueUIColor
            theCollectionView.dataSource = self.collectionDataSource
            theCollectionView.delegate = self.collectionDataSource
            view.addSubview(theCollectionView)
        }
        
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
