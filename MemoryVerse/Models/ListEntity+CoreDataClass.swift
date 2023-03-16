//
//  List+CoreDataClass.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/07.
//

import Foundation
import CoreData
import SwiftUI

@objc(ListEntity)
class ListEntity: NSManagedObject {
    
    override func awakeFromInsert() {
        dateCreated = Date()
    }
    
    static let example: ListEntity = {
        let entity = ListEntity(context: CoreDataModel.shared.viewContext)
        entity.name = "Review List"
        entity.hexColor = Color.blue.toHex()
        entity.iconSystemName = "list.bullet"
        entity.addToVerses(.example)
        return entity
    }()
    
    var color: Color {
        guard let hexColor else {
            return .blue
        }
        
        return Color(hex: hexColor) ?? .blue
    }
        
    static var all: NSFetchRequest<ListEntity> {
        let request = ListEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        return request
    }

}
