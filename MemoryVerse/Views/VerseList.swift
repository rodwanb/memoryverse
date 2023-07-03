//
//  VerseList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/09.
//

import SwiftUI

struct VerseList: View {
    
    @EnvironmentObject private var store: BibleStore
        
    var folder: Folder
    @Binding var selectedVerse: Verse?
    @State private var isAddVersePresented: Bool = false
        
    static let dateCreatedFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private func deleteVerse(verse: Verse) {
//        viewContext.delete(verse)
//        do {
//            try viewContext.save()
//        } catch {
//            print(error)
//        }
    }
    
    private func add() {
        isAddVersePresented.toggle()
    }
    
    var body: some View {
        List(selection: $selectedVerse) {
            ForEach(folder.verses) { verse in
                NavigationLink(value: verse) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(verse.reference)
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("\(verse.dateCreated, formatter: Self.dateCreatedFormat)")
                                .lineLimit(1)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(verse.text)
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
                }
            }
            .onDelete { indexSet in
                indexSet
                    .map { folder.verses[$0] }
                    .forEach(deleteVerse)
            }
        }
        .navigationTitle(folder.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    print("show context menu")
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
            
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button(action: add) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Verse")
                                .font(.system(.body, design: .rounded, weight: .medium))
                        }
                    }
                    
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $isAddVersePresented, content: {
            BibleBooksList()
                .environmentObject(store)
                .onCustomDismiss {
                    isAddVersePresented.toggle()
                }
        })
    }
}

struct VerseList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VerseList(folder: .example, selectedVerse: .constant(nil))
        }
        .environmentObject(BibleStore())
    }
}
