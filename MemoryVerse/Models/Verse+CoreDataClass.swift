//
//  Verse.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/13.
//

import Foundation
import CoreData

@objc(Verse)
class Verse: NSManagedObject {
            
    override func awakeFromInsert() {
        dateCreated = Date()
    }
    
}
