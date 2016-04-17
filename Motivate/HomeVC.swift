//
//  HomeVC.swift
//  MotivationApp
//
//  Created by Jacqueline Kouri on 4/2/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1) {
            self.performSegueWithIdentifier("goto_login", sender: self)
        } else {
            self.usernameLabel.text = prefs.valueForKey("USERNAME") as! NSString as String
        }
    }
    
    /*override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }*/

    @IBAction func logoutTapped(sender: AnyObject) {
        self.performSegueWithIdentifier("goto_login", sender: self)
    }
}
