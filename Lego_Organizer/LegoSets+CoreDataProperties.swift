//
//  LegoSets+CoreDataProperties.swift
//  Lego_Organizer
//
//  Created by Jason Shultz on 2/25/16.
//  Copyright © 2016 HashRocket. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LegoSets {

    @NSManaged var descr: String?
    @NSManaged var img_big: String?
    @NSManaged var img_sm: String?
    @NSManaged var img_tn: String?
    @NSManaged var pieces: NSNumber?
    @NSManaged var qty: NSNumber?
    @NSManaged var set_id: String?
    @NSManaged var theme: String?
    @NSManaged var year: NSNumber?

}
