//
//  CoreDataModel.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/13.
//

import CoreData

class CoreDataModel {
    static let shared = CoreDataModel()
    private var persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MemoryVerseModel")
        persistentContainer.loadPersistentStores { description, error in
            if let error {
                fatalError("Unable to initialize Core Data stack \(error)")
            }
        }
    }
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
