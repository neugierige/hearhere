//
//  TagView.swift
//
//  Created by Matthew Korporaal on 3/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

class TagView: UIView, UIGestureRecognizerDelegate {


    // MARK: Customizable tag attributes
    private struct Attributes {
        static var textPadding  = CGPointMake(20, 10)
        static var borderWidth  = 0.5 as CGFloat
        static var cornerRadius = 18 as CGFloat
        static var fontSize     = 15 as CGFloat
        static var fontName     = "STHeitiSC-Light"
        static var color1       = UIColor.whiteColor()
        static var color2       = UIColor(red:0.4, green:0.5, blue:0.62, alpha:1)
    }
    class var textPadding: CGPoint {
        get { return Attributes.textPadding }
        set { Attributes.textPadding = newValue }
    }
    class var borderWidth: CGFloat {
        get { return Attributes.borderWidth }
        set { Attributes.borderWidth = newValue }
    }
    class var cornerRadius: CGFloat {
        get { return Attributes.cornerRadius }
        set { Attributes.cornerRadius = newValue }
    }
    class var fontSize: CGFloat {
        get { return Attributes.fontSize }
        set { Attributes.fontSize = newValue }
    }
    class var fontName: String {
        get { return Attributes.fontName }
        set { Attributes.fontName = newValue }
    }
    class var color1: UIColor {
        get { return Attributes.color1 }
        set { Attributes.color1 = newValue }
    }
    class var color2: UIColor {
        get { return Attributes.color2 }
        set { Attributes.color2 = newValue }
    }
    
    // MARK: Tag title attributes
    var font: UIFont!
    var name: String!
    var attrOrigin: CGPoint!
    var attrName: NSMutableAttributedString!
    var attrColor: UIColor!
    
    // MARK: Tapped callback handler
    var tagViewTapped: ((TagView) -> ())?
    
    // MARK: Initialize
    convenience init(tagName: String) {
        self.init()
        name = tagName
        setupView()
    }
    override init() {
        super.init()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func drawRect(rect: CGRect) {
        // Draw Tag
        attrName.drawAtPoint(CGPointMake(attrOrigin.x, attrOrigin.y))
        
        // Add tap gesture and target
        let tagTap = UITapGestureRecognizer(target: self, action: "tagTapped:")
        tagTap.delegate = self
        addGestureRecognizer(tagTap)
    }
    
    /**
    Called during initialization to set frame, text, and other attributes
    */
    private func setupView() {
        attrColor = Attributes.color2
        backgroundColor = Attributes.color1
        // Setup attributed text
        attrName       = NSMutableAttributedString(string: name)
        let textLength = attrName.length
        let attrRange  = NSRange(location: 0, length: textLength)
        if let f = UIFont(name: Attributes.fontName, size: Attributes.fontSize) {
            font = f
        } else {
            font = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
        }
        attrName.addAttribute(NSFontAttributeName, value: font, range: attrRange)
        attrName.addAttribute(NSForegroundColorAttributeName, value: Attributes.color2, range: attrRange)
        
        // Setup tag dimensions
        attrOrigin   = CGPointMake(Attributes.textPadding.x, Attributes.textPadding.y)
        let textSize = attrName.size()
        let origin   = CGPointZero
        let width    = textSize.width + Attributes.textPadding.x * 2
        let height   = textSize.height + Attributes.textPadding.y * 2
        let size     = CGSize(width: width, height: height)
        frame        = CGRect(origin: origin, size: size)
        layer.cornerRadius  = Attributes.cornerRadius
        layer.borderWidth   = Attributes.borderWidth
        layer.borderColor   = Attributes.color2.CGColor
        layer.masksToBounds = true
        
    }
    
    /**
    Tap gesture selector, loads closure with self to be executed elsewhere
    
    :param: recognizer
    */
    internal final func tagTapped(recognizer: UITapGestureRecognizer) {
        // Post touch notification
        tagViewTapped?(self)
    }
    
    /**
    Toggle colors and tag title, then redraw
    
    :param: tagName String
    
    :returns: brand new toggled tagView
    */
    internal final func toggleTag(tagName: String) -> TagView {
        
        // Switch colors
        Attributes.color1 = attrColor!
        Attributes.color2 = backgroundColor!
        
        // Split name and add 'X' if needed
        let (root, postfix) = splitTagName(tagName)
        if postfix == "  ╳" { name = root }
        else { name = tagName + "  ╳" }
        
            // Draw
        setupView()
        setNeedsDisplay()
        return self
    }
    
    /**
    Splits tagName in two and returns the carnage
    
    :param: tagName String
    
    :returns: Tuple String values of the root and postfix
        which will either be a whole tag name and ' X' or split tag name
    */
    internal final func splitTagName(tagName: String) -> (String, String) {
        let index = advance(tagName.endIndex, -3)
        return(tagName.substringToIndex(index), tagName.substringFromIndex(index))
    }

    
}
