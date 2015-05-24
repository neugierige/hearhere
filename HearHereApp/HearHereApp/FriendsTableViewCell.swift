//
//  FriendsTableViewCell.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/14/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
protocol FriendsTableViewCellProtocol {
    func followButtonPressed(button: UIButton)
}
class FriendsTableViewCell: UITableViewCell {
    var username = UILabel()
    var email = UILabel()
    var followButton = UIButton()
    var delegate: FriendsTableViewCellProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        username = UILabel(frame: CGRectMake(10, 8, 200, 20))
        username.font = UIFont.systemFontOfSize(20)//UIFont(name: "HelvelticaUltraNeue-Light", size: 20)
        username.textColor = Configuration.darkBlueUIColor
    
        email = UILabel(frame: CGRectMake(10, 42, 200, 20))
        email.font = UIFont.systemFontOfSize(20)//UIFont(name: "HelvelticaUltraNeue-Light", size: 20)
        email.textColor = Configuration.darkBlueUIColor
        
        followButton = UIButton(frame: CGRectMake(self.bounds.width-90, 20, 80, 30))
        followButton.titleLabel?.font = UIFont.systemFontOfSize(15)
        followButton.backgroundColor = Configuration.lightGreyUIColor
        followButton.setTitleColor(Configuration.darkBlueUIColor, forState: .Normal)
        followButton.layer.borderColor = Configuration.darkBlueUIColor.CGColor
        followButton.layer.borderWidth = 0.5
        followButton.layer.cornerRadius = 12
        followButton.addTarget(self, action: "followButtonPressed:", forControlEvents: .TouchUpInside)
//        username.setTranslatesAutoresizingMaskIntoConstraints(false)
//        email.setTranslatesAutoresizingMaskIntoConstraints(false)
//        followButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        contentView.frame = CGRectMake(0, 0, self.bounds.width, 70)
        contentView.backgroundColor = Configuration.lightBlueUIColor
        contentView.addSubview(username)
        contentView.addSubview(email)
        contentView.addSubview(followButton)
        
        username.autoresizingMask = .FlexibleBottomMargin | .FlexibleRightMargin
        email.autoresizingMask = .FlexibleBottomMargin | .FlexibleRightMargin
        followButton.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin
    }
//    override init() {
//       super.init()
//    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        var bindingsDict = ["username": username, "email": email, "follow": followButton]
        
//        addConstraints([
//            NSLayoutConstraint.constraintsWithVisualFormat("V:|-[username(20)]-(>=8)-[email(20)]-|", options: nil, metrics: nil, views: bindingsDict),
//            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=8)-[follow(30)]-(>=8)-|", options: nil, metrics: nil, views: bindingsDict),
//            NSLayoutConstraint.constraintsWithVisualFormat("|-[username(>=50)]-(>=20)-[follow(50)]-|", options: nil, metrics: nil, views: bindingsDict),
//            NSLayoutConstraint.constraintsWithVisualFormat("|-[email(>=50)]-(>=20)-[follow(50)]-|", options: nil, metrics: nil, views: bindingsDict)
//        ])
        
    }
    
    func followButtonPressed(button: UIButton) {
        if followButton.titleLabel?.text == "Follow" {
            followButton.setTitle("Unfollow", forState: .Normal)
        } else {
            followButton.setTitle("Follow", forState: .Normal)
        }
        setNeedsLayout()
        delegate!.followButtonPressed(button)
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
