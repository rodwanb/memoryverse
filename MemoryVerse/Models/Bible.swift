//
//  Book.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/16.
//

import Foundation

// MARK: - Bible
struct Bible: Codable, Hashable {
    let version: String
    let books: [Book]
    
    static var empty: Bible = Bible(version: "", books: [])
    
    // MARK: - Book
    struct Book: Codable, Hashable {
        let name: String
        let chapters: [Chapter]
    }

    // MARK: - Chapter
    struct Chapter: Codable, Hashable {
        let verses: [Verse]
        let num: Int
    }

    // MARK: - Verse
    struct Verse: Codable, Hashable {
        let text: String
        let num: Int
    }
}


