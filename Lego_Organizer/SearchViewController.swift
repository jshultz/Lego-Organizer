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


class SearchViewController: UIViewController {
    
    let results:NSArray = []
    
    @IBOutlet var resultsTable: UITableView!
    
    @IBOutlet var searchInput: UITextField!
    
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
                "format": "json"]).validate().responseJSON { response in
                    switch response.result {
                    case .Success:
                        if response.result.value != nil {
                            let jsonObj = JSON(response.result.value!)
                            print("jsonObj: ", jsonObj)
                        }
                    case .Failure(let error):
                        print(error)
                    }
            }
            
            }
        }
    
    
    func setupUI() {
        self.title = "Search"
        print("here i am")
    }
    

}
