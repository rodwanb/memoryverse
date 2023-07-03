//
//  Verse.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/07/03.
//

import Foundation

struct Verse: Codable, Identifiable, Hashable {
    var id = UUID()
    var dateCreated = Date()
    var reference: String
    var text: String
    
    static let example: Verse = {
        Verse(reference: "Proverbs 22:7", text: "The rich rule over the poor, and the borrower is slave to the lender.")
    }()
}
