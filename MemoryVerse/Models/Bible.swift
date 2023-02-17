//
//  Book.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/16.
//

import Foundation

enum Bible {
    struct Book: Identifiable, Hashable {
        var id: Int
        var shortName: String
        var longName: String
        var chapters: [Chapter]
    }
    
    struct Chapter: Identifiable, Hashable {
        var id: Int { number }
        var number: Int
        var verses: [Verse]
        var bookName: String
    }

    struct Verse: Identifiable, Hashable {
        var id: Int { number }
        var number: Int
        var text: String
        var bookName: String
        var chapterNumber: Int
    }
}
