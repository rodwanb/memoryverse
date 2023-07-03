//
//  FolderList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/05/03.
//

import SwiftUI

struct FolderList: View {
    
    @EnvironmentObject private var store: BibleStore
    
    @Binding var selectedFolder: Folder?
        
    @State private var showNewList: Bool = false
    @State private var searchQuery: String = ""
    @State private var folderName: String = ""
    @AppStorage("dataSeeded.folders") private var dataSeeded: Bool = false

    private func seedFolderData() {
        store.addFolder(name: "Verses")
        dataSeeded = true
    }
    
    private func delete(folder: Folder) {
        store.deleteFolder(folder: folder)
    }
    
    private func addFolder() {
        store.addFolder(name: folderName)
        folderName = ""
    }
    
    var body: some View {
        List(selection: $selectedFolder) {
            ForEach(store.folders) { list in
                NavigationLink(value: list) {
                    HStack {
                        Image(systemName: "folder")
                            .foregroundColor(.accentColor)
                        
                        Text(list.name)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        Text("\(list.verses.count)")
                    }
                    .padding(.vertical, 1)
                }
            }
            .onDelete { indexSet in
                indexSet
                    .map { store.folders[$0] }
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
                Button {
                    showNewList.toggle()
                } label: {
                    Image(systemName: "folder.badge.plus")
                }
            }
        }
        .alert("New Folder", isPresented: $showNewList, actions: {
            TextField("Name", text: $folderName)
            Button("Save", action: addFolder)
            Button("Cancel", role: .cancel, action: { folderName = "" })
        }, message: {
            Text("Enter a name for this folder.")
        })
        .onAppear {
            if !dataSeeded && store.folders.isEmpty {
                seedFolderData()
            }
        }
    }
}

struct FolderList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FolderList(selectedFolder: .constant(nil))
        }
        .environmentObject(BibleStore())
    }
}
