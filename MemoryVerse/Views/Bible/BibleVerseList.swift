//
//  BibleVerseList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleVerseList: View {
    
    var chapter: Bible.Chapter
    
    @State private var selectedVerses: [Bible.Verse] = []
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(chapter.verses, id: \.self) { verse in
                    Button {
                        if selectedVerses.contains(verse) {
                            selectedVerses.removeAll { val in
                                val == verse
                            }
                        } else {
                            selectedVerses.append(verse)
                        }
//                        selectedVerses.sort { lhs, rhs in
//                            lhs.number < rhs.number
//                        }
                    } label: {
                        Text("\(verse.num)")
                            .font(.title3)
                            .fontWeight(selectedVerses.contains(verse) ? .bold : .regular)
                            .frame(width: 60, height: 60)
                    }
                    .tint(.primary)
                }
            }
            .padding()
        }
        .navigationDestination(for: [Bible.Verse].self) { verses in
            BibleVerseDetail(verses: verses)
        }
        .navigationTitle("Book name \(chapter.num)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(value: selectedVerses) {
                    Text("Done")
                }
                .disabled(selectedVerses.isEmpty)
            }
        }
    }
}

struct BibleVerseList_Previews: PreviewProvider {
    static var previews: some View {
        let model = BibleStore()
        Task {
            await model.load()
        }
        
        let book = model.bible.books[0]
        let chapter = book.chapters[0]
        
        return NavigationStack {
            BibleVerseList(chapter: chapter)
        }
    }
}
