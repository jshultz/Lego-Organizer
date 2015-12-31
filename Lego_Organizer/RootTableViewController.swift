//
//  RootTableViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/6/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class RootTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var profile:Profile? = nil
    
    var apiKey:String = ""
    
    var userSets:NSArray = []
    
    var activeSet = -1
    
//    var datas: [JSON] = []
    var datas: JSON = []
    
    var notificationToken: NotificationToken?
    
    @IBOutlet var legoTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if let _ = realm.objects(Profile).first {
            
        }
        setupUI()
        
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
    
    override func viewWillAppear(animated: Bool) {
        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            if let profile = realm.objects(Profile).first {
                self.profile = profile
                print("in the notification token")
                print("profile: ", self.profile)
                self.setupUI()
            }
        }
    }
    
    func getUserSets(userHash:String, completionHandler: (JSON?) -> ()) -> () {
        
    }
    
    func setupUI() {
        self.title = "Lego Organizer"
        
        if let profile = realm.objects(Profile).first {
            self.profile = profile
        }
        
        if ((profile?.userHash) != nil) {
            
            print("in the if: ", profile?.userHash)
            
        
            Alamofire.request(.GET, "https://rebrickable.com/api/get_user_sets", parameters: ["key": "9BUbjlV9IF", "hash" : (profile?.userHash)!, "format": "json"]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if response.result.value != nil {
                        var jsonObj = JSON(response.result.value!)
//                        print("jsonObj: ", jsonObj)
                        
                        if let data:JSON = JSON(jsonObj[0]["sets"].arrayValue) {
                            self.datas = data
//                            print("jsonObj: ", jsonObj)
//                            print("datas: ", self.datas)
//                            print("data: ", response.result.value)
                            self.legoTable.reloadData()
                        }
                    }
                    
                case .Failure(let error):
                    print(error)
                }
            }
            
        } else {
            print("in the else: ", profile?.userHash)
            self.performSegueWithIdentifier("showProfile", sender: self)
//            self.showAlert("No API Key", errorMessage: "You need an API Key from rebrickable.com. Please add it in the profile.")
            
        }
        
    }
    
    func showAlert(errorTitle:String, errorMessage:String) {
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            dispatch_async(dispatch_get_main_queue(), {
                alert.dismissViewControllerAnimated(true, completion: {
                    print("i'm in the disimissal")
                    self.performSegueWithIdentifier("showProfile", sender: self)
                })
                
            })
        })
        
        alert.addAction(ok)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(30) as! UIImageView
        
        let subTitle = cell.viewWithTag(20) as! UILabel
        
        let object = datas[indexPath.row]
        
        if let userName = object["set_id"].string {
            let img_url = String(UTF8String: object["img_sm"].string!)!
//            print("userName", userName)
            cell.textLabel?.text = userName
            
            if let url = NSURL(string: "\(img_url)") {
                if let data = NSData(contentsOfURL: url) {
                    imageView.image = UIImage(data: data)
                }        
            }
            subTitle.text = object["descr"].string
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


    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
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
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        print("indexPath: ", indexPath)
        activeSet = indexPath.row
        return indexPath
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "newPlace" {
            
        } else if segue.identifier == "showLegoSet" {
            
            let legoSetController:LegoSetViewController = segue.destinationViewController as! LegoSetViewController
            
//            print("activeSet: ", self.datas[activeSet])
            
            let setId = self.datas[activeSet]
            
            legoSetController.setId = setId
        }
        
        self.title = ""
    }


}
