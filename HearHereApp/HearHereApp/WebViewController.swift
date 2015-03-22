//
//  WebViewController.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/7/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {

    var webView = UIWebView()
    
    var request: NSURLRequest?
    
    override func viewDidLoad() {
        
        self.view.addSubview(webView)
        webView.frame = view.frame
        
        if let request = self.request {
            self.webView.loadRequest(request)
        }
        var arrow = UIImage(named: "next")
        var backImage = UIImage(CGImage: arrow?.CGImage , scale: 1.0, orientation: UIImageOrientation.LeftMirrored)
    
        navigationController?.navigationItem.backBarButtonItem?.setBackButtonBackgroundImage(backImage, forState: .Normal, barMetrics: UIBarMetrics.Default)
    }
    
}
