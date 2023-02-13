//
//  Verse.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/13.
//

import Foundation

struct Verse: Hashable, Identifiable {
        
    var reference: String
    var text: String
    var dateCreated: Date = Date()
    var id: Int { hashValue }
    
    static var all: [Verse] {[
        Verse(
            reference: "Mark 8:36-37 NKJV",
            text: "For what will it profit a man if he gains the whole world, and loses his own soul? Or what will a man give in exchange for his soul?"
        ),
        Verse(
            reference: "John 10:10 NKJV",
            text: "The thief does not come except to steal, and to kill, and to destroy. I have come that they may have life, and that they may have it more abundantly."
        ),
        Verse(
            reference: "Jeremiah 31:3 NKJV",
            text: "The Lord has appeared of old to me, saying: “Yes, I have loved you with an everlasting love; Therefore with lovingkindness I have drawn you."
        )
    ]}
}
