//
//  AddGoalVC.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/4/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit
import CoreLocation

var goal = [GoalItem]()
var now = NSDate()
var  timer = NSTimer()

class AddGoalVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    //connect button add reminder
    
  //  @IBOutlet weak var scrollView: UIScrollView!
    //communictae with same datastroage of tableview controller
    
    let locationManager = CLLocationManager()

    
    //MARK:Properties
    
    @IBOutlet weak var duedate: UIDatePicker!
    @IBOutlet weak var goaldesc: UITextView!
    @IBOutlet weak var goalname: UITextField!
    @IBOutlet weak var goalLocation: UITextField!
    
    var currentGoal: String = ""
    var currentDesc: String = ""
    var currentDueDate: NSDate? = nil
    var currentLocation: CLPlacemark? = nil
    var curLocation: String = ""
   // var curAlert: UILocalNotification? = nil
    var curAlert: UIAlertController? = nil
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Handle the text field’s user input through delegate callbacks.
        goalname.delegate = self
        goalLocation.delegate = self
        goaldesc.delegate = self
    
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        self.goaldesc.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.goaldesc.delegate = self
        self.goaldesc.text = "Make your goal SMART! Specific, Measurable, Attainable, Realistic and Time-Oriented"
        self.goaldesc.textColor = UIColor.lightGrayColor()
        self.goaldesc.layer.borderWidth = 1.0
        
        if(self.currentGoal != "" || self.currentDueDate != nil) {
            self.goalname.text = self.currentGoal
            self.goaldesc.text = self.currentDesc
            self.duedate.setDate(self.currentDueDate!, animated: true)
            self.goalLocation.text = self.curLocation
            
        }
        else {
            duedate.minimumDate = NSDate()
            let timeInterval = floor(duedate.minimumDate!.timeIntervalSinceReferenceDate/60.0)*60.0
            duedate.minimumDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        }
        
      /*  let notification:UILocalNotification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = "Your goal, x, is due!"
        notification.fireDate = self.currentDueDate*/
        

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: { (placemarks,error) -> Void in
            
            if error != nil{
                print("Error: " + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0
            {
                self.currentLocation = placemarks![0] as CLPlacemark
            }
        })
    }
    
    @IBAction func useCurrentLocation(sender: AnyObject) {
        if let location = self.currentLocation{
             displayLocationInfo(location)
        }
       
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        self.locationManager.stopUpdatingLocation()
        self.curLocation = placemark.subThoroughfare! + " " + placemark.thoroughfare!
            + " " + placemark.locality! + ", "  + placemark.administrativeArea! + " " + placemark.postalCode!
        goalLocation.text = self.curLocation
       // print(placemark.name)
        //print(placemark.subLocality)
        //print(placemark.location)
    }
    
    func locaitonManager(manager: CLLocation!, didFailWithError error: NSError!){
        print("Error" + error.localizedDescription)
    }
    
    
    
    // MARK: UITextViewDelegate
    
    
    
    func textViewDidBeginEditing(textView: UITextView){
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = nil
            textView.textColor = UIColor.blackColor()
           // registerForKeyboardNotifications()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView){
        if textView.text.isEmpty {
            textView.text = "Make your goal SMART! Specific, Measurable, Attainable, Realistic and Time-Oriented"
            textView.textColor = UIColor.lightGrayColor()
           // deregisterFromKeyboardNotifications()
        }
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
    func dismissAlert(alert: UIAlertAction, x: String){
        self.dismissViewControllerAnimated(true, completion: nil)
        DataStorage.sharedInstance.removeGoalWithName(x)
        
        DataStorage.sharedInstance.storeGoalData()
        DataStorage.sharedInstance.reloadGoalData()
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
    
    }
    
    
    func postponeAlert(alert: UIAlertAction, alertController: UIAlertController, x: String){
        
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(24*3600.00 * Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
                UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
        if let goal = DataStorage.sharedInstance.getGoalWithName(x){
            goal.duedate = goal.duedate.dateByAddingTimeInterval(60*60*24)
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            DataStorage.sharedInstance.storeGoalData()
            DataStorage.sharedInstance.reloadGoalData()
        }
    }
    
    
    func delay(date: NSDate, name: String){
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(date.timeIntervalSinceDate(NSDate()))*Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
              //  print("FUTURE BLOCK EXECUTED")
                if let goal = DataStorage.sharedInstance.getGoalWithName(name) {
                    if goal.duedate.compare(date) == .OrderedSame{
                        let alertController = UIAlertController(title: "Due:", message: goal.goal, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Completed", style: .Cancel, handler: {
                            action in self.dismissAlert(action, x: goal.goal)
                        }))
                        alertController.addAction(UIAlertAction(title: "Postpone", style: .Default, handler: {
                            action in self.postponeAlert(action, alertController: alertController, x: goal.goal)
                        }))
                        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
                
            }
        })
    }

    //MARK: Actions
    @IBAction func addGoal(sender: AnyObject) {
        if let goal = DataStorage.sharedInstance.getGoalWithName(self.currentGoal){
            //print(goal.goal)
            if goal.duedate.compare(duedate.date) != .OrderedSame {
                goal.duedate = duedate.date
                delay(goal.duedate, name: goal.goal)
            }
            if let name = goalname.text{
                if goal.goal != name{
                    goal.goal = name
                    delay(goal.duedate, name:goal.goal)
                }
            }
            
            DataStorage.sharedInstance.storeGoalData()
            DataStorage.sharedInstance.reloadGoalData()
            
        }else{
        
              var d = duedate.date
        let timeInterval = floor(d.timeIntervalSinceReferenceDate/60.0)*60.0
        d = NSDate(timeIntervalSinceReferenceDate: timeInterval)
            
        let x = GoalItem(goal: goalname.text!,duedate: d, desc: goaldesc.text!, location: goalLocation.text!)
        DataStorage.sharedInstance.addGoal(x!)
        
        NSUserDefaults.standardUserDefaults().setObject(goal, forKey: "list")
        goalname.text=""
    
        delay(d, name: x!.goal)
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
 /*
    //dealing with scroll view: to handle locaiton text view being hidden by keyboard
    func registerForKeyboardNotifications()
    {
        //Adding notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillBeHidden:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func deregisterFromKeyboardNotifications()
    {
        //Removing notifies on keyboard appearing
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification)
    {
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.scrollEnabled = true
        var info : NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        var contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeFieldPresent = goalLocation
        {
            if (!CGRectContainsPoint(aRect, goalLocation!.frame.origin))
            {
                self.scrollView.scrollRectToVisible(goalLocation!.frame, animated: true)
            }
        }
        
        
    }
    
    
    func keyboardWillBeHidden(notification: NSNotification)
    {
        //Once keyboard disappears, restore original positions
        var info : NSDictionary = notification.userInfo!
        var keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue().size
        var contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.scrollEnabled = false
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField!)
    {
        goalLocation = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField!)
    {
        goalLocation = nil
    }
    */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

}

