//
//  VersePack.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/13.
//

import SwiftUI

struct VersePack: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var verses: FetchedResults<Verse>
    
    @State private var isAddVersePresented: Bool = false

    private func deleteVerse(verse: Verse) {
        viewContext.delete(verse)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                if verses.isEmpty {
                    Text("No memory verses exist.")
                } else {
                    ForEach(verses) { verse in
                        NavigationLink(value: verse) {
                            Text(verse.reference ?? "")
                        }
                    }
                    .onDelete { indexSet in
                        indexSet
                            .map { verses[$0] }
                            .forEach(deleteVerse)
                    }
                }
            }
            .navigationDestination(for: Verse.self) { verse in
                FlashCard(verse: verse)
            }
            .navigationTitle("Verse Pack")
            .sheet(isPresented: $isAddVersePresented, content: {
                AddVerse()
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Verse") {
                        isAddVersePresented = true
                    }
                }
            }
        }
    }
}

struct VersePack_Previews: PreviewProvider {
    static var previews: some View {
        VersePack()
    }
}
