//
//  SignUpVC.swift
//  MotivationApp
//
//  Created by Jacqueline Kouri on 4/2/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit


class SignUpVC: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtconfirmPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBAction func signupTapped(sender : UIButton) {
     
        
        let username = txtUsername.text!;
        let password = txtPassword.text!;
        let confirmedPassword = txtconfirmPassword.text!;
        
        if (username.isEmpty || password.isEmpty || confirmedPassword.isEmpty ) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Please enter Username and Password (all fields are required)"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else if (!password.isEqual(confirmedPassword) ) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign Up Failed!"
            alertView.message = "Passwords do not match!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            let myUrl = NSURL(string: "http://plato.cs.virginia.edu/~jmk3qc/Motivation/userRegister.php")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            
            let postString = "username=\(username)&password=\(password)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (let data, let response, let error) in
                
                if error != nil {
                    print("error=\(error)")
                    return
                }
                
                do {
                    
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as? NSDictionary
                    
                    if let parseJSON = json {
                        
                        let resultValue = parseJSON["status"] as! String!
                        
                        print("result: \(resultValue)")
                        
                        var isUserRegistered: Bool = false
                        
                        if (resultValue == "Success") {
                            
                            isUserRegistered = true
                            
                        }
                        
                        var messageToDisplay: String = parseJSON["message"] as! String!
                        
                        if (!isUserRegistered)
                            
                        {
                            
                            messageToDisplay = parseJSON["message"] as! String!
                            
                        }
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            
                            let myAlert = UIAlertController(title: "Alert", message: messageToDisplay, preferredStyle: UIAlertControllerStyle.Alert)
                            
                            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { action in
                                
                                self.dismissViewControllerAnimated(true, completion: nil)
                                
                            }
                            
                            myAlert.addAction(okAction)
                            
                            self.presentViewController(myAlert, animated: true, completion: nil)
                            
                            }
                            
                        )}
                    
                } catch { print(error)}
            }
        
            
            task.resume()
            
            /*
                } else {
                    var alertView:UIAlertView = UIAlertView()
                    alertView.title = "Sign Up Failed!"
                    alertView.message = "Connection Failed"
                    alertView.delegate = self
                    alertView.addButtonWithTitle("OK")
                    alertView.show()
                }
            }  else {
                var alertView:UIAlertView = UIAlertView()
                alertView.title = "Sign in Failed!"
                alertView.message = "Connection Failure"
                if let error = reponseError {
                    alertView.message = (error.localizedDescription)
                }
                alertView.delegate = self
                alertView.addButtonWithTitle("OK")
                alertView.show()
            } */
        }
    }
        
    
  
    @IBAction func gotoLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    
}
