//
//  TagsViewController.swift
//
//
//  Created by Matthew Korporaal on 3/6/15.
//
//

import UIKit
import Parse
class TagsViewController: UIViewController, SearchViewProtocol, FilterPopoverViewControllerProtocol {
    
    // MARK: Tag Properties
    private var tagNames = [String]()
    private var tagNameAndColor = [String:UIColor]()
    var firstToggle = true
    
    var leftPopoverVC: FilterPopoverViewController!
    
    let tagColors  = ["Artist":Configuration.tagUIColorA, "Category":Configuration.tagUIColorB, "Venue":Configuration.tagUIColorC]
    
    enum Tag {
        
        case Artist
        case Category
        case Venue
        case All
        
        var title: String {
            switch(self) {
            case .Artist:   return "Artist"
            case .Category: return "Category"
            case .Venue:    return "Venue"
            case .All:      return "All"
            }
        }
        
        var color: UIColor {
            switch(self) {
            case .Artist:   return Configuration.tagUIColorA
            case .Category: return Configuration.tagUIColorB
            case .Venue:    return Configuration.tagUIColorC
            case .All:      return Configuration.tagFontUIColor
            }
        }
    }
    
    // MARK: View properties
    private var setupMode: Bool?
    private var searchField: UITextField!
    private var searchView: UIView!
    private var tagPoolListView: TagListView!, tagPickListView: TagListView!
    var appearedFromProfile: Bool!
    
    // MARK: Customizable View properties
    // Proportional height ratios of the three views. MUST ADD UP TO 1.0!
    var searchViewHeightRatio: CGFloat  = 0.125
    var tagPoolListHeightRatio: CGFloat = 0.755
    var tagPickListHeightRatio: CGFloat = 0.12
    
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
        
        // Tag Choices Scroll View Section
        tagPickListView = makePickListView()
        view.addSubview(tagPickListView)
        
        // All Tag Scroll View Section
        tagPoolListView = makePoolListView()
        view.addSubview(tagPoolListView)
        
//        // Tag Choices Scroll View Section
//        tagPickListView = makePickListView()
//        view.addSubview(tagPickListView)

