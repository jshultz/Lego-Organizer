//
//  RootTableViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/6/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData

class RootTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var apiKey:String = ""
    
    var userSets:NSArray = []
    
    var activeSet = -1
    
    var datas: JSON = []
    
    @IBOutlet var legoTable: UITableView!
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var fetchedResultController: NSFetchedResultsController = NSFetchedResultsController()

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
        let numberOfSections = fetchedResultController.sections?.count
        return numberOfSections!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = fetchedResultController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func viewWillAppear(animated: Bool) {

    }
    
    @IBAction func showSortOptions(sender: AnyObject) {
        showSorting("Sort Sets", errorMessage: "Sort Sets by either Name or Number.")
    }
    
    // MARK:- Retrieve LegoSets
    
    let sortBy = ""
    
    func getFetchedResultController(sortBy:String) -> NSFetchedResultsController {
        fetchedResultController = NSFetchedResultsController(fetchRequest: legoSetFetchRequest(sortBy), managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultController
    }
    
    func legoSetFetchRequest(sortBy:String) -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "LegoSets")
        
        var sortDescriptor = NSSortDescriptor()
        if (sortBy == "description") {
            sortDescriptor = NSSortDescriptor(key: "descr", ascending: true)
        } else {
            sortDescriptor = NSSortDescriptor(key: "set_id", ascending: true)
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    func setupUI() {
        self.title = "Lego Organizer"
        
        self.tableView.backgroundColor = UIColor(red: 0.2706, green: 0.3412, blue: 0.9098, alpha: 1.0) /* #4557e8 */
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        fetchedResultController = getFetchedResultController("description")
        fetchedResultController.delegate = self
        do {
            try fetchedResultController.performFetch()
        } catch _ {
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
    
    func showSorting(errorTitle:String, errorMessage:String) {
        let alert = UIAlertController(title: "\(errorTitle)", message: "\(errorMessage)", preferredStyle: .Alert) // 1
        
        let firstAction = UIAlertAction(title: "Sort by Set Name", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("Sorting by Name")
            
            self.fetchedResultController = self.getFetchedResultController("description")
            self.fetchedResultController.delegate = self
            do {
                try self.fetchedResultController.performFetch()
            } catch _ {
            }
            
            self.tableView.reloadData()
        } // 3
        
        alert.addAction(firstAction) // 5
        
        let secondAction = UIAlertAction(title: "Sort by Set Number", style: .Default) { (alert: UIAlertAction!) -> Void in
            NSLog("Sorting by Number")
            
            self.fetchedResultController = self.getFetchedResultController("set_id")
            self.fetchedResultController.delegate = self
            do {
                try self.fetchedResultController.performFetch()
            } catch _ {
            }
            
            self.tableView.reloadData()
            
        } // 2
        alert.addAction(secondAction) // 4
        
        
        
        presentViewController(alert, animated: true, completion:nil) // 6
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "LegoSetTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! LegoSetTableViewCell
        
        cell.titleLabel.textColor = UIColor.whiteColor()
        cell.descriptionLabel.textColor = UIColor.whiteColor()
        cell.backgroundColor = UIColor(red: 0.2941, green: 0.5608, blue: 1, alpha: 1.0) /* #4b8fff */
                
        let legoSet = fetchedResultController.objectAtIndexPath(indexPath) as! LegoSets
        
        cell.titleLabel.text = legoSet.valueForKey("set_id") as? String
        
        cell.photoImageView.contentMode = .ScaleAspectFit
        
        let myImageName = legoSet.valueForKey("img_tn") as? String
        let imagePath = fileInDocumentsDirectory(myImageName!)
        
        let checkImage = NSFileManager.defaultManager()
        
        if (checkImage.fileExistsAtPath(imagePath)) {
            
            if let _ = loadImageFromPath(imagePath) {
                if legoSet.valueForKey("img_tn") as? String != "" {
                    cell.photoImageView.image = loadImageFromPath(imagePath)
                }
            } else { print("some error message 2") }
            
            
        } else {
            let checked_url = legoSet.valueForKey("img_tn") as? String
            if let checkedUrl = NSURL(string: "\(checked_url)") {
                cell.photoImageView.contentMode = .ScaleAspectFit
            
                getDataFromUrl(checkedUrl) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        
                        cell.photoImageView.image = UIImage(data: data)
                    }
                }
            }
        }

        cell.descriptionLabel.text = legoSet.valueForKey("descr") as? String
        
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
            
            let managedObject:NSManagedObject = fetchedResultController.objectAtIndexPath(indexPath) as! NSManagedObject
            managedObjectContext.deleteObject(managedObject)
            do {
                try managedObjectContext.save()
            } catch _ {
            }

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    // MARK: - TableView Refresh
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
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
            
            //          let cell = sender as! UITableViewCell
            let legoSetViewController:LegoSetViewController = segue.destinationViewController as! LegoSetViewController
            let legoSet:LegoSets = fetchedResultController.objectAtIndexPath(indexPath!) as! LegoSets
            legoSetViewController.legoSet = legoSet
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
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        var image = UIImage()
        let data = NSData(contentsOfFile: path)
        if (data != nil) {
            image = UIImage(data: data!)!
        } else {
        }
        return image
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
