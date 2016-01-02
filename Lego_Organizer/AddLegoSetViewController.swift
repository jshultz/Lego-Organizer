//
//  AddLegoSetViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/13/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class AddLegoSetViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let realm = try! Realm()
    
    var profile:Profile? = nil
    
    var apiKey:String = ""
    
    var pickerData = [Int: String]()
    
    var listID:Int = 1
    
    @IBOutlet weak var setListPicker: UIPickerView!
    
    
    @IBOutlet weak var setId: UITextField!
    @IBOutlet weak var setQuantity: UITextField!
    
    @IBOutlet weak var setList: UITextField!
    
    
    @IBAction func saveSet(sender: AnyObject) {
        
        createSet("test set", password: "password") { (responeValue) -> () in
            
            if responeValue != nil {
                let temp:String = String(UTF8String: responeValue!)!
                switch String(temp) {
                case "NOSET":
                    self.showAlert("Error", errorMessage: "No set exists with that id. Should be in ####-# format.")
                     print("NOSET: ", String(temp))
                case "SUCCESS":
                    self.performSegueWithIdentifier("showLego", sender: self)
                default:
                    print("default: ", String(temp))
                }
                
            }
        }
        
    }
    
    func showAlert(errorTitle:String, errorMessage:String) {
        print("in the alert")
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createSet(username:String, password:String, completionHandler: (String?) -> ()) -> () {
        
        if let profile = realm.objects(Profile).first {
            self.profile = profile
        }
        
        Alamofire.request(.POST, "https://rebrickable.com/api/set_user_set",
            parameters: [
                "key": "9BUbjlV9IF",
                "hash" : (profile?.userHash)!,
                "format": "json",
                "setlist_id": "1",
                "qty": setQuantity.text!,
                "set": setId.text!
            ]
            )
            .responseString { response in
                
                completionHandler(response.result.value)
                
        }
    }
    

    func setupUI() {
        
        if let profile = realm.objects(Profile).first {
            self.profile = profile
        }
        
        if profile?.userHash != "" {
            
            Alamofire.request(.GET, "https://rebrickable.com/api/get_user_setlists", parameters: [
                "key": "9BUbjlV9IF",
                "hash" : (profile?.userHash)!,
                "format": "json"]).validate().responseJSON { response in
                    switch response.result {
                    case .Success:
                        if response.result.value != nil {
                            let jsonObj = JSON(response.result.value!)
                            
                            if let items = jsonObj["sets"].array {
                                for item in items {
                                    if let setlist_id = item["setlist_id"].string {
                                        self.pickerData[Int(item["setlist_id"].string!)!] = String(item["name"].string!)
                                    }
                                }
                                self.setListPicker.delegate = self
                                self.setListPicker.dataSource = self
                                self.setListPicker.selectRow(1, inComponent: 0, animated: true)
                                self.setList.text = String(UTF8String: self.pickerData[1]!)!
                            }
                        }
                        
                    case .Failure(let error):
                        print(error)
                    }
            }
            
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        setListPicker.hidden = true
        
//        self.view.addSubview(pickerView)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    // Catpure the picker view selection
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // This method is triggered whenever the user makes a change to the picker selection.
        // The parameter named row and component represents what was selected.
        self.setList.text = self.pickerData[row]
//        print("self.pickerData: ", self.pickerData)
        self.listID = Int(row)
//        print("row: ", row )
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
