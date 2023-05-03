//
//  Lists.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/25.
//

import SwiftUI

struct Home: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Folder.all) private var folders
    @State private var columnVisible: NavigationSplitViewVisibility = .doubleColumn
    @State private var searchQuery: String = ""
    @State private var showNewList: Bool = false
    @State private var selectedFolder: Folder?
    @State private var selectedVerse: Verse?
        
    private func seedFolderData() {
        let entity = Folder(context: viewContext)
        entity.name = "Verses"
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
        
    private func delete(folder: Folder) {
        viewContext.delete(folder)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedFolder) {
                ForEach(folders) { list in
                    NavigationLink(value: list) {
                        HStack {
                            Image(systemName: "folder")
                                .foregroundColor(.accentColor)
                            
                            Text(list.name ?? "")
                                .lineLimit(1)
                            
                            Spacer()
                            
                            Text("\(list.verses?.count ?? 0)")
                        }
                        .padding(.vertical, 1)
                    }
                }
                .onDelete { indexSet in
                    indexSet
                        .map { folders[$0] }
                        .forEach(delete)
                }
            }
            .navigationTitle("Folders")
            .searchable(text: $searchQuery)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add List") {
                        showNewList.toggle()
                    }
                }
            }
            .sheet(isPresented: $showNewList) {
                AddFolder()
            }
        } content: {
            if let selectedFolder {
                VerseList(folder: selectedFolder, selectedVerse: $selectedVerse)
            } else {
                Text("Select a list")
            }
        } detail: {
            if let selectedVerse {
                MemorizeVerse(verse: selectedVerse)
            } else {
                Text("Select a verse")
            }
        }
        .onAppear {
            if folders.isEmpty {
                seedFolderData()
            }

            if selectedFolder == nil {
                selectedFolder = folders.first
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
    }
}
