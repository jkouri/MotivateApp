//
//  HTableVC.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/14/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit

class HTableVC: UITableViewController {
    

    var currentHabit: HabitItem? = nil
    
    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableData:", name: "reload", object: nil)
    
        DataStorage.sharedInstance.reloadHabitData()
    }
    
    /*        if NSUserDefaults.standardUserDefaults().objectForKey("list") != nil {
     reminderlist = NSUserDefaults.standardUserDefaults().objectForKey("list") as! [ReminderItem] */
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    func reloadTableData(notification: NSNotification){
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataStorage.sharedInstance.getHabit().count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HabitID", forIndexPath: indexPath)
    
        
        
        let list = DataStorage.sharedInstance.habitList
        cell.textLabel?.text = list[indexPath.row].habit
        
      //  let start:String = "2016-04-10"
        //let dateFormatter = NSDateFormatter()
       // dateFormatter.dateFormat = "yyyy-MM-dd"
       // let startDate:NSDate = dateFormatter.dateFromString(start)!
       // let startDate:NSDate = list[indexPath.row].dateMade
        //let endDate: NSDate = NSDate()
        //let daysToAdd:Double = 21;
        //let endDate:NSDate = startDate.dateByAddingTimeInterval(60*60*24*daysToAdd)
        
       /* let cal = NSCalendar.currentCalendar()
        
        let components = cal.components(NSCalendarUnit.Day, fromDate: startDate, toDate: endDate, options: [])
        
        print(components)
        
        list[indexPath.row].day = components.day*/
        let x = list[indexPath.row].day
        let string = String(x)
        cell.detailTextLabel?.text = string
        //    cell.detailTextLabel?.text = NSDateFormatter.localizedStringFromDate(list[indexPath.row].day, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle:NSDateFormatterStyle.ShortStyle)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete {
            DataStorage.sharedInstance.habitList.removeAtIndex(indexPath.row)
       //     NSUserDefaults.standardUserDefaults().setObject(DataStorage.sharedInstance.habitList, forKey: "list")
            DataStorage.sharedInstance.storeHabitData()
            DataStorage.sharedInstance.reloadHabitData()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.currentHabit = DataStorage.sharedInstance.habitList[indexPath.row]
        if(currentHabit != nil) {
            self.performSegueWithIdentifier("EditHabit", sender: self)
            //self.parentViewController?.performSegueWithIdentifier("EditReminder", sender: self)
        }
        
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        //destVC.dynamicType.init()
        if (currentHabit != nil && segue.identifier == "EditHabit"){
            let destVC = segue.destinationViewController as! NewHabitVC
        
            destVC.currentHabit = (currentHabit?.habit)!
            destVC.currentTime = currentHabit!.time
            destVC.currentDay = (currentHabit?.day)!
            destVC.currentDateMade = (currentHabit?.dateMade)
           // destVC.currentDailyAlert = (currentHabit?.dailyAlert)
            destVC.currentOriginaltime = (currentHabit?.origTime)
            //  destVC.currentAlertC = (curr?.alertController)
        }
    }
    
    

    
    
}
