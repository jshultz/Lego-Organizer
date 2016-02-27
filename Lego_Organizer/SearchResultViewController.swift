//
//  SearchResultViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 2/20/16.
//  Copyright © 2016 HashRocket. All rights reserved.
//

import UIKit
import SwiftyJSON
import CoreData

class SearchResultViewController: UIViewController {
    
    var legoSet:JSON = []
    
    @IBOutlet var setNameLabel: UILabel!
    
    @IBOutlet var setDescriptionLabel: UILabel!
    
    @IBOutlet var setImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        print("legoSet: ", legoSet)
        
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        
        self.view?.backgroundColor = UIColor(red: 0.4471, green: 0.3451, blue: 1, alpha: 1.0) /* #7258ff */
        self.setNameLabel.textColor = UIColor.whiteColor()
        self.setDescriptionLabel.textColor = UIColor.whiteColor()
        
        self.setNameLabel.text = "\(self.legoSet["set_id"].string!) \(self.legoSet["descr"].string!)"
        
        self.setDescriptionLabel.text = "The \(self.legoSet["descr"].string!) originally appeared in 2009 and is part of the \(self.legoSet["theme2"].string!) theme. It contains \(self.legoSet["pieces"].string!) pieces."
        
        if let checkedUrl = NSURL(string: "\(self.legoSet["img_big"].string!)") {
            self.setImage.contentMode = .ScaleAspectFit
            
            getDataFromUrl(checkedUrl) { (data, response, error)  in
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    guard let data = data where error == nil else { return }
                    
                    self.setImage.image = UIImage(data: data)
                }
            }
        }
    }
    
    
    @IBAction func addSet(sender: AnyObject) {
        let img_sm_file_name = "\(self.randomStringWithLength(10)).jpg"
        let img_tn_file_name = "\(self.randomStringWithLength(10)).jpg"
        let img_bg_file_name = "\(self.randomStringWithLength(10)).jpg"
        
        let getImageSM =  UIImage(data: NSData(contentsOfURL: NSURL(string:  (self.legoSet["img_sm"].string!))!)!)
        let getImageTN =  UIImage(data: NSData(contentsOfURL: NSURL(string:  (self.legoSet["img_tn"].string!))!)!)
        let getImageBG =  UIImage(data: NSData(contentsOfURL: NSURL(string:  (self.legoSet["img_big"].string!))!)!)
        
        UIImageJPEGRepresentation(getImageSM!, 100)!.writeToFile(self.fileInDocumentsDirectory("\(img_sm_file_name)"), atomically: true)
        UIImageJPEGRepresentation(getImageTN!, 100)!.writeToFile(self.fileInDocumentsDirectory("\(img_tn_file_name)"), atomically: true)
        UIImageJPEGRepresentation(getImageBG!, 100)!.writeToFile(self.fileInDocumentsDirectory("\(img_bg_file_name)"), atomically: true)
        
        
        let set_id:String = self.legoSet["set_id"].string!
        
        // Break up the writing blocks into smaller portions
        // by starting a new transaction
        for _ in 0..<1 {
            
            // Add row via dictionary. Property order is ignored.
            for _ in 0..<1 {
                
                let set_id:String = self.legoSet["set_id"].string!
                let descr:String = self.legoSet["descr"].string!
                let img_sm:String = img_sm_file_name
                let img_tn:String = img_tn_file_name
                let img_big:String = img_bg_file_name
                let pieces:NSNumber = Int(self.legoSet["pieces"].string!)!
                let qty:NSNumber = 1
                let theme:String = self.legoSet["theme2"].string!
                let year:NSNumber = Int(self.legoSet["year"].string!)!
                
                // create an app delegate variable
                let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                
                // context is a handler for us to be able to access the database. this allows us to access the CoreData database.
                let context: NSManagedObjectContext = appDel.managedObjectContext
                
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
                
                do {
                    // save the context.
                    try context.save()
                } catch {
                    print("There was a problem")
                }
            }
            
            self.performSegueWithIdentifier("showLego", sender: self)
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

}
