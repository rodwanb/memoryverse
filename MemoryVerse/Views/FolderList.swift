//
//  FolderList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/05/03.
//

import SwiftUI

struct FolderList: View {
    
    @Binding var selectedFolder: Folder?

    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Folder.all) private var folders
        
    @State private var showNewList: Bool = false
    @State private var searchQuery: String = ""
    @State private var folderName: String = ""
    @AppStorage("dataSeeded.folders") private var dataSeeded: Bool = false

    private func seedFolderData() {
        let entity = Folder(context: viewContext)
        entity.name = "Verses"
        save()
        dataSeeded = true
    }
    
    private func delete(folder: Folder) {
        viewContext.delete(folder)
        save()
    }
    
    private func addFolder() {
        guard !folderName.isEmpty else { return }
        let entity = Folder(context: viewContext)
        entity.name = folderName
        save()
        folderName = ""
    }
    
    private func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    var body: some View {
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
            if !dataSeeded && folders.isEmpty {
                seedFolderData()
            }
        }
    }
}

struct FolderList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FolderList(selectedFolder: .constant(nil))
                .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
        }
    }
}
