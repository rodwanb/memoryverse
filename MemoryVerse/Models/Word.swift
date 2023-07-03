//
//  Word.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import Foundation

struct Word: Codable, Identifiable, Equatable {
    var id = UUID()
    var text: String
    var hidden: Bool = false
    var review: Bool = false
}
