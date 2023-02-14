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
    
//    var words: [Word] = []
    
    static var all: NSFetchRequest<Verse> {
        let request = Verse.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }
    
    static func byId(_ id: NSManagedObjectID) -> Verse {
        let context = CoreDataModel.shared.viewContext
        guard let verse = context.object(with: id) as? Verse else {
            fatalError("Id not found")
        }
        return verse
    }
    
}
