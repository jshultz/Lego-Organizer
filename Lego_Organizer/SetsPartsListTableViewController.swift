//
//  SetsPartsListTableViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/13/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class SetsPartsListTableViewController: UITableViewController {
    
    var setId:JSON = nil
    var datas: JSON = []
    var activePart = -1
    
    var legoSet: LegoSets? = nil
    
    @IBOutlet var legoTable: UITableView!
    
    
    func setupUI() {
        self.title = "Brickly: Parts List"
        
        self.tableView.backgroundColor = UIColor(red: 0.2706, green: 0.3412, blue: 0.9098, alpha: 1.0) /* #4557e8 */
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        Alamofire.request(.GET, "https://rebrickable.com/api/get_set_parts", parameters: [
            "key": "9BUbjlV9IF",
            "set" : (self.legoSet?.set_id)!,
            "format": "json"]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if response.result.value != nil {
                        var jsonObj = JSON(response.result.value!)
                        
                        if let data:JSON = JSON(jsonObj[0]["parts"].arrayValue) {
                            self.datas = data
                            self.legoTable.reloadData()
                        }
                    }
                    
                case .Failure(let error):
                    print(error)
                }
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        print("indexPath: ", indexPath)
        activePart = indexPath.row
        return indexPath
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return datas.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
//        print("datas[indexPath.row]: ", datas[indexPath.row])
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(30) as! UIImageView
        
        let Title = cell.viewWithTag(10) as! UILabel
        
        let subTitle = cell.viewWithTag(20) as! UILabel
        
        Title.textColor = UIColor.whiteColor()
        subTitle.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor(red: 0.2941, green: 0.5608, blue: 1, alpha: 1.0) /* #4b8fff */
        
        let object = datas[indexPath.row]
        
        if let userName = object["part_id"].string {
            let img_url = String(UTF8String: object["part_img_url"].string!)!
//            print("userName", userName)
            cell.textLabel?.text = userName + " " + object["part_name"].string!
            
            if let url = NSURL(string: "\(img_url)") {
                if let data = NSData(contentsOfURL: url) {
                    imageView.image = UIImage(data: data)
                }
            }
            subTitle.text = "Color: " + object["color_name"].string! + ", Quantity: " + object["qty"].string!
        }
//        print("object: ", object)
        
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


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "newPlace" {
            
        } else if segue.identifier == "showPartDetail" {
            
            let partDetailController:PartDetailViewController = segue.destinationViewController as! PartDetailViewController
            
            //            print("activeSet: ", self.datas[activeSet])
            
            let setId = self.datas[activePart]
            
            partDetailController.partId = setId
        }
        
        
    }


}
