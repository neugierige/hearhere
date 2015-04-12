//
//  SignInViewController.swift
//  HearHereApp
//
//  Created by Luyuan Xing on 3/5/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import UIKit
import MapKit

class SignInViewController: UIViewController, UITextFieldDelegate {//, CLLocationManagerDelegate {
    
    // MARK: Views
    var spinner: UIActivityIndicatorView!
    var username: UITextField!
    var password: UITextField!
    var loginSuccessErrorLabel: UILabel!
    var scrollView: UIScrollView!
//    var locationManager = CLLocationManager()
    var user = User(id: "")
    // MARK: Customizable view properties
    let paddingX:CGFloat     = 30
    let paddingY:CGFloat     = 10
    let cornerRadius:CGFloat = 5
    
    // MARK: VC Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.loadCriticalData {
//            println("all loaded")
        }
        
        view.backgroundColor = Configuration.lightGreyUIColor

        loadUI()
        
        spinner.hidden = true
        spinner.hidesWhenStopped = true
        
        username.delegate = self
        password.delegate = self
        
        var tapToDismissKeyboard = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        tapToDismissKeyboard.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapToDismissKeyboard)
        
    }

    /**
    load UI elements
    */
    func loadUI() {
        let screenBounds = UIScreen.mainScreen().bounds

        // scrollview
        scrollView = UIScrollView(frame: CGRectMake(0, 0, screenBounds.width, screenBounds.height))
        scrollView.contentSize = CGSize(width: screenBounds.width, height: screenBounds.height + 500)
        scrollView.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin
        scrollView.scrollEnabled = false
        scrollView.userInteractionEnabled = true
        view.addSubview(scrollView)

        let logoView = UIImageView(image: UIImage(named: "hear-hear-splash"))
        logoView.frame = CGRectMake(paddingX*2,topLayoutGuide.length+paddingY*3, screenBounds.width-paddingX*4, (screenBounds.width-paddingX*4)*0.77)
        logoView.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleWidth
        
        scrollView.addSubview(logoView)
        
        // Error/Success label
        loginSuccessErrorLabel = UILabel(frame: CGRectMake(paddingX, logoView.frame.maxY, screenBounds.width-paddingX*2, 20))
        loginSuccessErrorLabel.textAlignment = NSTextAlignment.Center
        scrollView.addSubview(loginSuccessErrorLabel)
        
        // text fields
        username = UITextField(frame: CGRectMake(paddingX*2, loginSuccessErrorLabel.frame.maxY+paddingY, screenBounds.width-paddingX*4, 35))
        username.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        username.backgroundColor = UIColor.whiteColor()
        username.placeholder = "Username"
        username.textAlignment = NSTextAlignment.Center
        username.layer.cornerRadius = cornerRadius
        username.autocorrectionType = UITextAutocorrectionType.No
        username.autocapitalizationType = UITextAutocapitalizationType.None
        scrollView.addSubview(username)
        password = UITextField(frame: CGRectMake(paddingX*2, username.frame.maxY+paddingY, screenBounds.width-paddingX*4, 35))
        password.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        password.backgroundColor = UIColor.whiteColor()
        password.placeholder = "Password"
        password.secureTextEntry = true
        password.textAlignment = NSTextAlignment.Center
        password.layer.cornerRadius = cornerRadius
        password.autocorrectionType = UITextAutocorrectionType.No
        password.autocapitalizationType = UITextAutocapitalizationType.None
        scrollView.addSubview(password)
        
        // Buttons
        var signInButton = UIButton(frame: CGRectMake(paddingX*2, password.frame.maxY+paddingY, screenBounds.width-paddingX*4, 35))
        signInButton.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        signInButton.setTitle("Sign In", forState: .Normal)
        signInButton.setTitleColor(Configuration.lightGreyUIColor, forState: .Normal)
        signInButton.layer.cornerRadius = cornerRadius
        signInButton.backgroundColor = Configuration.darkBlueUIColor
        signInButton.addTarget(self, action: "signInPressed:", forControlEvents: .TouchUpInside)
        scrollView.addSubview(signInButton)
        
        var signUpButton = UIButton(frame: CGRectMake(0, signInButton.frame.maxY+paddingY, screenBounds.width, 30))
        signUpButton.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        signUpButton.addTarget(self, action: "signUpTouched:", forControlEvents: .TouchUpInside)
        signUpButton.setTitle("Don't have an account? Sign up here.", forState: .Normal)
        signUpButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        scrollView.addSubview(signUpButton)
        
        var signInNowButton = UIButton(frame: CGRectMake(paddingX, signUpButton.frame.maxY+paddingY, screenBounds.width-paddingX*2, 30))
        signInNowButton.autoresizingMask = .FlexibleTopMargin | .FlexibleLeftMargin | .FlexibleRightMargin
        signInNowButton.addTarget(self, action: "skipToAppTouched:", forControlEvents: .TouchUpInside)
        signInNowButton.setTitle("Skip for now.", forState: .Normal)
        signInNowButton.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
        scrollView.addSubview(signInNowButton)
        
        // spinner
        spinner = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        spinner.center = view.center
        spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        //        spinner.autoresizingMask = .FlexibleBottomMargin | .FlexibleLeftMargin | .FlexibleRightMargin | .FlexibleTopMargin
        scrollView.addSubview(spinner)
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.startUpdatingLocation()
    }
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        manager.stopUpdatingLocation()
//        var location = locations[0] as CLLocation
//        user.location = location
//    }
    
    // MARK: Button Target methods
    func skipToAppTouched(sender: UIButton) {
        self.performSegueWithIdentifier("main", sender: self)
    }
    
    func signUpTouched(sender: UIButton) {
        self.performSegueWithIdentifier("signup", sender: self)
    }

    // Sign in user and send to main app upon success, otherwise give feedback
    func signInPressed(sender: UIButton?) {
        spinner.hidden = false
        spinner.startAnimating()
        if username.text != "" && password.text != "" {
            var user = User(username: username.text, password: password.text)
            DataManager.signInUser(user) { error, _ in
                if let e = error {
                    self.spinner.stopAnimating()
                    self.displaySuccessErrorLabel(e, valid: false)
                } else {
                    self.performSegueWithIdentifier("main", sender: self)
                }
            }
        } else {
            self.displaySuccessErrorLabel("Fill both fields", valid: false)
        }
    }
    
    // Error label
    func displaySuccessErrorLabel(text: String, valid: Bool) {
        loginSuccessErrorLabel.text = text
        loginSuccessErrorLabel.textColor = valid ? UIColor.greenColor() : UIColor.redColor()
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { self.loginSuccessErrorLabel.alpha = 1.0 }, completion: { _ in UIView.animateWithDuration(5.0) { self.loginSuccessErrorLabel.alpha = 0.0 } })
    }
    
    // MARK: TextFieldDelegate methods and keyboard behavior
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == username {
            password.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            signInPressed(nil)
        }
        return true
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        username.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    func dismissKeyboard() {
        touchesBegan(NSSet(), withEvent: UIEvent())
        textFieldDidEndEditing(username)
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        var scrollTo: CGPoint = CGPointMake(0, loginSuccessErrorLabel.frame.origin.y)
        UIView.animateWithDuration(0.5) {
            self.scrollView.setContentOffset(scrollTo, animated: true)
        }
    }
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointZero, animated: true)
    }

}
