//
//  AddLegoSetViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/13/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData

class AddLegoSetViewController: UIViewController {
    
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
                                
                                print("jsonObj: ", jsonObj)
                                
                                let img_sm_file_name = "\(self.randomStringWithLength(10)).jpg"
                                let img_tn_file_name = "\(self.randomStringWithLength(10)).jpg"
                                let img_bg_file_name = "\(self.randomStringWithLength(10)).jpg"
                                                                
                                let getImageSM =  UIImage(data: NSData(contentsOfURL: NSURL(string:  (jsonObj[0]["img_sm"].string!))!)!)
                                let getImageTN =  UIImage(data: NSData(contentsOfURL: NSURL(string:  (jsonObj[0]["img_tn"].string!))!)!)
                                let getImageBG =  UIImage(data: NSData(contentsOfURL: NSURL(string:  (jsonObj[0]["img_big"].string!))!)!)
                                
                                UIImageJPEGRepresentation(getImageSM!, 100)!.writeToFile(self.fileInDocumentsDirectory("\(img_sm_file_name)"), atomically: true)
                                UIImageJPEGRepresentation(getImageTN!, 100)!.writeToFile(self.fileInDocumentsDirectory("\(img_tn_file_name)"), atomically: true)
                                UIImageJPEGRepresentation(getImageBG!, 100)!.writeToFile(self.fileInDocumentsDirectory("\(img_bg_file_name)"), atomically: true)
                                
                                // Break up the writing blocks into smaller portions
                                // by starting a new transaction
                                for _ in 0..<1 {
                                    
                                    // Add row via dictionary. Property order is ignored.
                                    for _ in 0..<1 {
                                        
                                        var qty:NSNumber = 1
                                        
                                        if (self.setQuantity.text != "") {
                                            qty = Int(self.setQuantity.text!)!
                                        } else {
                                            
                                        }
                                        
                                        let set_id:String = jsonObj[0]["set_id"].string!
                                        let descr:String = jsonObj[0]["descr"].string!
                                        let img_sm:String = img_sm_file_name
                                        let img_tn:String = img_tn_file_name
                                        let img_big:String = img_bg_file_name
                                        let pieces:NSNumber = Int(jsonObj[0]["pieces"].string!)!
                                        let theme:String = jsonObj[0]["theme"].string!
                                        let year:NSNumber = Int(jsonObj[0]["year"].string!)!
                                        
                                        // create an app delegate variable
                                        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                                        
                                        // context is a handler for us to be able to access the database. this allows us to access the CoreData database.
                                        let context: NSManagedObjectContext = appDel.managedObjectContext
                                        
                                        
                                        // see if we are updating a LegoSet or not?
                                        let request = NSFetchRequest(entityName: "LegoSets")
                                        
                                        // if we want to search for something in particular we can use predicates:
                                        request.predicate = NSPredicate(format: "set_id = %@", jsonObj[0]["set_id"].string!) // search for users where username = Steve
                                        
                                        // by default, if we do a request and get some data back it returns false for the actual data. if we want to get data back and see it, then we need to set this as false.
                                        request.returnsObjectsAsFaults = false
                                        
                                        do {
                                            // save the results of our fetch request to a variable.
                                            let results = try context.executeFetchRequest(request)
                                            
                                            if results.count > 0 {
                                                
                                                for result in results as! [NSManagedObject] {
                                                    result.setValue(qty, forKey: "qty")
                                                }
                                                
                                            } else {
                                                // we are describing the Entity we want to insert the new user into. We are doing it for Entity Name Users. Then we tell it the context we want to insert it into, which we described previously.
                                                let newSet = NSEntityDescription.insertNewObjectForEntityForName("LegoSets", inManagedObjectContext: context)
                                                
                                                newSet.setValue(set_id, forKey: "set_id")
                                                newSet.setValue(descr, forKey: "descr")
                                                newSet.setValue(img_sm, forKey: "img_sm")
                                                newSet.setValue(img_tn, forKey: "img_tn")
                                                newSet.setValue(img_big, forKey: "img_big")
                                                newSet.setValue(pieces, forKey: "pieces")
                                                newSet.setValue(qty, forKey: "qty")
                                                newSet.setValue(theme, forKey: "theme")
                                                newSet.setValue(year, forKey: "year")
                                            }
                                            
                                        } catch {
                                            
                                        }
                                        
                                        do {
                                            // save the context.
                                            try context.save()
                                        } catch {
                                            print("There was a problem")
                                        }

                                    }
                                    
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
    
    func fileInDocumentsDirectory(filename: String) -> String {
        return getDocumentsDirectory().stringByAppendingPathComponent(filename)
    }
    
    func getDataFromUrl(url:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    
    func getDocumentsDirectory() -> NSString {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0]
        
        return documentsDirectory
    }
    
    func randomStringWithLength (len : Int) -> NSString {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for (var i=0; i < len; i++){
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.characterAtIndex(Int(rand)))
        }
        
        return randomString
    }
    
    func saveImage (image: UIImage, path: String ) -> String{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        return path
        
    }
    
    func showAlert(errorTitle:String, errorMessage:String) {
        print("in the alert")
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func setupUI() {
        self.view?.backgroundColor = UIColor(red: 0.4471, green: 0.3451, blue: 1, alpha: 1.0) /* #7258ff */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(animated: Bool) {

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
