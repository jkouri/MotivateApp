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
    //var alert: Bool
    
    // MARK: Initialization
    
    init?(goal: String, duedate: NSDate, desc: String) {
        self.goal = goal
        self.duedate = duedate
        self.desc = desc
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
            let desc = decoder.decodeObjectForKey("desc") as? String
            else { return nil }
        
        self.init(
            goal: goal,
            duedate: duedate,
            desc: desc
        )
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.goal, forKey: "goal")
        coder.encodeObject(self.duedate, forKey: "duedate")
        coder.encodeObject(self.desc, forKey: "desc")
       
    }
    
    
    
}
