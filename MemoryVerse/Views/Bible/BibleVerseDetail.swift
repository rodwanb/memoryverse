//
//  VerseDetail.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/17.
//

import SwiftUI

struct BibleVerseDetail: View {
    
    var verses: [Bible.Verse]
    
    @EnvironmentObject private var folder: Folder
    @Environment(\.customDismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    private func add() {
        guard let verse = verses.first else {
            return
        }
        
        let verseToAdd = Verse(context: viewContext)
        let reference = "\(verse.bookName) \(verse.chapterNumber):\(verseNumbers)"
        verseToAdd.reference = reference
        verseToAdd.text = passage
        
        folder.addToVerses(verseToAdd)
                
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                dismiss?()
            } catch {
                print(error)
            }
        }
    }
    
    var passage: String {
        verses.reduce(into: "") { partialResult, current in
            partialResult = partialResult + " \(current.text)"
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
                Text(passage)
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

extension String {
    func removing(prefixes: [String]) -> String {
        var resultString = self
        _ = prefixes.map {
            if resultString.hasPrefix($0) {
                resultString = resultString.dropFirst($0.count).description
            }
        }
        return resultString
    }
}

struct CustomDismissAction {
    typealias Action = () -> ()
    let action: Action
    func callAsFunction() {
        action()
    }
}

struct CustomDismissActionKey: EnvironmentKey {
    static var defaultValue: CustomDismissAction? = nil
}

extension EnvironmentValues {
    var customDismiss: CustomDismissAction? {
        get { self[CustomDismissActionKey.self] }
        set { self[CustomDismissActionKey.self] = newValue }
    }
}

extension View {
    func onCustomDismiss(_ action: @escaping CustomDismissAction.Action) -> some View {
        self.environment(\.customDismiss, CustomDismissAction(action: action))
    }
}
