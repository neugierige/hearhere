//
//  TagsViewController.swift
//
//
//  Created by Matthew Korporaal on 3/6/15.
//
//

import UIKit
import Parse

class TagsViewController: UIViewController, SearchViewProtocol {

    // MARK: Tag Properties
    private var tagNames = [String]()
    private var tagNameAndColor = [String: UIColor]()
    var categories = [PFObject](), artists = [PFObject](), venues = [PFObject]()
    var tagTypeArray = [[PFObject]]()
    let tagColors  = ["Artist":Configuration.tagUIColorA, "Category":Configuration.tagUIColorB, "Venue":Configuration.tagUIColorC]
    
    // MARK: View properties
    private var searchField: UITextField!
    private var searchView: UIView!
    private var tagPoolListView: TagListView!, tagPickListView: TagListView!
    
    // MARK: Customizable View properties
    // Proportional height ratios of the three views. MUST ADD UP TO 1.0!
    var searchViewHeightRatio: CGFloat  = 0.125
    var tagPoolListHeightRatio: CGFloat = 0.625
    var tagPickListHeightRatio: CGFloat = 0.25
    
    // MARK: App properties
    // App Info TODO: Should we add these to Config??
    private let notificationCenter = NSNotificationCenter.defaultCenter()
    private let mainQueue          = NSOperationQueue.mainQueue()
    private let screenSize         = UIScreen.mainScreen().bounds.size
    
    // MARK: VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()

        // Search View Section
        searchView = makeSearchView()
        view.addSubview(searchView)
        
        // All Tag Scroll View Section
        tagPoolListView = makePoolListView()
        view.addSubview(tagPoolListView)
        
        // Tag Choices Scroll View Section
        tagPickListView = makePickListView()
        view.addSubview(tagPickListView)
        
        // class names to query, and background colors, set font color
        let tagTypes   = ["Artist", "Category", "Venue"]
        tagTypeArray = [categories, artists, venues]
        TagView.color2 = Configuration.tagFontUIColor
        // Get class objects from database, load, and keep local copy
        map(enumerate(tagTypes)) { (i, type) in
            DataManager.getObjectsInBackground(type, keys: ["name"]) { (objects: [PFObject]?, error: String?) in
                if let objects = objects {
                    TagView.color1 = self.tagColors[tagTypes[i]]!
                    self.loadTags(objects)
                    self.tagTypeArray[i] = objects
                } else {
                    if let e = error {
                        println(e)
                    }
                }
            }
        }
    }
    
    // MARK: Create View Methods
    
    private func makeSearchView() -> UIView {
        let origin = CGPointMake(0, topLayoutGuide.length)
        let size = CGSizeMake(screenSize.width, screenSize.height*searchViewHeightRatio)
        let v = SearchView(frame: CGRect(origin: origin,size: size))
        v.delegate = self
        return v
    }
    
    private func makePoolListView() -> TagListView {
        // MARK NOTE: Added a poor man's border between the sections (+0.5).  May want to change later.
        let origin = CGPointMake(0, searchView.frame.maxY + 0.5)
        let size = CGSizeMake(screenSize.width, screenSize.height * tagPoolListHeightRatio)
        let v = TagListView(frame: CGRect(origin: origin,size: size))
        return v
    }
    
    private func makePickListView() -> TagListView {
        let origin = CGPointMake(0, tagPoolListView.frame.maxY + 0.5)
        let size = CGSizeMake(screenSize.width, screenSize.height * tagPickListHeightRatio)
        let v = TagListView(frame: CGRect(origin: origin,size: size))
        return v
    }
    
    // MARK: Tag Creation methods
    
    /**
    Add each tag object from database to the local list, and create
    
    :param: objects Parse class object
    :param: color tag UIColor
    */
    private func loadTags(objects: [PFObject]) {
        for object in objects as [PFObject] {
            if let tagTitle = object["name"] as? String {
                // Create a new tag and append title string to local array
                createTag(tagTitle)
                tagNames.append(tagTitle)
                tagNameAndColor[tagTitle] = TagView.color1
            }
        }
    }
    
    /**
    Create TagView, add it the TagListView, and add toggle handler
    
    :param: tag title String
    */
    private func createTag(tag: String) {
        tagPoolListView.addTagView(TagView(tagName: tag)) { [weak self] TagView in
            if let strongSelf = self {
                strongSelf.tagPoolListView.toggleTag(TagView)
                strongSelf.tagPickListView.toggleTag(TagView)
            }
        }
    }

    // MARK: SearchView delegate method implementations
    
    /**
    Search tags in Pool
    
    :param: uppercaseString text from search field capitalized
    */
    func searchViewTextInput(uppercaseString: String) {
        // Uppercase text to search and search if more than one character in field
        if countElements(uppercaseString) > 1 {
            var subset = tagNames.filter { $0.uppercaseString.rangeOfString(uppercaseString) != nil }
            // Remove tags from view and redraw with subset
            tagPoolListView.removeAllTagViews()
            subset.map { name -> Void in
                TagView.color1 = self.tagNameAndColor[name]!
                TagView.color2 = Configuration.tagFontUIColor
                self.createTag(name)
            }
        } else if countElements(uppercaseString) == 0 {
            // When textField empty, remove tags and redraw with all except the chosen ones
            tagPoolListView.removeAllTagViews()
            var currentPicks = tagPickListView.getAllTagNames()
            let emptyTag = TagView(tagName: "")
            var matchedPicks = [String]()
            currentPicks.map { matchedPicks.append(emptyTag.splitTagName($0).0) }
            tagNames.filter { !contains(matchedPicks, $0) }.map { name -> Void in
                TagView.color1 = self.tagNameAndColor[name]!
                TagView.color2 = Configuration.tagFontUIColor
                self.createTag(name)
            }
        }
    }
    
    //    /**
    //    <#Description#>
    //
    //    :param: button <#button description#>
    //    */
    //    func filterButtonTouched(button: UIButton) {
    //        println("filter")
    //    }
    
    // MARK: SearchView delegate method keyboard behaviors
    
    func searchViewSaveUserInfo() {
        var user = PFUser.currentUser()
        if user != nil {
            // matchedPicks = getPickName() - make function 
            // typeArray.filter { contains(matchedPicks, $0 }
            // add to user
            var currentPicks = tagPickListView.getAllTagNames()
            let emptyTag = TagView(tagName: "")
            var matchedPicks = [String]()
            currentPicks.map { matchedPicks.append(emptyTag.splitTagName($0).0) }
            
            var relation = user.relationForKey("artists")
            
//            relation.addObject(<#object: PFObject!#>)
        } else {
            println("error: no one logged in")
        }
    }
    /**
    Add height to content view, so tags are not hidden.
    
    :param: keyBoardFrame keyboard frame
    */
    func searchViewKeyboardWillShow(keyboardFrame: CGRect) {
        tagPickListView.frame.origin.y = keyboardFrame.origin.y - 45
    }
    
    /**
    Remove height from scroll content view when keyboard hides
    */
    func searchViewKeyboardDidHide() {
        tagPickListView.frame.origin.y = tagPoolListView.frame.maxY+0.5
    }
    
    
}
