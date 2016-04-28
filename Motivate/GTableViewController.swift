//
//  TableViewController.swift
//  Motivate
//
//  Created by Jacqueline Kouri on 4/4/16.
//  Copyright © 2016 Jacqueline Kouri. All rights reserved.
//

import UIKit


class GTableViewController: UITableViewController  {
   
    @IBOutlet var tableview: UITableView!
    var currentGoal: GoalItem? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadTableData:", name: "reload", object: nil)
        
                
        DataStorage.sharedInstance.reloadGoalData()
        
    }
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = false
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    
    func reloadTableData(notification: NSNotification){
        tableview.reloadData()
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
        return DataStorage.sharedInstance.getGoal().count
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GoalID", forIndexPath: indexPath)
        let list = DataStorage.sharedInstance.goalList
        cell.textLabel?.text = list[indexPath.row].goal
        cell.detailTextLabel?.text = NSDateFormatter.localizedStringFromDate(list[indexPath.row].duedate, dateStyle: NSDateFormatterStyle.FullStyle, timeStyle:NSDateFormatterStyle.ShortStyle)
        return cell
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath){
        if editingStyle == UITableViewCellEditingStyle.Delete {
            DataStorage.sharedInstance.goalList.removeAtIndex(indexPath.row)
            NSUserDefaults.standardUserDefaults().setObject(DataStorage.sharedInstance.goalList, forKey: "list")
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            tableView.reloadData()
            
          /*  let documentsPath : AnyObject = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask,true)[0]
            let destinationPath:NSString = documentsPath.stringByAppendingString("/goal_list.db")
            
            NSKeyedArchiver.archiveRootObject(DataStorage.sharedInstance.goalList, toFile: destinationPath as String)*/

        }
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        self.currentGoal = DataStorage.sharedInstance.goalList[indexPath.row]
        if(currentGoal != nil) {
            self.performSegueWithIdentifier("EditGoal", sender: self)
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
        if (currentGoal != nil && segue.identifier == "EditGoal"){
            let destVC = segue.destinationViewController as! AddGoalVC
            
            destVC.currentGoal = (currentGoal?.goal)!
            destVC.currentDueDate = currentGoal!.duedate
            destVC.currentDesc = (currentGoal?.desc)!
            destVC.curLocation = (currentGoal?.location)!
          //  destVC.currentAlertC = (curr?.alertController)
        }
    }
    
    
    
    
}
