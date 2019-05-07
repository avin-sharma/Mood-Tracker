//
//  Entry.swift
//  Mood Tracker
//
//  Created by Avin Sharma on 4/13/19.
//  Copyright © 2019 Avin Sharma. All rights reserved.
//

import Foundation
import RealmSwift
import IceCream

class Entry: Object{
    @objc dynamic var date = Date()
    @objc dynamic var mood = "Happy"
    let activities = List<String>()
    @objc dynamic var isDeleted = false
    @objc dynamic var id = NSUUID().uuidString
    override class func primaryKey() -> String? {
        return "id"
    }
}

extension Entry: CKRecordConvertible, CKRecordRecoverable{
    
}
