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
    
    var currentHabit: String = ""
    var currentTime: NSDate? = nil
    var currentDay: Int = 0
    var currentDateMade: NSDate? = nil



    override func viewDidLoad() {
        super.viewDidLoad()

        
        //set default value = "21 days: for picker

        
       // let currentDate = NSDate()
        //currentTime.minimumDate = currentDate
        //myDatePicker.date = currentDate //7 - defaults

        
        if(self.habitName != "" || self.habitDay != nil) {
            self.habitName.text = self.currentHabit
            
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
        
        let data = NSKeyedArchiver.archivedDataWithRootObject(DataStorage.sharedInstance.habitList)
        NSUserDefaults.standardUserDefaults().setObject(data, forKey: "habits")
        
        NSUserDefaults.standardUserDefaults().setObject(habit, forKey: "list")
        habitName.text=""
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }

    
}
