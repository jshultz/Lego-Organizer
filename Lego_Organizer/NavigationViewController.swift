//
//  NavigationViewController.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 12/29/15.
//  Copyright © 2015 HashRocket. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationBar.barTintColor = UIColor.blueColor()
//        self.navigationBar.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.navigationBar.tintColor = UIColor.whiteColor()
        self.toolbar.barTintColor = UIColor.blueColor()
        self.toolbar.tintColor = UIColor.whiteColor()
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
