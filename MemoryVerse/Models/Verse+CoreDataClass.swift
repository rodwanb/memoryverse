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
    
    static let example: Verse = {
        let verse = Verse(context: CoreDataModel.shared.viewContext)
        verse.reference = "Proverbs 22:7"
        verse.text = "The rich rule over the poor, and the borrower is slave to the lender."
        return verse
    }()
        
    static var all: NSFetchRequest<Verse> {
        let request = Verse.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }
    
    static func filtered(searchText: String) -> NSFetchRequest<Verse> {
        let request = Verse.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        request.predicate = NSPredicate(format: "text CONTAINS[cd] %@ || reference CONTAINS[cd] $@", searchText, searchText)
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
