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
        
        if self.setId.text != "" {
            Alamofire.request(.GET, "https://rebrickable.com/api/get_set", parameters: [
                "key": "9BUbjlV9IF",
                "set_id": self.setId.text! + "-1",
                "format": "json"]).validate().responseJSON { response in
                    switch response.result {
                    case .Success:
                        if response.result.value != nil {
                            let jsonObj = JSON(response.result.value!)
                            
                            
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                
                                // Get realm and table instances for this thread
                                let realm = try! Realm()
                                
                                let updatedItem = realm.objects(Set).filter(NSPredicate(format: "set_id = %@", "\(self.setId.text!)")).first
                                // Break up the writing blocks into smaller portions
                                // by starting a new transaction
                                for _ in 0..<1 {
                                    realm.beginWrite()
                                    
                                    // Add row via dictionary. Property order is ignored.
                                    for _ in 0..<1 {
                                        
                                        let set_id:String = jsonObj[0]["set_id"].string!
                                        let descr:String = jsonObj[0]["descr"].string!
                                        let img_sm:String = jsonObj[0]["img_sm"].string!
                                        let img_tn:String = jsonObj[0]["img_tn"].string!
                                        let pieces:String = jsonObj[0]["pieces"].string!
                                        let qty:String = self.setQuantity.text!
                                        let theme:String = jsonObj[0]["theme"].string!
                                        let year:String = jsonObj[0]["year"].string!
                                        
                                        if (updatedItem != nil) {
                                            realm.create(Set.self, value: [
                                                "id" : "\(updatedItem!.id)",
                                                "set_id": "\(set_id)",
                                                "descr": "\(descr)",
                                                "img_sm": "\(img_sm)",
                                                "img_tn": "\(img_tn)",
                                                "pieces": "\(pieces)",
                                                "qty": "\(qty)",
                                                "theme": "\(theme)",
                                                "year": "\(year)"
                                                ], update: true)
                                        } else {
                                            realm.create(Set.self, value: [
                                                "set_id": "\(set_id)",
                                                "descr": "\(descr)",
                                                "img_sm": "\(img_sm)",
                                                "img_tn": "\(img_tn)",
                                                "pieces": "\(pieces)",
                                                "qty": "\(qty)",
                                                "theme": "\(theme)",
                                                "year": "\(year)"
                                                ], update: true)
                                        }
                                    }
                                    
                                    // Commit the write transaction
                                    // to make this data available to other threads
                                    try! realm.commitWrite()
                                    self.performSegueWithIdentifier("showLego", sender: self)
                                }
                                
                            })
                        }
                        
                    case .Failure(let error):
                        print(error)
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
    
    
    func setupUI() {
        
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
