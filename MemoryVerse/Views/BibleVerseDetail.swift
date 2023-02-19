//
//  VerseDetail.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleVerseDetail: View {
    
    var verse: Bible.Verse
    
    @Environment(\.customDismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    private func add() {
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
    
    var body: some View {
        ScrollView {
            VStack {
                Text(verse.text)
                Spacer()
            }
        }
        .padding()
        .navigationTitle("Verse \(verse.number)")
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
            BibleVerseDetail(verse: verse)
        }
    }
}
