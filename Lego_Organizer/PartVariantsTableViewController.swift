//
//  PartVariantsTableViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/23/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class PartVariantsTableViewController: UITableViewController {
    
    var partId:JSON = nil
    var datas: JSON = []
    let realm = try! Realm()
    var activePart = -1
    var profile:Profile? = nil
    
    @IBOutlet var legoTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func setupUI() {
        self.title = "Part Variants"
        
        if let profile = realm.objects(Profile).first {
            self.profile = profile
        }
        
        if profile?.userHash != "" {
            
            
            Alamofire.request(.GET, "https://rebrickable.com/api/get_part", parameters: ["key": "9BUbjlV9IF", "part_id" : String(UTF8String: self.partId["part_id"].string!)!, "format": "json"]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if response.result.value != nil {
                        var jsonObj = JSON(response.result.value!)
                        print ("here i am: ", jsonObj["colors"])
                        if let data:JSON = JSON(jsonObj["colors"].arrayValue) {
                            self.datas = data
                            self.legoTable.reloadData()
                        }
                    }
                    
                case .Failure(let error):
                    print(error)
                }
            }
            
        }
        
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
        return datas.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let subTitle = cell.viewWithTag(20) as! UILabel
        
        let object = datas[indexPath.row]
        
        print("object: ", object)
        
        if let userName = object["color_name"].string {

            cell.textLabel?.text = object["color_name"].string!
            

            subTitle.text = "Number of Sets: " + object["num_sets"].string! + ", Number of Parts: " + object["num_parts"].string!
        }
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
