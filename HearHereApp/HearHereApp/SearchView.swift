//
//  Search.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/6/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

protocol SearchViewProtocol {
    func searchViewKeyboardWillShow(keyboardEndFrame: CGRect)
    func searchViewKeyboardDidHide()
    func searchViewTextInput(uppercaseString: String)
    func searchViewSaveUserInfo()
}
class SearchView: UIView, UITextFieldDelegate {
    
    var searchField: UITextField!
    var delegate: SearchViewProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Configuration.backgroundUIColor
        loadUI()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadUI() {
        
        searchField = UITextField()
        searchField.backgroundColor = UIColor.whiteColor()
        searchField.layer.cornerRadius = 18
        searchField.placeholder = "Choose things that interest you."
        searchField.textAlignment = NSTextAlignment.Center
        searchField.autocorrectionType = UITextAutocorrectionType.No
        searchField.delegate = self
        searchField.setTranslatesAutoresizingMaskIntoConstraints(false)
        let searchImageView = UIImageView(image: UIImage(named: "search"))
        searchImageView.frame = CGRect(origin: CGPointMake(13, 9), size: CGSizeMake(18, 18))
        searchImageView.alpha = 0.5
        searchField.addSubview(searchImageView)
        addSubview(searchField)
        
        let filterButton = UIButton(frame: CGRectMake(0, 0, 22, 22))
        filterButton.setBackgroundImage(UIImage(named: "filter"), forState: .Normal)
        filterButton.addTarget(self, action: "filterButtonTouched:", forControlEvents: UIControlEvents.TouchUpInside)
        filterButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        addSubview(filterButton)
        
        var viewBindingsDict = NSMutableDictionary()
        viewBindingsDict.setValue(searchField, forKey: "searchField")
        viewBindingsDict.setValue(filterButton, forKey: "filterButton")
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=8)-[filterButton(22)]-10-|", options: nil, metrics: nil, views: viewBindingsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(>=8)-[searchField(35)]-4-|", options: nil, metrics: nil, views: viewBindingsDict))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[searchField(>=200)]-[filterButton(22)]-|", options: nil, metrics: nil, views: viewBindingsDict))
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "searching:", name: "UITextFieldTextDidChangeNotification", object: searchField)
        
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    /**
    <#Description#>
    
    :param: button <#button description#>
    */
    func filterButtonTouched(button: UIButton) {
        println("filter")
        // MARK: TODO figure out how to implement filter
        // MARK: TODO move this to its own target and button
        delegate!.searchViewSaveUserInfo()
        
    }
    
    /**
    Search tags in Pool
    
    :param: notification textField object
    */
    internal func searching(notification: NSNotification) {
        // Uppercase text to search and search if more than one character in field
        var text = (notification.object as UITextField).text.uppercaseString
        delegate!.searchViewTextInput(text)
    }
    
    // MARK: Keyboard behaviors
    
    /**
    Add height to content view, so tags are not hidden
    
    :param: notification keyboard notification from viewDidLoad
    */
    func keyboardWillShow(notification: NSNotification) {
        if let keyNotification = notification.userInfo {
            if let keyboardEndFrame = keyNotification["UIKeyboardFrameEndUserInfoKey"] as? NSValue {
                delegate!.searchViewKeyboardWillShow(keyboardEndFrame.CGRectValue())
            }
        }
    }

    /**
    Remove height from scroll content view when keyboard hides
    
    :param: notification hide notification set in viewDidLoad
    */
    func keyboardDidHide(notification: NSNotification) {
        delegate!.searchViewKeyboardDidHide()
    }
    
    /**
    UITextFieldDelegate method to hide keyboard when Return is pressed
    
    :param: textField sender
    
    :returns: Bool true to say this should happen
    */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /**
    Dismiss keyboard if view is touched
    
    :param: touches not used
    :param: event   not used
    */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        searchField.resignFirstResponder()
    }
    
}
