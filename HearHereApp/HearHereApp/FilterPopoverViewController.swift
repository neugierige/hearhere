//
//  FilterPopoverViewController.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/16/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
protocol FilterPopoverViewControllerProtocol {
    func filterTypeChosen(type: TagView)
}
class FilterPopoverViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    var delegate: UIPopoverPresentationControllerDelegate!
    var filterDelegate: FilterPopoverViewControllerProtocol!
    var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUI()
        
        // Do any additional setup after loading the view.
    }
    
    func loadUI() {
        var startY = view.bounds.height*0.125+6
        containerView = UIView(frame: CGRectMake(6, startY, 120, 126))
        containerView.layer.cornerRadius = 5
        containerView.backgroundColor = UIColor.whiteColor()
        view.addSubview(containerView)
        
        TagView.color2 = Configuration.tagFontUIColor
        TagView.color1 = Configuration.tagUIColorA
        var artist = TagView(tagName: "Artist")
        var xOffset = (containerView.frame.width-artist.frame.width)/2
        artist.frame.origin = CGPointMake(xOffset, 6)
        addTagView(artist) { tagView in
            self.dismissViewControllerAnimated(true) {
                self.filterTags(tagView)
            }
        }
        containerView.addSubview(artist)
        
        TagView.color2 = Configuration.tagFontUIColor
        TagView.color1 = Configuration.tagUIColorB
        var category = TagView(tagName: "Category")
        xOffset = (containerView.frame.width-category.frame.width)/2
        category.frame.origin = CGPointMake(xOffset,46)
        addTagView(category) { tagView in
            self.dismissViewControllerAnimated(true) {
                self.filterTags(tagView)
            }
        }
        containerView.addSubview(category)
        
        TagView.color2 = Configuration.tagFontUIColor
        TagView.color1 = Configuration.tagUIColorC
        var venue = TagView(tagName: "Venue")
        xOffset = (containerView.frame.width-venue.frame.width)/2
        containerView.addSubview(venue)
        venue.frame.origin = CGPointMake(xOffset,86)
        addTagView(venue) { tagView in
            self.dismissViewControllerAnimated(true) {
                self.filterTags(tagView)
            }
        }
        venue.setNeedsDisplay()

    

    }

    func addTagView(tag: TagView , completion: ((TagView)->Void)?) {
        if let completion = completion {
            tag.tagViewTapped = { tagView in
                completion(tagView)
            }
        }
    }

    func filterTags(type: TagView) {
        filterDelegate!.filterTypeChosen(type)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.preferredContentSize = containerView.frame.size
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
