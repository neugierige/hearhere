//
//  CalendarTableViewCell.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 3/13/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Value2, reuseIdentifier: reuseIdentifier)
        styleCell()
    }
    
    func styleCell() {
        //light grey
        self.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
        
        //dark blue
        self.textLabel?.textColor = UIColor(red: 0.168, green: 0.227, blue: 0.258, alpha: 1.0)
        self.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        self.textLabel?.numberOfLines = 0
        
        self.detailTextLabel?.textColor = UIColor.darkGrayColor()
        self.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        self.detailTextLabel?.numberOfLines = 4
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let timeLabel = self.textLabel {
            timeLabel.textAlignment = NSTextAlignment.Center
            timeLabel.frame.origin.x = 0.0
        }
        
        if let eventLabel = self.detailTextLabel {
            eventLabel.frame.origin.x = 110.0
        }
        
        let border = UIView(frame: CGRect(x: 90.0, y: 2.0, width: 2.0, height: 76.0))
        border.backgroundColor = UIColor.orangeColor()
        self.contentView.addSubview(border)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
