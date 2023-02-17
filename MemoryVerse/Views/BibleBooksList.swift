//
//  BibleBooksList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleBooksList: View {
    
    @StateObject private var bibleModel = BibleModel()
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(bibleModel.books) { book in
                    NavigationLink(value: book) {
                        Text(book.longName)
                    }
                }
            }
            .navigationDestination(for: Bible.Book.self) { book in
                BibleChapterList(book: book)
            }
            .navigationTitle("Bible")
        }
        .task {
            if bibleModel.books.isEmpty {
                bibleModel.load()
            }
        }
    }
}

struct BibleBooksList_Previews: PreviewProvider {
    static var previews: some View {
        BibleBooksList()
    }
}
