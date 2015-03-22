//
//  SignInAlertView.swift
//  HearHereApp
//
//  Created by Matthew Korporaal on 3/20/15.
//  Copyright (c) 2015 LXing. All rights reserved.
//

import Foundation
import UIKit

func signInAlert(completion: User? -> Void) {
    let alertController = UIAlertController(title: "Login", message: "to continue", preferredStyle: .Alert)
    let loginAction = UIAlertAction(title: "Login", style: .Default) { (_) in
        let loginTextField = alertController.textFields![0] as UITextField
        let passwordTextField = alertController.textFields![1] as UITextField
        var u = User(username: loginTextField.text, password: passwordTextField.text)
        
        func signInUser(completion: (User -> Void)!) {
            DataManager.signInUser(u) { success in
                //                    dispatch_async(dispatch_get_main_queue()) {
                completion(u)
                //                    }
            }
        }
        
        signInUser() { user in
            completion(user)
        }
        
    }
    loginAction.enabled = false
    
    let forgotPasswordAction = UIAlertAction(title: "Forgot Password", style: .Destructive) { (_) in }
    let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (_) in }
    
    alertController.addTextFieldWithConfigurationHandler { (textField) in
        textField.placeholder = "Login"
        
        NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
            loginAction.enabled = textField.text != ""
        }
    }
    
    alertController.addTextFieldWithConfigurationHandler { (textField) in
        textField.placeholder = "Password"
        textField.secureTextEntry = true
    }
    
    alertController.addAction(loginAction)
    alertController.addAction(forgotPasswordAction)
    alertController.addAction(cancelAction)
}