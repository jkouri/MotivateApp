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



    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if(self.habitName != "") {
            if let date = self.currentTime{
                self.habitTime.setDate(date, animated: true)
            }
            self.habitName.text = self.currentHabit
         //   self.habitTime.setDate(self.currentTime!, animated: true)
            let xNSNumber = self.currentDay as NSNumber
            let xString : String = xNSNumber.stringValue
            self.habitDay.text = xString + " /21 Days Completed"
            
            
            
        }
        else {
            
            habitTime.minimumDate = NSDate()
            let timeInterval = floor(habitTime.minimumDate!.timeIntervalSinceReferenceDate/60.0)*60.0
            habitTime.minimumDate = NSDate(timeIntervalSinceReferenceDate: timeInterval)

        }
        

    }

    func dismissAlert(alert: UIAlertAction, x: HabitItem){
        self.dismissViewControllerAnimated(true, completion: nil)
        for item in DataStorage.sharedInstance.habitList{
            var i =  0
            if(item == x){
                if item.day == 21 {
                     DataStorage.sharedInstance.habitList.removeAtIndex(i)
                } else {
                    item.day = item.day + 1
                }
               
                break
            }
            i = i+1
        }
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
      /*  let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/goal_list.db")
         
         NSKeyedArchiver.archiveRootObject(DataStorage.sharedInstance.goalList, toFile: destinationPath as String)*/
    }

    
    func postponeAlert(alert: UIAlertAction, alertController: UIAlertController, x: HabitItem){
        
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3600.00 * Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
                UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
        x.time = x.time.dateByAddingTimeInterval(60*60)
        NSNotificationCenter.defaultCenter().postNotificationName("reload", object: nil)
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/habit_list.db")
        
        NSKeyedArchiver.archiveRootObject(DataStorage.sharedInstance.habitList, toFile: destinationPath as String)
        
    }
    
    
    func delay(date: NSDate, alertController: UIAlertController, x: HabitItem){
        dispatch_async(dispatch_get_main_queue(), {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(date.timeIntervalSinceDate(NSDate()))*Double(NSEC_PER_SEC))), dispatch_get_main_queue())
            {
                UIApplication.sharedApplication().keyWindow?.rootViewController!.presentViewController(alertController, animated: true, completion: nil)
            }
        })
        
    }

    
    
   
    @IBAction func addHabit(sender: AnyObject) {
        if(self.currentHabit != "") {
            if let x = HabitItem(habit: self.currentHabit, time: self.currentTime!, day: self.currentDay, dateMade: self.currentDateMade!, dailyAlert: self.currentDailyAlert!) {
                if let i = DataStorage.sharedInstance.habitList.indexOf(x) {
                    DataStorage.sharedInstance.habitList.removeAtIndex(i)
                }
            }
        }
        
        let alertController = UIAlertController(title: "Due:", message: habitName.text!, preferredStyle: UIAlertControllerStyle.Alert)

        
        var d = habitTime.date
        let timeInterval = floor(d.timeIntervalSinceReferenceDate/60.0)*60.0
        d = NSDate(timeIntervalSinceReferenceDate: timeInterval)
       
        let x = HabitItem(habit: habitName.text!, time: d, day: 0, dateMade: NSDate(), dailyAlert: alertController)
        DataStorage.sharedInstance.addHabit(x!)
        
        
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/habit_list.db")
        
        NSKeyedArchiver.archiveRootObject(DataStorage.sharedInstance.habitList, toFile: destinationPath as String)
        
        NSUserDefaults.standardUserDefaults().setObject(habit, forKey: "list")
        habitName.text=""
        self.navigationController?.popToRootViewControllerAnimated(true)
        
        alertController.addAction(UIAlertAction(title: "Completed", style: .Cancel, handler: {
            action in self.dismissAlert(action, x: x!)
        }))
        alertController.addAction(UIAlertAction(title: "Postpone", style: .Default, handler: {
            action in self.postponeAlert(action, alertController: alertController, x: x!)
        }))
        
        delay(d, alertController: alertController, x: x!)

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
