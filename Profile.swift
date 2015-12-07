//
//  Profile.swift
//  HomeInventory
//
//  Created by Jason Shultz on 11/18/15.
//  Copyright © 2015 Chaos Elevators, Inc.. All rights reserved.
//

import RealmSwift
import Foundation

class Profile: Object {
    
    dynamic var id = NSUUID().UUIDString
    dynamic var fullName = ""
    dynamic var email = ""
    dynamic var apiKey = ""
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}