//
//  AddLegoSetViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/13/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class AddLegoSetViewController: UIViewController {
    
    @IBOutlet weak var setDescription: UITextField!
    
    @IBAction func saveSet(sender: AnyObject) {
        
        createSet("test set", password: "password") { (accessKey) -> () in
            if accessKey != nil {
                print("accessKey: ", accessKey)
            }
        }
        
    
    }
    
    func createSet(username:String, password:String, completionHandler: (String?) -> ()) -> () {
        Alamofire.request(.POST, "https://rebrickable.com/api/set_user_set",
            parameters: [
                "key": "9BUbjlV9IF",
                "hash" : "8d6678c55a5a93393b19fd2f38e44ed1",
                "format": "json",
                "setlist_id": "1",
                "qty": "1",
                "set": "75108-1"
            ]
            )
            .responseString { response in
                
                completionHandler(response.result.value)
                
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
