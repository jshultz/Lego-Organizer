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
    var array = try! Realm().objects(Set).sorted("descr", ascending: true)
    
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
    
    @IBAction func showSortOptions(sender: AnyObject) {
        showSorting("Sort Sets", errorMessage: "Sort Sets by either Name or Number.")
    }
    
    func setupUI() {
        self.title = "Lego Organizer"
        
        self.tableView.backgroundColor = UIColor.orangeColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        
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
    
    func showSorting(errorTitle:String, errorMessage:String) {
        let alert = UIAlertController(title: "\(errorTitle)", message: "\(errorMessage)", preferredStyle: .Alert) // 1
        let firstAction = UIAlertAction(title: "Sort by Set Number", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("Sorting by Number")
            
            self.array = try! Realm().objects(Set).sorted("set_id", ascending: true)
            self.tableView.reloadData()
            
        } // 2
        alert.addAction(firstAction) // 4
        
        let secondAction = UIAlertAction(title: "Sort by Set Name", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("Sorting by Name")
            self.array = try! Realm().objects(Set).sorted("descr", ascending: true)
            self.tableView.reloadData()
        } // 3
        
        alert.addAction(secondAction) // 5
        
        presentViewController(alert, animated: true, completion:nil) // 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let imageView = cell.viewWithTag(30) as! UIImageView
        
        let Title = cell.viewWithTag(10) as! UILabel
        
        let subTitle = cell.viewWithTag(20) as! UILabel
        
        Title.textColor = UIColor.whiteColor()
        subTitle.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor(red: 0.7176, green: 0.1647, blue: 0.2, alpha: 1.0) /* #b72a33 */
        
        let object = array[indexPath.row]
        
        let img_url = object.img_sm
        cell.textLabel?.text = object.set_id
        
        imageView.contentMode = .ScaleAspectFit
        
        if let checkedUrl = NSURL(string: "\(img_url)") {
            imageView.contentMode = .ScaleAspectFit
            
            getDataFromUrl(checkedUrl) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    imageView.image = UIImage(data: data)
                }
            }
        }

        subTitle.text = object.descr
        
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
            print("array[indexPath.row]:", array[indexPath.row])
            realm.beginWrite()
            realm.delete(array[indexPath.row] as Object)
            try! realm.commitWrite()
            self.tableView.reloadData()
            
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
        
//        self.title = ""
    }
    
    func colorForIndex(index: Int) -> UIColor {
        let itemCount = userSets.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func downloadImage(url: NSURL){
        print("Download Started")
        print("lastPathComponent: " + (url.lastPathComponent ?? ""))
        getDataFromUrl(url) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
//                print(response?.suggestedFilename ?? "")
//                print("Download Finished")
//                imageView.image = UIImage(data: data)
            }
        }
    }


}
