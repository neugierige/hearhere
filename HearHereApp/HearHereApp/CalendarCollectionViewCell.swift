//
//  CalendarCollectionViewCell.swift
//  UICollectionViewPractice
//
//  Created by Prima Prasertrat on 3/19/15.
//  Copyright (c) 2015 GA. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    let dayLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        dayLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height / 2))
        dayLabel.backgroundColor = UIColor(red: 0.906, green: 0.298, blue: 0.235, alpha: 1.0)
        dayLabel.textColor = UIColor.whiteColor()
        dayLabel.font = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        dayLabel.textAlignment = .Center
        contentView.addSubview(dayLabel)
        
        dateLabel = UILabel(frame: CGRect(x: 0, y: frame.size.height / 2, width: frame.size.width, height: frame.size.height / 2))
        dateLabel.backgroundColor = UIColor.clearColor()
        dateLabel.textColor = UIColor.blackColor()
        dateLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        dateLabel.textAlignment = .Center
        contentView.addSubview(dateLabel)
        
        selectedBackgroundView = UIView(frame: bounds)
        selectedBackgroundView.backgroundColor = UIColor(red: 0.741, green: 0.831, blue: 0.871, alpha: 0.85)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
