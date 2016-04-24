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

    
   
    @IBAction func addHabit(sender: AnyObject) {
        if(self.currentHabit != "") {
            if let x = HabitItem(habit: self.currentHabit, time: self.currentTime!, day: self.currentDay, dateMade: self.currentDateMade!) {
                if let i = DataStorage.sharedInstance.habitList.indexOf(x) {
                    DataStorage.sharedInstance.habitList.removeAtIndex(i)
                }
            }
        }
        
        /*  let alertController = UIAlertController(title: "Due:", message: goalname.text!, preferredStyle: UIAlertControllerStyle.Alert)

         */
        var d = habitTime.date
        let timeInterval = floor(d.timeIntervalSinceReferenceDate/60.0)*60.0
        d = NSDate(timeIntervalSinceReferenceDate: timeInterval)

        
        let x = HabitItem(habit: habitName.text!, time: d, day: 0, dateMade: NSDate())
        DataStorage.sharedInstance.addHabit(x!)
        
        
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/habit_list.db")
        
        NSKeyedArchiver.archiveRootObject(DataStorage.sharedInstance.habitList, toFile: destinationPath as String)
        
        NSUserDefaults.standardUserDefaults().setObject(habit, forKey: "list")
        habitName.text=""
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