        // Get data (names) and create tags, set colors
        TagView.color2 = Configuration.tagFontUIColor
        //        DataManager.retrieveAllArtists { artists in
        //            self.setupMode = true
        //            if let artists = artists {
        //                artists.map { self.loadTags($0.name, tagType: "Artist") }; return
        //            }
        //        }
        //        DataManager.retrieveAllVenues { venues in
        //            if let venues = venues {
        //                venues.map { self.loadTags($0.name, tagType: "Venue") }; return
        //            }
        //        }
        loadCategories()
    }
    
    func loadCategories() {
        DataManager.retrieveAllCategories { categories in
            self.setupMode = true
            if let categories = categories {
                categories.map { self.loadTags($0.name, tagType: "Category") }
                self.toggleUserTags()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.setupMode = false
        self.toggleUserTags()
        if (self.appearedFromProfile != nil) {
            animatePickView()
        }
    }
    
    // MARK: Create View Methods
    
    private func makeSearchView() -> UIView {
        let origin = CGPointMake(0, topLayoutGuide.length)
        let size = CGSizeMake(screenSize.width, screenSize.height*searchViewHeightRatio)
        let v = SearchView(frame: CGRect(origin: origin,size: size))
        v.rightButton.setBackgroundImage(UIImage(named: "checkmark"), forState: .Normal)
        v.delegate = self
        return v
    }
    
    private func makePoolListView() -> TagListView {
        // MARK NOTE: Added a poor man's border between the sections (+0.5).  May want to change later.
//        let origin = CGPointMake(0, searchView.frame.maxY + 0.5)
        let origin = CGPointMake(0, tagPickListView.frame.maxY + 0.5)
        let size = CGSizeMake(screenSize.width, screenSize.height * 0.875) // tagPoolListHeightRatio)
        let v = TagListView(frame: CGRect(origin: origin,size: size))
        return v
    }
    
    private func makePickListView() -> TagListView {
        let origin = CGPointMake(0, searchView.frame.maxY + 0.5)
//        let origin = CGPointMake(0, tagPoolListView.frame.maxY + 0.5)
        let size = CGSizeMake(screenSize.width, 0) // screenSize.height * tagPickListHeightRatio)
        let v = TagListView(frame: CGRect(origin: origin,size: size))
        return v
    }
    
    // MARK: Tag Creation methods
    
    /**
    Add each tag object from database to the local list, and create
    
    :param: objects Parse class object
    :param: color tag UIColor
    */
    private func loadTags(tagName: String, tagType: String) {
        TagView.color1 = tagColors[tagType]!
        // Create a new tag and append title string to local array
        self.createTag(tagName)
        if setupMode! {
            tagNames.append(tagName)
            tagNameAndColor[tagName] = TagView.color1
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
                if strongSelf.firstToggle {
                    strongSelf.animatePickView()
                    strongSelf.firstToggle = false
                }
                let bottomOffset = CGPointMake(0, strongSelf.tagPickListView.contentSize.height - strongSelf.tagPickListView.bounds.size.height)
                strongSelf.tagPickListView.setContentOffset(bottomOffset, animated: true)
            }
        }
        
    }
    
    func animatePickView() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tagPickListView.frame.size.height = self.screenSize.height * self.tagPickListHeightRatio
            self.tagPoolListView.frame.size.height = self.screenSize.height * self.tagPoolListHeightRatio
            self.tagPoolListView.frame.origin.y = self.tagPickListView.frame.maxY + 0.5
        })
        
    }
    func toggleUserTags() {
        var matchingCategories = [TagView]()
        DataManager.getCurrentUserModel() { [weak self] user in
            if let strongSelf = self {
                if let user = user {
                    if user.categories.count > 0 {
                        // matchingCategories = user.categories.filter { contains(strongSelf.tagNames, $0.name) }
                        for t in strongSelf.tagPoolListView.getAllTagViews() {
                            println(t.name)
                        }
                        for u in user.categories {
                            println("User")
                            println(u.name)
                        }
                        let tagViews = strongSelf.tagPoolListView.getAllTagViews()
                        for tag in tagViews {
                            for category in user.categories {
                                if category.name == tag.name {
                                    matchingCategories.append(tag)
                                }
                            }
                        }
                        for tag in matchingCategories {
                            strongSelf.tagPoolListView.toggleTag(tag)
                            strongSelf.tagPickListView.toggleTag(tag)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: SearchView delegate method implementations
    
    /**
    Search tags in Pool
    
    :param: uppercaseString text from search field capitalized
    */
    func searchViewDidInputText(uppercaseString: String) {
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
    
    func searchViewLeftButtonPressed(sender: UIButton) {
        leftPopoverVC = FilterPopoverViewController()
        leftPopoverVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        leftPopoverVC.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        leftPopoverVC.filterDelegate = self
        presentViewController(leftPopoverVC, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .OverCurrentContext
    }
    
    func filterTypeChosen(type: TagView) {
        tagPoolListView.removeAllTagViews()
        //        var mode = FilterMode.Artist
        //        mode.mode
        for (name, color) in tagNameAndColor {
            if color == tagColors[type.name] {
                loadTags(name, tagType: type.name)
            }
        }
    }
    
    // MARK: SearchView delegate method keyboard behaviors
    
    func searchViewRightButtonPressed(sender: UIButton) {
        var categories = [String]()
        var artists = [String]()
        var venues = [String]()
        // add objects with categories that match user picks and update user
        DataManager.getCurrentUserModel() { user in
            if let user = user {
                // add to user
                var currentPicks = self.tagPickListView.getAllTagNames()
                let emptyTag = TagView(tagName: "")
                var matchedPicks = [String]()
                currentPicks.map { matchedPicks.append(emptyTag.splitTagName($0).0) }
                self.tagNames.filter { contains(matchedPicks, $0) }.map { name -> Void in //////////////////
                    switch self.tagNameAndColor[name]! {
                    case Configuration.tagUIColorA:
                        artists.append(name)
                    case Configuration.tagUIColorB:
                        categories.append(name)
                    case Configuration.tagUIColorC:
                        venues.append(name)
                    default:
                        println("None")
                    }
                }
                //                DataManager.retrieveArtistsWithNames(artists) { artists in
                //                    if let artists = artists {
                //                        user.artists = artists
                //                    }
                DataManager.retrieveCategoriesWithNames(categories) { categories in
                    if let categories = categories {
                        user.categories = categories
                    } else {
                        user.categories.removeAll(keepCapacity: false)
                    }
                    //                        DataManager.retrieveVenuesWithNames(venues) { venues in
                    //                            if let venues = venues {
                    //                                user.venues = venues
                    //                            }
                    DataManager.saveUser(user) { success, error in
                        dispatch_async(dispatch_get_main_queue()) {
                            // self.presentViewController(FriendsTableViewController(), animated: true, completion: nil)
                            if (self.appearedFromProfile != nil) {
                                self.dismissViewControllerAnimated(true, completion: nil)
                            } else {
                                self.performSegueWithIdentifier("main", sender: self)
                            }
                        }
                    }
                    //                        }
                }
                //                }
                
                
            } else {
                println("error: no one logged in")
            }
        }
    }
    
    /**
    Add height to content view, so tags are not hidden.
    
    :param: keyBoardFrame keyboard frame
    */
    func searchViewKeyboardWillShow(keyboardFrame: CGRect) {
//        tagPickListView.frame.origin.y = keyboardFrame.origin.y-45
        tagPoolListView.contentSize.height += keyboardFrame.size.height
    }
    
    /**
    Remove height from scroll content view when keyboard hides
    */
    func searchViewKeyboardDidHide(keyboardFrame: CGRect) {
        tagPoolListView.contentSize.height -= keyboardFrame.size.height

//        tagPickListView.frame.origin.y = tagPoolListView.frame.maxY+0.5
    }
    
    
}
