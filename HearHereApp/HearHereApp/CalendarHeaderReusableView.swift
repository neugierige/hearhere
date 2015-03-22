//
//  CalendarHeaderReusableView.swift
//  UICollectionViewPractice
//
//  Created by Prima Prasertrat on 3/19/15.
//  Copyright (c) 2015 GA. All rights reserved.
//

import UIKit

class CalendarHeaderReusableView: UICollectionReusableView {
    let monthLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // med blue
        backgroundColor = Configuration.lightBlueUIColor.colorWithAlphaComponent(1.0)
        
        monthLabel.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        monthLabel.textColor = Configuration.medBlueUIColor.colorWithAlphaComponent(1.0)
        monthLabel.font = UIFont(name: "HelveticaNeue-Medium", size: 14.0)
        monthLabel.textAlignment = .Center
        self.addSubview(monthLabel)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
