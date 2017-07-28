//
//  Item+CoreDataClass.swift
//  DreamLister
//
//  Created by LALIT JAGTAP on 7/26/17.
//  Copyright © 2017 LALIT JAGTAP. All rights reserved.
//

import Foundation
import CoreData

@objc(Item)
public class Item: NSManagedObject {
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
