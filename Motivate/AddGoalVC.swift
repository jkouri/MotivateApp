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
   // var currentAlertC: UIAlertController? = nil
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        goalname.delegate = self
    
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        
        self.goaldesc.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.goaldesc.delegate = self
        self.goaldesc.text = "Make your goal SMART! Specific, Measurable, Attainable, Realistic and Time-Oriented"
        self.goaldesc.textColor = UIColor.lightGrayColor()
        
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
            self.goaldesc.layer.borderWidth = 1.0

        }
        
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
        displayLocationInfo(self.currentLocation!)
    }
    
    func displayLocationInfo(placemark: CLPlacemark){
        self.locationManager.stopUpdatingLocation()
        self.curLocation = placemark.locality! + ", "  + placemark.administrativeArea! + " " + placemark.postalCode! + " " + placemark.country!
        goalLocation.text = self.curLocation
    }
    
    func locaitonManager(manager: CLLocation!, didFailWithError error: NSError!){
        print("Error" + error.localizedDescription)
    }
    
    // MARK: UITextViewDelegate
    
    /*
     func countUp(){
     for reminder in DataStorage.sharedInstance.reminderlist{
     if Int64(NSDate().timeIntervalSinceDate(reminder.date)) == 0 || Int64(NSDate().timeIntervalSinceDate(reminder.date)) == 1 || Int64(NSDate().timeIntervalSinceDate(reminder.date)) == -1{
     UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(reminder.alertController, animated: true, completion: nil)
     }
     }
     }
     */
    
    
    func textViewDidBeginEditing(textView: UITextView){
        if textView.textColor == UIColor.lightGrayColor(){
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView){
        if textView.text.isEmpty {
            textView.text = "Make your goal SMART! Specific, Measurable, Attainable, Realistic and Time-Oriented"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        //Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
    func dismissAlert(alert: UIAlertAction, x: GoalItem){
        self.dismissViewControllerAnimated(true, completion: nil)
        var i = 0
        for item in DataStorage.sharedInstance.goalList{
            if(item == x){
                DataStorage.sharedInstance.goalList.removeAtIndex(i)
                break
            }
            i=i+1
        }
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
    }
    
    
    func postponeAlert(alert: UIAlertAction, alertController: UIAlertController, x: GoalItem){
        
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3600.00 * Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
                UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
        })
    }
    
    
    func delay(date: NSDate, alertController: UIAlertController, x: GoalItem){
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(date.timeIntervalSinceDate(NSDate()))*Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
                UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
    }
    
    
    //MARK: Actions
    @IBAction func addGoal(sender: AnyObject) {
        if(self.currentGoal != "" || self.currentDueDate != nil) {
            if let x = GoalItem(goal: self.currentGoal, duedate: currentDueDate!, desc: self.currentDesc, location: self.curLocation) {
                if let i = DataStorage.sharedInstance.goalList.indexOf(x) {
                    DataStorage.sharedInstance.goalList.removeAtIndex(i)
                }
            }
        }
        
      /*  let alertController = UIAlertController(title: "Due:", message: goalname.text!, preferredStyle: UIAlertControllerStyle.Alert)
        */
        var d = duedate.date
        let timeInterval = floor(d.timeIntervalSinceReferenceDate/60.0)*60.0
        d = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        
        let x = GoalItem(goal: goalname.text!,duedate: d, desc: goaldesc.text!, location: goalLocation.text!)
        DataStorage.sharedInstance.addGoal(x!)
        
        
        
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/goal_list.db")
        
        NSKeyedArchiver.archiveRootObject(DataStorage.sharedInstance.goalList, toFile: destinationPath as String)

        
        NSUserDefaults.standardUserDefaults().setObject(goal, forKey: "list")
        goalname.text=""
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
       /* alertController.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: {
            action in self.dismissAlert(action, x: x!)
        }))
        alertController.addAction(UIAlertAction(title: "Postpone", style: .Default, handler: {
            action in self.postponeAlert(action, alertController: alertController, x: x!)
        }))
        
        delay(d, alertController: alertController, x: x!) */
    
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

