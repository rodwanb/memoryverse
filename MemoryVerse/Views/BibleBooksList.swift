//
//  BibleBooksList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleBooksList: View {
    
    @StateObject private var bibleModel = BibleModel()
    @State private var searchText: String = ""
    
    private var filteredBooks: [Bible.Book] {
        if searchText.isEmpty {
            return bibleModel.books
        } else {
            return bibleModel.books.filter {
                $0.longName.localizedCaseInsensitiveContains(searchText) ||
                $0.shortName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredBooks) { book in
                    NavigationLink(value: book) {
                        Text(book.longName)
                    }
                }
            }
            .navigationDestination(for: Bible.Book.self) { book in
                BibleChapterList(book: book)
            }
//            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search")
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
