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
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        styleCell()
    }
    
    func styleCell() {
        //light grey
        self.backgroundColor = UIColor(red: 0.937, green: 0.937, blue: 0.937, alpha: 1.0)
        
        self.textLabel?.textColor = UIColor.darkGrayColor()
        self.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        self.textLabel?.numberOfLines = 2
        
        self.detailTextLabel?.textColor = UIColor.darkGrayColor()
        self.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        self.detailTextLabel?.numberOfLines = 1
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //Size and position labels
        let labelWidth = self.frame.width * 0.76
        let labelX = self.frame.width / 5 + 10
        
        self.textLabel?.frame.size.width = labelWidth
        self.textLabel?.frame.origin = CGPoint(x: labelX, y: 5)
        
        self.detailTextLabel?.frame.size.width = labelWidth
        self.detailTextLabel?.frame.origin = CGPoint(x: labelX, y: self.frame.height - 20)
        
        let border = UIView(frame: CGRect(x: self.frame.width / 5, y: 2.0, width: 2.0, height: 76.0))
        border.backgroundColor = UIColor.orangeColor()
        self.contentView.addSubview(border)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
