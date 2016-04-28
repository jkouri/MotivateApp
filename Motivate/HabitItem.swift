//
//  HabitItem.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/13/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit

class HabitItem: NSObject, NSCoding {

    //simple details -name, time, ect.
    //data strogate will hold array of reminderItems
    
    //MARK: Properties
    var habit: String
    var time: NSDate
    var origTime: NSDate
    var day: Int
    var dateMade: NSDate
    //var dailyAlert: UIAlertController
    
    //var alert: Bool
    
    // MARK: Initialization
    
    init?(habit: String, time: NSDate, origTime: NSDate, day: Int, dateMade: NSDate) {
        self.habit = habit
        self.time = time
        self.origTime = origTime
        self.day = day
        self.dateMade = dateMade
       // self.dailyAlert = dailyAlert
        
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? HabitItem{
            return (self.habit == other.habit && self.time.compare(other.time) == NSComparisonResult.OrderedSame)
        }else{
            return false
        }
    }
    
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let habit = decoder.decodeObjectForKey("habit") as? String,
            let time = decoder.decodeObjectForKey("time") as? NSDate,
            let origTime = decoder.decodeObjectForKey("origTime") as? NSDate,
            let dateMade = decoder.decodeObjectForKey("dateMade") as? NSDate
          //  let dailyAlert = decoder.decodeObjectForKey("dailyAlert") as? UIAlertController
            else { return nil }
        
        self.init(
            habit: habit,
            time: time,
            origTime: origTime,
            day: decoder.decodeIntegerForKey("day"),
            dateMade: dateMade
           // dailyAlert: dailyAlert
            )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.habit, forKey: "habit")
        coder.encodeObject(self.time, forKey: "time")
        coder.encodeObject(self.origTime, forKey: "origTime")
        coder.encodeInt(Int32(self.day), forKey: "day")
        coder.encodeObject(self.dateMade, forKey: "dateMade")
       // coder.encodeObject(self.dailyAlert, forKey: "dailyAlert")
    }
    
        
}
