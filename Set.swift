//
//  Profile.swift
//  HomeInventory
//
//  Created by Jason Shultz on 1/2/16.
//  Copyright © 2015 Chaos Elevators, Inc.. All rights reserved.
//

import RealmSwift
import Foundation

class Set: Object {
    
    dynamic var id = NSUUID().UUIDString
    dynamic var set_id = ""
    dynamic var descr = ""
    dynamic var img_sm = ""
    dynamic var img_tn = ""
    dynamic var pieces = ""
    dynamic var qty = ""
    dynamic var year = ""
    
    // Specify properties to ignore (Realm won't persist these)
    
    //  override static func ignoredProperties() -> [String] {
    //    return []
    //  }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}