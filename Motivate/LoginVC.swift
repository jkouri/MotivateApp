//
//  LoginVC.swift
//  MotivationApp
//
//  Created by Jacqueline Kouri on 4/2/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit


class LoginVC: UIViewController {
    @IBOutlet weak var txtPassword: UITextField!
   
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBAction func signinTapped(sender: AnyObject) {
        //Authentication code
        let username = txtUsername.text!
        let password = txtPassword.text!
        
    
        if (password.isEmpty || username.isEmpty) {
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign In Failed!"
            alertView.message = "Please enter username and password!"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()

        }
        
        let myUrl = NSURL(string: "http://plato.cs.virginia.edu/~jmk3qc/Motivation/userLogin.php")
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
                    
                    if (resultValue == "Success") {
                        
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isUserLoggedIn")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    
                    
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                }
                    
            
            } catch { print(error)}
        
        
        }
        task.resume()

    }

}
