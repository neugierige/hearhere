//
//  DetailViewController.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/13/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var textView = UITextView()
    var scrollView = UIScrollView()
    var margin: CGFloat = 10.0
    
    //***** INFO TO LOAD FROM PARSE
    var textViewText: String?
    
    override func viewDidLoad() {
        self.view.backgroundColor = Configuration.lightGreyUIColor
        if let navBarHeight = navigationController?.navigationBar.frame.height {
            textView.frame = CGRect(x: margin/2, y: navBarHeight+margin/2, width: view.frame.width-2*margin, height: view.frame.height)
        }
        tabBarController?.tabBar.hidden = true
        hidesBottomBarWhenPushed = true
        textView.editable = false
        textView.text = textViewText
        view.addSubview(textView)
        
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.bounds.height)
        view.addSubview(scrollView)
    }
    
}
