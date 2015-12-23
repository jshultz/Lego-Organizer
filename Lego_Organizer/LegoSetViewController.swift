//
//  LegoSetViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/13/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class LegoSetViewController: UIViewController {
    

    @IBOutlet weak var setNumberLabel: UILabel!
    
    @IBOutlet weak var setNameLabel: UILabel!
    
    @IBOutlet weak var setDescriptionLabel: UILabel!
    
    @IBOutlet weak var setImage: UIImageView!
        
    var setId:JSON = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("setId: ", self.setId)
        
        self.setNumberLabel.text = String(UTF8String: self.setId["set_id"].string!)!
        
        self.setNameLabel.text = String(UTF8String: self.setId["descr"].string!)!
        
        let pieces:String = String(UTF8String: self.setId["pieces"].string!)!
        
        let year:String = String(UTF8String: self.setId["year"].string!)!
        
        self.setDescriptionLabel.text = "Set consists of \(pieces) pieces and was first produced in \(year)."
        
        let imageView = setImage as UIImageView
        
        let img_url = String(UTF8String: self.setId["img_sm"].string!)!
        
        if let url = NSURL(string: "\(img_url)") {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "newPlace" {
            
        } else if segue.identifier == "showSetsPartsList" {
            
            let PartsController:SetsPartsListTableViewController = segue.destinationViewController as! SetsPartsListTableViewController
            
            //            print("activeSet: ", self.datas[activeSet])
            
            let setId = self.setId
            
            PartsController.setId = setId
        }
        
    }


}
