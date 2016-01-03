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
    var set:Set? = nil
    var array = try! Realm().objects(Set)
    
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
        return array.count
    }
    
    override func viewWillAppear(animated: Bool) {
        notificationToken = realm.addNotificationBlock { [unowned self] note, realm in
            if let profile = realm.objects(Profile).first {
                self.profile = profile
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
        
            Alamofire.request(.GET, "https://rebrickable.com/api/get_user_sets", parameters: ["key": "9BUbjlV9IF", "hash" : (profile?.userHash)!, "format": "json"]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if response.result.value != nil {
                        var jsonObj = JSON(response.result.value!)
                        
                        let items = JSON(jsonObj[0]["sets"].arrayValue)
                        
                        self.loadLego(jsonObj)
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
    
    func loadLego(items:JSON){
        
        if let things = items[0]["sets"].array {
            
            for thing in things {
                
                var predicate = NSPredicate()
                
                if let _ = thing["set_id"].string {
                    predicate = NSPredicate(format: "set_id = %@", thing["set_id"].string!)
                }
                
                let updatedSet = realm.objects(Set).filter(predicate)
                
                if updatedSet.count > 0 {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        // Get realm and table instances for this thread
                        let realm = try! Realm()
                        
                        // Break up the writing blocks into smaller portions
                        // by starting a new transaction
                        for idx1 in 0..<1 {
                            realm.beginWrite()
                            
                            // Add row via dictionary. Property order is ignored.
                            for idx2 in 0..<1 {
                                print("set_id: ", thing["set_id"].string!)
                                
                                let id = updatedSet.first!.id
                                let set_id:String = thing["set_id"].string!
                                let descr:String = thing["descr"].string!
                                let img_sm:String = thing["img_sm"].string!
                                let img_tn:String = thing["img_tn"].string!
                                let pieces:String = thing["pieces"].string!
                                let qty:String = thing["qty"].string!
                                let year:String = thing["year"].string!
                                
                                realm.create(Set.self, value: [
                                    "id": updatedSet.first!.id,
                                    "set_id": "\(set_id)",
                                    "descr": "\(descr)",
                                    "img_sm": "\(img_sm)",
                                    "img_tn": "\(img_tn)",
                                    "pieces": "\(pieces)",
                                    "qty": "\(qty)",
                                    "year": "\(year)"
                                    ], update: true)
                            }
                            
                            // Commit the write transaction
                            // to make this data available to other threads
                            print("updated item")
                            try! realm.commitWrite()
                        }
                        
                    })
                    
                } else {
                    
                    let set = Set()
                    
                    if let set_id = thing["set_id"].string {
                        set.set_id = set_id
                    }
                    if let descr = thing["descr"].string {
                        set.descr = descr
                    }
                    if let img_sm = thing["img_sm"].string {
                        set.img_sm = img_sm
                    }
                    if let img_tn = thing["img_tn"].string {
                        set.img_tn = img_tn
                    }
                    if let pieces = thing["pieces"].string {
                        set.pieces = pieces
                    }
                    if let qty = thing["qty"].string {
                        set.qty = qty
                    }
                    if let year = thing["year"].string {
                        set.year = year
                    }
                    
                    realm.beginWrite()
                    realm.add(set)
                    
                    do {
                        print("wrote new item")
                        try realm.commitWrite()
                        
                    } catch {
                        print("could not add item")
                    }

                }
                
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.array = try! Realm().objects(Set)
            self.tableView.reloadData()
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
        
        let object = array[indexPath.row]
        
        let img_url = object.img_sm
        //            print("userName", userName)
        cell.textLabel?.text = object.set_id
        
        if let url = NSURL(string: "\(img_url)") {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }
        }
        subTitle.text = object.descr
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
            let cell = sender as! UITableViewCell
            let indexPath = legoTable.indexPathForCell(cell)
            
            let legoSetController:LegoSetViewController = segue.destinationViewController as! LegoSetViewController
            
            let legoSet = self.array[indexPath!.row]
            
            legoSetController.legoSet = legoSet 
        }
        
        self.title = ""
    }


}
