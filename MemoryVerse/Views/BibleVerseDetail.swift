//
//  VerseDetail.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleVerseDetail: View {
    
    var verses: [Bible.Verse]
    
    @Environment(\.customDismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    private func add() {
        guard let verse = verses.first else {
            return
        }
        
        let verseToAdd = Verse(context: viewContext)
        let reference = "\(verse.bookName) \(verse.chapterNumber):\(verse.number)"
        verseToAdd.reference = reference
        verseToAdd.text = verse.text
                
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                dismiss?()
            } catch {
                print(error)
            }
        }
    }
    
    var verseNumbers: String {
        let verses = verses.reduce(into: "") { partialResult, current in
            partialResult = partialResult + "\(current.number), "
        }
        return String(verses.dropLast(2))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                let fullVerse = verses.reduce(into: "") { partialResult, current in
                    partialResult = partialResult + " \(current.text)"
                }
                Text(fullVerse)
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Verses \(verseNumbers)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save", action: add)
            }
        }
    }
}

struct VerseDetail_Previews: PreviewProvider {
    static var previews: some View {
        let model = BibleModel()
        model.load()
        
        let book = model.books[0]
        let chapter = book.chapters[0]
        let verse = chapter.verses[0]
        
        return NavigationStack {
            BibleVerseDetail(verses: [verse])
        }
    }
}
