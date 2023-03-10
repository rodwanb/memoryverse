//
//  BibleChapterList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleChapterList: View {
    
    var book: Bible.Book
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(book.chapters) { chapter in
                    NavigationLink(value: chapter) {
                        Text("\(chapter.number)")
                            .font(.title3)
                            .bold()
                            .frame(width: 60, height: 60)
                    }
                    .tint(.primary)
                }
            }
            .padding()
        }
        .navigationDestination(for: Bible.Chapter.self) { chapter in
            BibleVerseList(chapter: chapter)
        }
        .navigationTitle(book.longName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BibleChapterList_Previews: PreviewProvider {
    static var previews: some View {
        let model = BibleModel()
        model.load()
        
        return NavigationStack {
            BibleChapterList(book: model.books[0])
        }
    }
}
