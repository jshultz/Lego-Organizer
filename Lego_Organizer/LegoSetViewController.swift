//
//  LegoSetViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/13/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import CoreData

class LegoSetViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var legoSet: LegoSets? = nil
    

    @IBOutlet weak var setNumberLabel: UILabel!
    
    @IBOutlet weak var setNameLabel: UILabel!
    
    @IBOutlet weak var setDescriptionLabel: UILabel!
    
    @IBOutlet weak var setImage: UIImageView!
        
    var setId:JSON = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        setupUI()
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
    
    func setupUI() {
        
//        print("self.legoSet? : ", self.legoSet)
        
        self.view?.backgroundColor = UIColor(red: 0.4471, green: 0.3451, blue: 1, alpha: 1.0) /* #7258ff */
        self.setNameLabel.textColor = UIColor.whiteColor()
        self.setDescriptionLabel.textColor = UIColor.whiteColor()
        
        
        self.title = (self.legoSet?.set_id)! + " " + (self.legoSet?.descr)!
        
        self.setNameLabel.text = (self.legoSet?.set_id)! + " " +  (self.legoSet?.descr)!
        
        let pieces:String = String((self.legoSet?.pieces)!)
        
        let year:String = String((self.legoSet?.year)!)
        
        let qty:String = String((self.legoSet?.qty)!)
        
        self.setDescriptionLabel.text = "Set consists of \(pieces) pieces and was first produced in \(year). You currently own \(qty) set(s)."
        
        let imageView = self.setImage as UIImageView
                
        imageView.contentMode = .ScaleAspectFit
        
        let myImageName = self.legoSet?.img_big
        let imagePath = fileInDocumentsDirectory(myImageName!)
        
        let checkImage = NSFileManager.defaultManager()

        
        if (checkImage.fileExistsAtPath(imagePath)) {
            
            if let _ = loadImageFromPath(imagePath) {
                if self.legoSet?.img_sm != "" {
                    imageView.image = loadImageFromPath(imagePath)
                }
            } else { print("some error message 2") }
        
        } else {
            let img_url:String = (self.legoSet?.img_sm)!
            
            if let checkedUrl = NSURL(string: "\(img_url)") {
                imageView.contentMode = .ScaleAspectFit
                
                self.getDataFromUrl(checkedUrl) { (data, response, error)  in
                    dispatch_async(dispatch_get_main_queue()) { () -> Void in
                        guard let data = data where error == nil else { return }
                        
                        imageView.image = UIImage(data: data)
                    }
                }
            }
        }
        
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newPlace" {
            
        } else if segue.identifier == "showSetsPartsList" {
            
            let PartsController:SetsPartsListTableViewController = segue.destinationViewController as! SetsPartsListTableViewController
                        
            let setId = self.legoSet
            
            PartsController.legoSet = setId
        }
        
    }


}
