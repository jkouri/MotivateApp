//
//  DataStorage.swift
//  Motivate
//  Created by Jacqueline Kouri on 4/4/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit

class DataStorage: NSObject {
    var goalList = [GoalItem]()
    var habitList = [HabitItem]()
    
    //swift singleton class
    //accessible to all view controllers
    
    static let sharedInstance = DataStorage()
    
    override init() {
        super.init();
        
    }
    
    
    
    func addGoal(item: GoalItem){
        goalList.append(item)
        goalList.sortInPlace({$0.duedate.compare($1.duedate) == NSComparisonResult.OrderedAscending})
        
    }
    
    //called from table view
    // have array of reminderItems
    func getGoal() -> [GoalItem] {
        return goalList;
    }
    
    
    func addHabit(item: HabitItem){
        habitList.append(item)
        habitList.sortInPlace({$0.time.compare($1.time) == NSComparisonResult.OrderedAscending})
        
    }
    
    //called from table view
    // have array of reminderItems
    func getHabit() -> [HabitItem] {
        return habitList;
    }
    
    
}
