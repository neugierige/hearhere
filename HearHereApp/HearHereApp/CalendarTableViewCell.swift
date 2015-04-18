//
//  CalendarTableViewCell.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 3/13/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class CalendarTableViewCell: UITableViewCell {

    let dc = DateConverter()
    let rowHeight:CGFloat = 60.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        styleCell()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func styleCell() {
        
        self.backgroundColor = Configuration.lightGreyUIColor
        
        self.textLabel?.textColor = Configuration.medBlueUIColor
        self.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        self.textLabel?.numberOfLines = 2
        
        self.detailTextLabel?.textColor = Configuration.medBlueUIColor
        self.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14.0)
        self.detailTextLabel?.numberOfLines = 1
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let timeWidth = self.frame.width * 0.18
        let labelWidth = self.frame.width * 0.76
        let labelX = timeWidth + 10
        
        self.textLabel?.frame.size.width = labelWidth
        self.textLabel?.frame.origin = CGPoint(x: labelX, y: 5)
        
        self.detailTextLabel?.frame.size.width = labelWidth
        self.detailTextLabel?.frame.origin = CGPoint(x: labelX, y: self.frame.height - 20)
        
        let border = UIView(frame: CGRect(x: timeWidth, y: 4.0, width: 0.5, height: 54.0))
        border.backgroundColor = Configuration.medBlueUIColor
        
        self.contentView.addSubview(border)
    }
    
    func configureCellData(item: AnyObject) {
        
        let timeWidth = self.frame.width * 0.18
        
        if self.viewWithTag(1) == nil {
            let timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: timeWidth, height: self.rowHeight))
            timeLabel.tag = 1
            timeLabel.textColor = Configuration.medBlueUIColor
            timeLabel.font = UIFont(name: "HelveticaNeue-Light", size: 13.0)
            timeLabel.textAlignment = .Center
            self.contentView.addSubview(timeLabel)
        }
        
        let timeLabel = self.viewWithTag(1) as UILabel
        
        if let event = item as? Event {
            timeLabel.text = dc.formatTime(event.dateTime)
            self.textLabel?.text = event.title
            self.detailTextLabel?.text = event.venue[0].name
        }
    }
    
}
