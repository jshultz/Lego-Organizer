//
//  RootTableViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/6/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift

class RootTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var apiKey:String = ""
    
    @IBOutlet var legoTable: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

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
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    override func viewWillAppear(animated: Bool) {
        setupUI()
    }
    
    func setupUI() {
        self.title = "Lego Organizer"
        
        if let profile = realm.objects(Profile).first {
            print("profile.apiKey", profile.apiKey)
            self.apiKey = String(UTF8String: profile.apiKey)!
            print("self.apiKey 2:", self.apiKey)
            self.legoTable.reloadData()
        }
        
        if self.apiKey != "" {
            let postEndpoint: String = "https://rebrickable.com/api/get_part?key=9BUbjlV9IF&part_id=30162"
            guard let url = NSURL(string: postEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            let urlRequest = NSURLRequest(URL: url)
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: config)
            
            let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
                // do stuff with response, data & error here
                print("data: ", data)
                
            })
            task.resume()
        }
        
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        
        self.title = ""
    }


}
