//
//  NewHabitVC.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/13/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit

var habit = [HabitItem]()


class NewHabitVC: UIViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var habitTime: UIDatePicker!
    @IBOutlet weak var habitName: UITextField!
    @IBOutlet weak var habitDay: UILabel!

    
    //currentTime is the time it should remind at, currentDateMade is the date it was made
    var currentHabit: String = ""
    var currentTime: NSDate? = nil
    var currentDay: Int = 0
    var currentDateMade: NSDate? = nil
    var currentDailyAlert: UIAlertController? = nil
    var currentOriginaltime: NSDate? = nil



    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitTime.datePickerMode = UIDatePickerMode.Time
        
        if(self.currentHabit != "") {
            if let date = self.currentTime {
                self.habitTime.setDate(date, animated: true)
            }
            self.habitName.text = self.currentHabit
         //   self.habitTime.setDate(self.currentTime!, animated: true)
            let xNSNumber = self.currentDay as NSNumber
            let xString : String = xNSNumber.stringValue
            self.habitDay.text = xString + " /21 Days Completed"
            
            
            
        } else {
            self.habitDay.text = ""
        }
       /* else {
            
           /* habitTime.minimumDate = NSDate()
            let timeInterval = floor(habitTime.minimumDate!.timeIntervalSinceReferenceDate/60.0)*60.0
            habitTime.minimumDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)*/

        }
        */

    }

    func dismissAlert(alert: UIAlertAction, x: String){
       //unarchiving
        self.dismissViewControllerAnimated(true, completion: nil)
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/habit_list.db")
        
        let tempList = NSKeyedUnarchiver.unarchiveObjectWithFile(destinationPath as String)
        
        if ((tempList) != nil){
            DataStorage.sharedInstance.habitList = tempList as! [HabitItem]
        }
        
        //editing/updating/deleting an item
        
        if let habit = DataStorage.sharedInstance.getHabitWithName(x){
            if (habit.day == 20){
                DataStorage.sharedInstance.removeHabitWithName(x)
            } else {
                habit.day = habit.day + 1
                habit.origTime = habit.origTime.dateByAddingTimeInterval(60*60*24)
                habit.time = habit.origTime
            }
        }
    
        
        //reloading data and archiving again
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        DataStorage.sharedInstance.storeHabitData()
        DataStorage.sharedInstance.reloadHabitData()
    }

    
    func postponeAlert(alert: UIAlertAction, alertController: UIAlertController, x: String){
        
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3600.00 * Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
                UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
        if let habit = DataStorage.sharedInstance.getHabitWithName(x) {
            habit.time = habit.time.dateByAddingTimeInterval(60*60)
            NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
            DataStorage.sharedInstance.storeHabitData()
            DataStorage.sharedInstance.reloadHabitData()
        }
        
    }
    
    
    func delay(date: NSDate, name:String){
        print(date.timeIntervalSinceDate(NSDate()))
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(date.timeIntervalSinceDate(NSDate())*Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
              //  print("FUTURE BLOCK EXECUTED")
                if let habit = DataStorage.sharedInstance.getHabitWithName(name) {
                    if habit.time.compare(date) == .OrderedSame{
                        let alertController = UIAlertController(title: "Due:", message: habit.habit, preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Completed", style: .Cancel, handler: {
                            action in self.dismissAlert(action, x: habit.habit)
                        }))
                        alertController.addAction(UIAlertAction(title: "Postpone", style: .Default, handler: {
                            action in self.postponeAlert(action, alertController: alertController, x: habit.habit)
                        }))
                        UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
                    }
                }
                
            }
        })
    }

   
    @IBAction func addHabit(sender: AnyObject) {
       
       if let habit = DataStorage.sharedInstance.getHabitWithName(self.currentHabit){
        print(habit.habit)
        if habit.time.compare(habitTime.date) != .OrderedSame {
            // print(habit.time.timeIntervalSince1970)
            // print(habitTime.date.timeIntervalSince1970)
            habit.time = habitTime.date
            delay(habit.time, name: habit.habit)
        }
        if let name = habitName.text{
            if habit.habit != name{
                habit.habit = name
                delay(habit.time, name:habit.habit)
            }
        }
        
        DataStorage.sharedInstance.storeHabitData()
        DataStorage.sharedInstance.reloadHabitData()
        
        }else{
            var d = habitTime.date
            let timeInterval = floor(d.timeIntervalSinceReferenceDate/60.0)*60.0
            d = NSDate(timeIntervalSinceReferenceDate: timeInterval)
        
            let x = HabitItem(habit: habitName.text!, time: d, origTime: d, day: 0, dateMade: NSDate())
            DataStorage.sharedInstance.addHabit(x!)
        
            NSUserDefaults.standardUserDefaults().setObject(habit, forKey: "list")
            habitName.text=""
        
            delay(d, name: x!.habit)
        }
        self.navigationController?.popToRootViewControllerAnimated(true)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
