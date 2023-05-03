//
//  List+CoreDataClass.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/07.
//

import Foundation
import CoreData
import SwiftUI

@objc(Folder)
class Folder: NSManagedObject {
    
    override func awakeFromInsert() {
        dateCreated = Date()
    }
    
    static let example: Folder = {
        let entity = Folder(context: CoreDataModel.shared.viewContext)
        entity.name = "Review List"
        entity.addToVerses(.example)
        return entity
    }()
            
    static var all: NSFetchRequest<Folder> {
        let request = Folder.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }
}
