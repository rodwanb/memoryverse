//
//  BibleModel.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/15.
//

import Foundation
import SQLite

@MainActor final class BibleModel: ObservableObject {
    
    @Published private(set) var books: [Bible.Book] = []
    
    func load() {
        do {
            let fileURL = Bundle.main.path(forResource: "KJ21", ofType: "SQLite3")!
            let db = try Connection (fileURL, readonly: true)
            
            let books = Table("books")
            let bookNumber = Expression<Int>("book_number")
            let shortName = Expression<String>("short_name")
            let longName = Expression<String>("long_name")
                
            let verses = Table("verses")
            let chapter = Expression<Int>("chapter")
            let verse = Expression<Int>("verse")
            let text = Expression<String>("text")
            
            for record in try db.prepare(books) {
                var chapters: [Bible.Chapter] = []
                let queryChapters = verses
                    .where(bookNumber == record[bookNumber])
                    .group(chapter)
                for chapterRow in try db.prepare(queryChapters) {
                    var versesForChapter: [Bible.Verse] = []
                    let verseQuery = verses
                        .where(bookNumber == record[bookNumber] && chapter == chapterRow[chapter])
                    for verseRow in try db.prepare(verseQuery) {
                        let bibleVerse = Bible.Verse(
                            number: verseRow[verse],
                            text: verseRow[text],
                            bookName: record[longName],
                            chapterNumber: chapterRow[chapter])
                        versesForChapter.append(bibleVerse)
                    }
                    let bibleChapter = Bible.Chapter(
                        number: chapterRow[chapter],
                        verses: versesForChapter,
                        bookName: record[longName])
                    chapters.append(bibleChapter)
                }
                let book = Bible.Book(
                    id: record[bookNumber],
                    shortName: record[shortName],
                    longName: record[longName],
                    chapters: chapters
                )
                self.books.append(book)
            }
        } catch {
            print(error)
        }
    }
}
