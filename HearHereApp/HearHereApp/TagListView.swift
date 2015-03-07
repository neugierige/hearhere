//
//  TagListView.swift
//
//  Created by Matthew Korporaal on 3/1/15.
//  Copyright (c) 2015 Matthew Korporaal. All rights reserved.
//

import UIKit

class TagListView: UIScrollView {
    
    // Customizable variables
    struct Attributes {
        static var marginX:CGFloat = 5
        static var marginY:CGFloat = 5
    }
    class var marginX:CGFloat {
        get { return Attributes.marginX }
        set { Attributes.marginX = newValue }
    }
    class var marginY:CGFloat {
        get { return Attributes.marginY }
        set { Attributes.marginY = newValue }
    }
    
    // Shared array to manage tagViews
    private var tagViewArray = [TagView]()
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = Configuration.backgroundUIColor
        contentSize = CGSize(width: CGRectGetWidth(UIScreen.mainScreen().bounds), height: 0)
    }
    override init() {
        super.init()
    }
    required init(coder aDecoder:NSCoder) {
        super.init(coder: aDecoder)
    }

    /**
    <#Description#>
    
    :param: tag        <#tag description#>
    :param: completion <#completion description#>
    */
    func addTagView(tag: TagView , completion: ((TagView)->Void)?) {
        tagViewArray.append(tag)
        rearrange()
        if let completion = completion {
            tag.tagViewTapped = { tagView in
                completion(tagView)
            }
        }
    }
   
    /**
    <#Description#>
    */
    func removeAllTagViews() {
        tagViewArray.removeAll(keepCapacity: false)
        rearrange()
    }
    
    /**
    <#Description#>
    
    :returns: <#return value description#>
    */
    func getAllTagNames() -> [String] {
        return tagViewArray.map { $0.name }
    }
    
    /**
    <#Description#>
    */
    private func rearrange() {
        // Remove all subviews
        subviews.map { $0.removeFromSuperview() }
        
        var maxX: CGFloat     = 0
        var maxY: CGFloat     = Attributes.marginY
        var tagViewSize       = CGSizeZero
        var tagViewOrigin     = CGPointZero
        
        // Enumerate tagViews and get maxY
        tagViewArray.sort { $0.name.uppercaseString < $1.name.uppercaseString }
        for tagView in tagViewArray {
            tagViewOrigin = tagView.frame.origin
            tagViewSize   = tagView.frame.size

            // Make a new line if tag doesn't fit
            if (tagViewSize.width + maxX) > (frame.size.width - Attributes.marginX * 2) {
                maxX = tagViewSize.width + Attributes.marginX
                maxY = maxY + tagViewSize.height + Attributes.marginY
            } else {
                maxX = maxX + tagViewSize.width + Attributes.marginX
            }
            tagView.frame = CGRectMake(maxX - tagViewSize.width, maxY, tagViewSize.width, tagViewSize.height)
            tagView.setNeedsDisplay()
            addSubview(tagView)
        }
        contentSize = CGSize(width: frame.size.width, height: maxY + tagViewSize.height + 50)
    }

    /**
    <#Description#>
    
    :param: tag <#tag description#>
    */
    func toggleTag(tag: TagView) {
        if contains(tagViewArray, tag) {
            tagViewArray = tagViewArray.filter { $0 != tag }
            rearrange()
        } else {
            let toggledTag = tag.toggleTag(tag.name)
            addTagView(toggledTag, completion: nil)
        }
    }
    
}












