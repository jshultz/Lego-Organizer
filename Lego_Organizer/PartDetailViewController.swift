//
//  PartDetailViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/13/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift
import SwiftyJSON
import Alamofire

class PartDetailViewController: UIViewController {
    
    var partId:JSON = nil
    
    let legoSet:Set? = nil
    
    @IBOutlet weak var partIdLabel: UILabel!
    
    @IBOutlet weak var partNameLabel: UILabel!
    
    @IBOutlet weak var partImage: UIImageView!
    
    @IBOutlet weak var partDescription: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        
        if self.partId != nil {
            Alamofire.request(.GET, "https://rebrickable.com/api/get_part", parameters: ["key": "9BUbjlV9IF", "part_id" : String(UTF8String: self.partId["part_id"].string!)!, "format": "json"]).validate().responseJSON { response in
                switch response.result {
                case .Success:
                    if response.result.value != nil {
                        let jsonObj = JSON(response.result.value!)
                                                
                        self.partIdLabel.text = String(UTF8String: self.partId["part_id"].string!)!
                        
                        self.partNameLabel.text = String(UTF8String: self.partId["part_name"].string!)!
                        
                        let imageView = self.partImage as UIImageView
                        
                        let img_url = String(UTF8String: self.partId["part_img_url"].string!)!
                        
                         if let url = NSURL(string: "\(img_url)") {
                         if let data = NSData(contentsOfURL: url) {
                                        imageView.image = UIImage(data: data)
                                }
                         }
                        
                        let year1:String = jsonObj["year1"].string!
                        let year2:String = jsonObj["year2"].string!
                        
                        self.partDescription.text = "Originally made in \(year1) and continued to be made through \(year2)."
                        
                    }
                    
                case .Failure(let error):
                    print(error)
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
            
        } else if segue.identifier == "showPartVariants" {
            
            let partVariantController:PartVariantsTableViewController = segue.destinationViewController as! PartVariantsTableViewController
            
//            print("activeSet: ", self.datas[activeSet])
            
            let partId = self.partId
            
            partVariantController.partId = partId
        }
        
        
    }


}
