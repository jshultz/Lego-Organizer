//
//  ProfileViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/6/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire



class ProfileViewController: UIViewController {
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBAction func btnSave(sender: AnyObject) {
        
    }
    
    @IBOutlet weak var passwordField: UITextField!
    
    
    let realm = try! Realm()
    var profile:Profile? = nil
    var notificationToken: NotificationToken?
    
    var userhash:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getUserHash(username:String, password:String, completionHandler: (String?) -> ()) -> () {
        
        Alamofire.request(.GET, "https://rebrickable.com/api/get_user_hash",
            parameters: ["key": "9BUbjlV9IF", "email" : username, "pass": password, "format": "json"]
            )
            .responseString { response in
                
                completionHandler(response.result.value)
                
        }
        

    }
    
    func setupUI() {
        self.title = "Profile"
        
        if let profile = realm.objects(Profile).first {
            fullName.text = profile.fullName
            emailAddress.text = profile.email
            passwordField.text = profile.password
            
            self.profile = profile
        }
        
    }
    
    @IBAction func saveProfile(sender: AnyObject) {
        
        if (self.profile != nil) {
            let profile = Profile()
            
            profile.id = (self.profile!.id)
            profile.fullName = self.fullName.text!
            profile.email = self.emailAddress.text!
            profile.password = self.passwordField.text!
            
            getUserHash(self.emailAddress.text!, password: self.passwordField.text!, completionHandler: { (accessKey) -> () in
                if accessKey != nil {
                    // Use accessKey however you'd like here
                    
                    profile.userHash = String(accessKey!)
                    
                    try! self.realm.write {
                        self.realm.add(profile, update: true)
                        print("i wrote it")
                    }
                    
                } else {
                    // Handle error / nil accessKey here
                }
            })

            
        } else {
            let profile = Profile()
            
            profile.fullName = self.fullName.text!
            profile.email = self.emailAddress.text!
            profile.password = self.passwordField.text!
            
            getUserHash(self.emailAddress.text!, password: self.passwordField.text!, completionHandler: { (accessKey) -> () in
                if accessKey != nil {
                    // Use accessKey however you'd like here
                    
                    profile.userHash = String(accessKey!)
                    
                    try! self.realm.write {
                        self.realm.add(profile, update: true)
                        print("i wrote it")
                    }
                    
                } else {
                    // Handle error / nil accessKey here
                }
            })
            
        }
        
                performSegueWithIdentifier("showLego", sender: self)
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
