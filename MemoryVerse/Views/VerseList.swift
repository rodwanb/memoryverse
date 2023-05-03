//
//  VerseList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/09.
//

import SwiftUI

struct VerseList: View {
    
    @ObservedObject var folder: Folder
    @Binding var selectedVerse: Verse?
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAddVersePresented: Bool = false
    
    var verses: [Verse] {
        guard let listVerses = folder.verses as? Set<Verse> else {
            return []
        }
        
        return Array(listVerses)
    }
    
    static let dateCreatedFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private func deleteVerse(verse: Verse) {
        viewContext.delete(verse)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    private func add() {
        isAddVersePresented.toggle()
    }
    
    var body: some View {
//        Group {
//            if verses.isEmpty {
//                Text("No Verses")
//                    .foregroundColor(.secondary)
//            } else {
//                List(selection: $selectedVerse) {
//                    ForEach(Array(verses)) { verse in
//                        NavigationLink(value: verse) {
//                            VStack(alignment: .leading) {
//                                HStack {
//                                    Text(verse.reference ?? "")
//                                        .font(.headline)
//
//                                    Spacer()
//
//                                    if let dateCreated = verse.dateCreated {
//                                        Text("\(dateCreated, formatter: Self.dateCreatedFormat)")
//                                            .lineLimit(1)
//                                            .font(.body)
//                                            .foregroundColor(.secondary)
//                                    }
//                                }
//
//                                Text(verse.text ?? "")
//                                    .lineLimit(2)
//                                    .foregroundColor(.secondary)
//                                    .font(.body)
//                            }
////                            .onTapGesture {
////                                selectedVerse = verse
////                            }
//                        }
//                    }
//                    .onDelete { indexSet in
//                        indexSet
//                            .map { verses[$0] }
//                            .forEach(deleteVerse)
//                    }
//                }
////                .navigationDestination(for: Verse.self) { verse in
////                    MemorizeVerse(verse: verse)
////                }
//                .listStyle(.plain)
//            }
//        }
        List(selection: $selectedVerse) {
            ForEach(Array(verses)) { verse in
                NavigationLink(value: verse) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(verse.reference ?? "")
                                .font(.headline)
                            
                            Spacer()
                            
                            if let dateCreated = verse.dateCreated {
                                Text("\(dateCreated, formatter: Self.dateCreatedFormat)")
                                    .lineLimit(1)
                                    .font(.body)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(verse.text ?? "")
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                            .font(.body)
                    }
//                            .onTapGesture {
//                                selectedVerse = verse
//                            }
                }
            }
            .onDelete { indexSet in
                indexSet
                    .map { verses[$0] }
                    .forEach(deleteVerse)
            }
        }
//                .navigationDestination(for: Verse.self) { verse in
//                    MemorizeVerse(verse: verse)
//                }
        .listStyle(.plain)
        .foregroundColor(.secondary)
        .navigationTitle(folder.name ?? "")
//        .navigationBarTitleDisplayMode(.large)
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
                .environmentObject(folder)
                .onCustomDismiss {
                    isAddVersePresented.toggle()
                }
        })

    }
}

//struct VerseList_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            VerseList(list: .example, selectedVerse: .constant(nil))
//        }
//        .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
//    }
//}
