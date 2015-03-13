//
//  CustomCell.swift
//  EventDetailVC
//
//  Created by Luyuan Xing on 3/7/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {
    

    @IBOutlet var labelLeft: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var labelRight: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    //        var textContent = UITextView()
    //        textContent.frame.origin = CGPoint.zeroPoint
    //        textContent.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
    //        textContent.sizeToFit()
    //        self.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
    //        self.textLabel?.textAlignment = NSTextAlignment.Left
    //        self.addSubview(textContent)
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
