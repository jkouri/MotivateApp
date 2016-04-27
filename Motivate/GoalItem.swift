//
//  ReminderItem.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/4/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit

class GoalItem: NSObject, NSCoding {
    
    //simple details -name, time, ect.
    //data strogate will hold array of reminderItems
    
    //MARK: Properties
    var goal: String
    var duedate: NSDate
    var desc: String
    var location: String
    //var alert: UILocalNotification
    var alert: UIAlertController

    //var alert: Bool
    
    // MARK: Initialization
    
    init?(goal: String, duedate: NSDate, desc: String, location: String, alert: UIAlertController) {
        self.goal = goal
        self.duedate = duedate
        self.desc = desc
        self.location = location
        self.alert = alert
        
        
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let other = object as? GoalItem{
            return (self.goal == other.goal && self.duedate.compare(other.duedate) == NSComparisonResult.OrderedSame)
        }else{
            return false
        }
    }
    
    // MARK: NSCoding
    
    required convenience init?(coder decoder: NSCoder) {
        guard let goal = decoder.decodeObjectForKey("goal") as? String,
            let duedate = decoder.decodeObjectForKey("duedate") as? NSDate,
            let desc = decoder.decodeObjectForKey("desc") as? String,
            let location = decoder.decodeObjectForKey("location") as? String,
            let alert = decoder.decodeObjectForKey("alert") as? UIAlertController
            else { return nil }
        
        self.init(
            goal: goal,
            duedate: duedate,
            desc: desc,
            location: location,
            alert: alert
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.goal, forKey: "goal")
        coder.encodeObject(self.duedate, forKey: "duedate")
        coder.encodeObject(self.desc, forKey: "desc")
        coder.encodeObject(self.location, forKey: "location")
        coder.encodeObject(self.alert, forKey: "alert")
    }
    
    
    
}
