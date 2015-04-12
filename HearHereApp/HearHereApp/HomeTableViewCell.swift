//
//  HomeTableViewCell.swift
//  HearHereApp
//
//  Created by Prima Prasertrat on 3/13/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        styleCell()
    }
    
    func styleCell() {
        self.textLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        self.textLabel?.numberOfLines = 1
        
        self.detailTextLabel?.font = UIFont(name: "HelveticaNeue-Medium", size: 12.0)
        self.detailTextLabel?.numberOfLines = 1
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel?.frame.origin.y = self.contentView.bounds.maxY - 45
        self.detailTextLabel?.frame.origin.y = self.contentView.bounds.maxY - 25
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
