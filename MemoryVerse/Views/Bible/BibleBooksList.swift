//
//  BibleBooksList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleBooksList: View {
    
    @EnvironmentObject private var store: BibleStore
    @State private var searchText: String = ""
    
    private var filteredBooks: [Bible.Book] {
        if searchText.isEmpty {
            return store.bible.books
        } else {
            return store.bible.books.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.bible.books, id: \.self) { book in
                    NavigationLink(value: book) {
                        Text(book.name)
                    }
                }
            }
            .navigationDestination(for: Bible.Book.self) { book in
                BibleChapterList(book: book)
            }
            .searchable(text: $searchText, prompt: "Search")
        }
        .task {
            if store.bible.books.isEmpty {
                await store.load()
            }
        }
    }
}

struct BibleBooksList_Previews: PreviewProvider {
    static var previews: some View {
        BibleBooksList()
    }
}
