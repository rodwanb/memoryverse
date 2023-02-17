//
//  BibleVerseList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleVerseList: View {
    
    var chapter: Bible.Chapter
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(chapter.verses) { verse in
                    NavigationLink(value: verse) {
                        Text("\(verse.number)")
                            .font(.title2)
                            .bold()
                            .frame(width: 60, height: 60)
                    }
                    .tint(.primary)
                }
            }
            .padding()
        }
        .navigationDestination(for: Bible.Verse.self) { verse in
            BibleVerseDetail(verse: verse)
        }
        .navigationTitle("\(chapter.bookName) \(chapter.number)")
    }
}

struct BibleVerseList_Previews: PreviewProvider {
    static var previews: some View {
        let model = BibleModel()
        model.load()
        
        let book = model.books[0]
        let chapter = book.chapters[0]
        
        return NavigationStack {
            BibleVerseList(chapter: chapter)
        }
    }
}
