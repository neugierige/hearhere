//
//  CalendarCollectionViewCell.swift
//  UICollectionViewPractice
//
//  Created by Prima Prasertrat on 3/19/15.
//  Copyright (c) 2015 GA. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    
    let dc = DateConverter()
    let dayLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = Configuration.lightGreyUIColor
        
        dayLabel = UILabel(frame: CGRect(x: 0, y: 5, width: frame.size.width, height: frame.size.height / 2))
        dayLabel.backgroundColor = UIColor.clearColor()
        dayLabel.textColor = Configuration.medBlueUIColor
        dayLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        dayLabel.textAlignment = .Center
        contentView.addSubview(dayLabel)
        
        dateLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height / 2 - 5, width: frame.size.width, height: frame.size.height / 2))
        dateLabel.backgroundColor = UIColor.clearColor()
        dateLabel.textColor = Configuration.medBlueUIColor
        dateLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 20.0)
        dateLabel.textAlignment = .Center
        contentView.addSubview(dateLabel)
        
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView.backgroundColor = Configuration.lightBlueUIColor
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellData(item: AnyObject) {
        if let dt = item as? NSDate {
            dayLabel.text = dc.getCalendarString(dt, type: "dayofweek", abbv: true)
            dateLabel.text = dc.getCalendarString(dt, type: "date", abbv: false)
        }
    }
}
