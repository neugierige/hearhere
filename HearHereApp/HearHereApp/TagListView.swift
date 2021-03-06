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
        static var extraY:CGFloat = 10
    }
    class var marginX:CGFloat {
        get { return Attributes.marginX }
        set { Attributes.marginX = newValue }
    }
    class var marginY:CGFloat {
        get { return Attributes.marginY }
        set { Attributes.marginY = newValue }
    }
    class var extraY:CGFloat {
        get { return Attributes.extraY }
        set { Attributes.extraY = newValue }
    }
    
    // Shared array to manage tagViews
    private var tagViewArray = [TagView]()
    private var tagsPerRowArray = [Int]()
    private var leftoverPerTagArray = [CGFloat]()
    private var numRows = 0
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        backgroundColor = Configuration.lightGreyUIColor
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
//        setTagFrameAndDisplay()
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
    func getAllTagViews() -> [TagView] {
        return tagViewArray
    }
    var isSingleton = false
    private func rearrange() {
        
        // Container coordinates
        var maxX: CGFloat = Attributes.marginX, maxY: CGFloat = Attributes.marginY
        // Tag coordinates
        var tvW: CGFloat = 0.0, tvH: CGFloat = 0.0
        var partialRow = false
        
        // Centering variables
        var tagsPerRowCount = 0
        leftoverPerTagArray.removeAll(keepCapacity: false)
        tagsPerRowArray.removeAll(keepCapacity: false)
        numRows = 0
        
        // Sort tags by name
        tagViewArray.sort { $0.name.uppercaseString < $1.name.uppercaseString }
        // Iterate through tags and find coordinates in container space
        for (index, tagView) in enumerate(tagViewArray) {
            // tag dimensions
            tvW = tagView.frame.size.width
            tvH = tagView.frame.size.height
            
            // If a new tag cannot fit in the view, go to a new line and reset maxX
            if (tvW + maxX) > (frame.size.width - Attributes.marginX * 2) {
                tagsPerRowArray.append(tagsPerRowCount)
                if tagsPerRowCount == 1 { tagsPerRowCount++ }
                leftoverPerTagArray.append((frame.size.width-maxX-2*Attributes.marginX) / CGFloat(tagsPerRowCount))
                tagsPerRowCount = 1
                
                maxX = tvW + Attributes.marginX
                maxY += tvH + Attributes.marginY
                
                partialRow = tagViewArray.count == index+1 ? true : false
                numRows++
                
            // otherwise increase maxX to last tag on line
            } else {
                maxX += tvW + Attributes.marginX
                tagsPerRowCount++
                partialRow = true
            }
            
            // set tag frame, redraw and add to the container
            tagView.frame = CGRectMake(maxX-tvW, maxY, tvW, tvH)
        }
        // Increase contentSize if necessary
        contentSize = CGSize(width: frame.size.width, height: maxY+tvH+Attributes.extraY)

        if partialRow {
            tagsPerRowArray.append(tagsPerRowCount)
            if tagsPerRowCount == 1 { tagsPerRowCount++ }
            leftoverPerTagArray.append((frame.size.width-maxX-2*Attributes.marginX) / (CGFloat(tagsPerRowCount)) )
            numRows++
        }
        centerFrameAndDisplay()
    }
    
    func centerFrameAndDisplay() {
        var tagNumSum = 0
        subviews.map { $0.removeFromSuperview() }
        for row in 0..<numRows {
            for index in 0..<tagsPerRowArray[row] {
                tagViewArray[tagNumSum].frame.origin.x = tagViewArray[tagNumSum].frame.origin.x + leftoverPerTagArray[row]
                tagViewArray[tagNumSum].setNeedsDisplay()
                addSubview(tagViewArray[tagNumSum++])
            }
        }
        
    }
    /**
    
    
    :param: tag
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












