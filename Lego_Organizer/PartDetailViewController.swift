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
    
    @IBOutlet weak var partIdLabel: UILabel!
    
    @IBOutlet weak var partNameLabel: UILabel!
    
    @IBOutlet weak var partDescriptionLabel: UILabel!
    
    @IBOutlet weak var partImage: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.partIdLabel.text = String(UTF8String: self.partId["part_id"].string!)!
        
//        let pieces:String = String(UTF8String: self.partId["pieces"].string!)!
        
//        let year:String = String(UTF8String: self.partId["year"].string!)!
        
        self.partNameLabel.text = String(UTF8String: self.partId["part_name"].string!)!
        
        let imageView = partImage as UIImageView
        
        let img_url = String(UTF8String: self.partId["part_img_url"].string!)!
        
        if let url = NSURL(string: "\(img_url)") {
            if let data = NSData(contentsOfURL: url) {
                imageView.image = UIImage(data: data)
            }
        }
        
        
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
