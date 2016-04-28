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
    
    func reloadHabitData(){
        
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/habit_list.db")
        
        let tempList = NSKeyedUnarchiver.unarchiveObjectWithFile(destinationPath as String)
        
        if ((tempList) != nil){
            self.habitList = tempList as! [HabitItem]
        }
        
    }
    
    func reloadGoalData(){
        let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationPath:NSString = documentsPath.stringByAppendingString("/goal_list.db")
        
        let tempList = NSKeyedUnarchiver.unarchiveObjectWithFile(destinationPath as String)
        
        if ((tempList) != nil){
            self.goalList = tempList as! [GoalItem]
        }

    }
    
    func storeHabitData(){
        let documentPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
        let destinationsPath:NSString = documentPath.stringByAppendingString("/habit_list.db")
        
        NSKeyedArchiver.archiveRootObject(self.habitList, toFile: destinationsPath as String)
    }
    
    func storeGoalData(){
    
    let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
    let destinationPath:NSString = documentsPath.stringByAppendingString("/goal_list.db")
    
    NSKeyedArchiver.archiveRootObject(self.goalList, toFile: destinationPath as String)
    }
    
    func addGoal(item: GoalItem){
        goalList.append(item)
        goalList.sortInPlace({$0.duedate.compare($1.duedate) == NSComparisonResult.OrderedAscending})
        self.storeGoalData()
        self.reloadGoalData()
    }
    
    //called from table view
    // have array of reminderItems
    func getGoal() -> [GoalItem] {
        return goalList;
    }
    
    func getGoalWithName(name: String) -> GoalItem?{
        for item:GoalItem in self.goalList{
            if item.goal == name{
                return item
            }
        }
        
        return nil
    }
    
    
    func getHabitWithName(name: String) -> HabitItem?{
        for item:HabitItem in self.habitList{
            if item.habit == name{
                return item
            }
        }
        
        return nil
    }

    
    func removeGoalWithName(name: String){
        var targetIndex = -1
        for index in 0..<self.goalList.count{
            if self.goalList[index].goal == name{
                targetIndex = index
                break
            }
        }
        
        if targetIndex != -1{
            self.goalList.removeAtIndex(targetIndex)
        }
        self.storeGoalData()
        self.reloadGoalData()
    }
    
    
    func removeHabitWithName(name: String){
        var targetIndex = -1
        for index in 0..<self.habitList.count{
            if self.habitList[index].habit == name{
                targetIndex = index
                break
            }
        }
        
        if targetIndex != -1{
            self.habitList.removeAtIndex(targetIndex)
        }
        self.storeHabitData()
        self.reloadHabitData()
        
    }
    
    func addHabit(item: HabitItem){
        habitList.append(item)
        habitList.sortInPlace({$0.time.compare($1.time) == NSComparisonResult.OrderedAscending})
        self.storeHabitData()
        self.reloadHabitData()
        
    }
    
    //called from table view
    // have array of reminderItems
    func getHabit() -> [HabitItem] {
        return habitList;
    }
    
    
}
