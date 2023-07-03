//
//  Folder.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/07/03.
//

import Foundation

struct Folder: Codable, Identifiable, Hashable {
    var id = UUID()
    var dateCreated = Date()
    var name: String
    var verses: [Verse] = []
    
    static let example: Folder = {
        Folder(name: "Review List", verses: [.example])
    }()
}
