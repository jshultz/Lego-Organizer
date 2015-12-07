//
//  ProfileViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/6/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit
import RealmSwift


class ProfileViewController: UIViewController {
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var apiKey: UITextField!
    
    @IBAction func btnSave(sender: AnyObject) {
        if (self.profile != nil) {
            let profile = Profile()
            
            profile.id = (self.profile!.id)
            profile.fullName = self.fullName.text!
            profile.email = self.emailAddress.text!
            profile.apiKey = self.apiKey.text!
            
            try! realm.write {
                self.realm.add(profile, update: true)
                print("i wrote it")
            }
            
        } else {
            let profile = Profile()
            
            profile.fullName = self.fullName.text!
            profile.email = self.emailAddress.text!
            profile.apiKey = self.apiKey.text!
            
            try! realm.write {
                self.realm.add(profile)
            }
        }
        
//        performSegueWithIdentifier("showProfile", sender: self)
    }
    
    
    
    let realm = try! Realm()
    var profile:Profile? = nil
    var notificationToken: NotificationToken?

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
    
    func setupUI() {
        self.title = "Profile"
        
        if let profile = realm.objects(Profile).first {
            fullName.text = profile.fullName
            emailAddress.text = profile.email
            apiKey.text = profile.apiKey
            
            self.profile = profile
        }
        
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
