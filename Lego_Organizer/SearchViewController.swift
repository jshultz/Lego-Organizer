//
//  SearchViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 2/15/16.
//  Copyright © 2016 HashRocket. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var results:JSON = []
    
    @IBOutlet var resultsTable: UITableView!
    
    @IBOutlet var searchInput: UITextField!
    
    @IBOutlet var searchButtonStyle: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButton(sender: AnyObject) {
        
        if self.searchInput.text != "" {
            Alamofire.request(.GET, "https://rebrickable.com/api/search", parameters: [
                "key": "9BUbjlV9IF",
                "query": self.searchInput.text!,
                "type": "S",
                "format": "json"]).validate().responseJSON { response in
                    switch response.result {
                    case .Success:
                        if response.result.value != nil {
                            let jsonObj = JSON(response.result.value!)
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                
                                if let data:JSON = JSON(jsonObj["results"].arrayValue) {
                                    self.results = data
                                    self.resultsTable.reloadData()
                                }
                                
                            })
                            
                            
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
            
            }
        }
    
    
    func setupUI() {
        self.title = "Search"
        self.resultsTable.delegate = self
        self.resultsTable.dataSource = self
        self.resultsTable.backgroundColor = UIColor(red: 0.2706, green: 0.3412, blue: 0.9098, alpha: 1.0) /* #4557e8 */
        self.resultsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view?.backgroundColor = UIColor(red: 0.4471, green: 0.3451, blue: 1, alpha: 1.0) /* #7258ff */
        self.searchButtonStyle.tintColor = UIColor.whiteColor()
    }
    
    // MARK:  UITextFieldDelegate Methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ResultTableViewCell"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ResultTableViewCell
        
        cell.backgroundColor = UIColor(red: 0.2941, green: 0.5608, blue: 1, alpha: 1.0) /* #4b8fff */

        
        let object = results[indexPath.row]
        
//        print("object: ", object)
        
        cell.idLabel.text = object["set_id"].string
        
        cell.titleLabel.text = object["descr"].string
        
        cell.partImageView.contentMode = .ScaleAspectFit
        
        let imageView = UIImageView(frame: CGRectMake(10, 10, cell.frame.width - 10, cell.frame.height - 10))
        
        imageView.contentMode = .ScaleAspectFit
                
        if let checkedUrl = NSURL(string: "\(object["img_tn"].string!)") {
            cell.partImageView.contentMode = .ScaleAspectFit
            
            getDataFromUrl(checkedUrl) { (data, response, error)  in
                
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    
                    cell.partImageView.image = UIImage(data: data)
                }
            }
        }
        
        return cell
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showLego" {
            let searchResultController = segue.destinationViewController as! SearchResultViewController
            let indexPath = resultsTable.indexPathForSelectedRow!
            let legoSet = results[indexPath.row]
            searchResultController.legoSet = legoSet
            let destinationTitle = legoSet["descr"].string!
            searchResultController.title = destinationTitle
            
            
        }
    }
    

}
