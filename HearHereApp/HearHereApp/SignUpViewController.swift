//
//  SignUpViewController.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {

    // MARK: Views
    var spinner: UIActivityIndicatorView!
    var scrollView: UIScrollView!
    var signUpSuccessError: UILabel!
    var username: UITextField!
    var email: UITextField!
    var password: UITextField!
    var loginMessageFromSignUp: String?
    
    // MARK: Customizable properties.
    // MARK: NOTE globalize these?
    let paddingX:CGFloat     = 30
    let paddingY:CGFloat     = 10
    let cornerRadius:CGFloat = 5
    
    // MARK: VC methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Configuration.lightGreyUIColor
        
        loadUI()
        
        spinner.hidden = true
        spinner.hidesWhenStopped = true
        
        self.username.delegate = self
        self.email.delegate = self
        self.password.delegate = self
        
        self.addTapToDismissKeyboard()
    }
    
    /**
    load scroll view and its subviews
    */
    func loadUI() {
        let screenBounds = UIScreen.mainScreen().bounds
        if let nav = navigationController {
            nav.navigationBarHidden = true
        }
        // scrollView
        scrollView = UIScrollView(frame: CGRectMake(0, 0, screenBounds.width, screenBounds.height))
        scrollView.contentSize = CGSize(width: screenBounds.width, height: screenBounds.height + 500)
        scrollView.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin
        scrollView.scrollEnabled = false
        scrollView.userInteractionEnabled = true
        view.addSubview(scrollView)
        
        // Spinner
        spinner = UIActivityIndicatorView()//frame: CGRectMake(screenBounds.width/2, screenBounds.height/2, 50, 50))
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        spinner.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin
        scrollView.addSubview(spinner)
        
        let logoView = UIImageView(image: UIImage(named: "hear-hear-splash"))
        logoView.frame = CGRectMake(paddingX*2,topLayoutGuide.length+paddingY*3, screenBounds.width-paddingX*4, (screenBounds.width-paddingX*4)*0.77)
        logoView.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleWidth

        scrollView.addSubview(logoView)
        
        // sign in feedback label
        signUpSuccessError = UILabel(frame: CGRectMake(paddingX, logoView.frame.maxY, screenBounds.width-paddingX*2, 20))
        signUpSuccessError.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(signUpSuccessError)
        
        // Text fields
        username = UITextField(frame: CGRectMake(paddingX*2, signUpSuccessError.frame.maxY+paddingY, screenBounds.width-paddingX*4, 35))
        username.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        username.backgroundColor = UIColor.whiteColor()
        username.placeholder = "Username"
        username.textAlignment = NSTextAlignment.Center
        username.layer.cornerRadius = cornerRadius
        username.autocorrectionType = UITextAutocorrectionType.No
        username.autocapitalizationType = UITextAutocapitalizationType.None
        scrollView.addSubview(username)
        email = UITextField(frame: CGRectMake(paddingX*2, username.frame.maxY+paddingY, screenBounds.width-paddingX*4, 35))
        email.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        email.backgroundColor = UIColor.whiteColor()
        email.placeholder = "Email"
        email.textAlignment = NSTextAlignment.Center
        email.layer.cornerRadius = cornerRadius
        email.autocorrectionType = UITextAutocorrectionType.No
        email.autocapitalizationType = UITextAutocapitalizationType.None
        scrollView.addSubview(email)
        password = UITextField(frame: CGRectMake(paddingX*2, email.frame.maxY+paddingY, screenBounds.width-paddingX*4, 35))
        password.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        password.backgroundColor = UIColor.whiteColor()
        password.placeholder = "Password"
        password.secureTextEntry = true
        password.textAlignment = NSTextAlignment.Center
        password.layer.cornerRadius = cornerRadius
        password.autocorrectionType = UITextAutocorrectionType.No
        password.autocapitalizationType = UITextAutocapitalizationType.None
        scrollView.addSubview(password)
        
        // Sign up button
        var signUpButton = UIButton(frame: CGRectMake(paddingX*2, password.frame.maxY+paddingY, screenBounds.width-paddingX*4, 35))
        signUpButton.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        signUpButton.setTitle("Sign Up", forState: .Normal)
        signUpButton.setTitleColor(Configuration.lightGreyUIColor, forState: .Normal)
        signUpButton.layer.cornerRadius = cornerRadius
        signUpButton.backgroundColor = Configuration.darkBlueUIColor
        signUpButton.addTarget(self, action: "signUpPressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(signUpButton)
        
        // Sign In -> redirect
        var signInButton = UIButton(frame: CGRectMake(0, signUpButton.frame.maxY+paddingY, screenBounds.width, 30))
        signInButton.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        signInButton.addTarget(self, action: "signInTouched:", forControlEvents: .TouchUpInside)
        signInButton.setTitle("Already have an account? Log in here.", forState: .Normal)
        signInButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        scrollView.addSubview(signInButton)
        
        // Sign in now -> main app
        var signInNowButton = UIButton(frame: CGRectMake(paddingX, signInButton.frame.maxY+paddingY, screenBounds.width-paddingX*2, 30))
        signInNowButton.autoresizingMask = .FlexibleTopMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        signInNowButton.addTarget(self, action: "skipToAppTouched:", forControlEvents: .TouchUpInside)
        signInNowButton.titleLabel?.font = UIFont.systemFontOfSize(12)  //UIFont(name: "HelveticaNeue-Light", size: 12.0)
        signInNowButton.setTitle("Skip for now.", forState: .Normal)
        signInNowButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        scrollView.addSubview(signInNowButton)
        
    }
    
    // MARK: NOTE Sign up button. May want to omit this and make processSignUp the target.
    func signUpPressed(sender: UIButton) {
        processSignUp(sender)
        // Build the terms and conditions alert
//        let alertController = UIAlertController(title: "Agree to terms and conditions", message: "Click 'I Agree' to agree to the End User Licence Agreement.", preferredStyle: .Alert)
//        alertController.addAction(UIAlertAction(title: "I Agree", style: .Default, handler: { _ in self.processSignUp(sender)}))
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
//        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func processSignUp(sender: UIButton) {
        // If all fields are not blank
        if let username = username.text {
            if let email = email.text {
                if let password = password.text {
                    if username != "" && email != "" && password != "" {
                        if validateUsername() {
                            if validatePassword() {
                                self.spinner.hidden = false
                                self.spinner.startAnimating()
                                var user = User(username: username, email: email, password: password)
                                DataManager.signUpUser(user) { error in
                                    if let e = error {
                                        self.displaySuccessErrorLabel(e, valid: false)
                                        self.spinner.stopAnimating()
                                    } else {
                                        self.performSegueWithIdentifier("tags", sender: self)
                                    }
                                }
                            } else {
                                self.displaySuccessErrorLabel("Password must be at least 5 characters", valid: false)
                            }
                        } else {
                            self.displaySuccessErrorLabel("Username must be at least 5 characters", valid: false)
                        }
                    } else {
                        self.displaySuccessErrorLabel("All fields must be filled in.", valid: false)
                    }
                }
            }
        }
    }
    
    // MARK: Text Field Validation
    func validateUsername() -> Bool {
        var passwordRegex = "^.{5,40}$"
        if let match = username.text.rangeOfString(passwordRegex, options: .RegularExpressionSearch) {
            return true
        } else {
            return false
        }
    }
    func validatePassword() -> Bool {
//        var passwordRegex = "^(?=.*?[A-Z])(?=.*?[0-9]).{6,40}$"
        var passwordRegex = "^.{5,40}$"
        if let match = password.text.rangeOfString(passwordRegex, options: .RegularExpressionSearch) {
            return true
        } else {
            return false
        }
    }
    
    /**
    Error label info
    
    :param: text  String with error info
    :param: valid drives label color based on feedback
    */
    func displaySuccessErrorLabel(text: String, valid: Bool) {
        self.signUpSuccessError.text = text
        self.signUpSuccessError.textColor = valid ? UIColor.greenColor() : UIColor.redColor()
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { self.signUpSuccessError.alpha = 1.0 }, completion: { _ in UIView.animateWithDuration(5.0) { self.signUpSuccessError.alpha = 0.0 } })
    }
    
    // MARK: Button target methods for redirect
    func signInTouched(button: UIButton) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        self.performSegueWithIdentifier("signin", sender: self)
        
    }
    func skipToAppTouched(sender: UIButton) {
        self.performSegueWithIdentifier("main", sender: self)
    }
    
    // MARK: Keyboard behavior methods
    func addTapToDismissKeyboard() {
        var tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: "keyboardDismiss")
        tapToDismissKeyboard.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(tapToDismissKeyboard)
    }
    func keyboardDismiss() {
        self.touchesBegan(Set<NSObject>(), withEvent: UIEvent())
        self.textFieldDidEndEditing(username)
    }
    
    // Jump to next UITextField when Return is tapped
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.username {
            self.email.becomeFirstResponder()
        } else if textField == self.email {
            self.password.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // Hide keyboard when view is pressed
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.email.resignFirstResponder()
        self.username.resignFirstResponder()
        self.password.resignFirstResponder()
    }

    
    // Scroll up when keyboard appears, so text field is not obscured.
    func textFieldDidBeginEditing(textField: UITextField) {
        var scrollTo: CGPoint = CGPointMake(0, self.signUpSuccessError.frame.origin.y)
        UIView.animateWithDuration(0.5) {
            self.scrollView.setContentOffset(scrollTo, animated: true)
        }
    }
    
    // Scroll down when keyboard dismisses
    func textFieldDidEndEditing(textField: UITextField) {
        self.scrollView.setContentOffset(CGPointZero, animated: true)
    }
    
}
