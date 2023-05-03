//
//  AddList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/05.
//

import SwiftUI

struct AddFolder: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    @State private var folderName: String = ""
    @FocusState private var isFolderNameFocused: Bool

    private func saveAndClose() {
        let entity = Folder(context: viewContext)
        entity.name = folderName
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                dismiss()
            } catch {
                print(error)
            }
        }
    }
        
    var body: some View {
        NavigationStack {
            Form {
                TextField("Folder Name", text: $folderName)
                    .focused($isFolderNameFocused)
            }
            .onAppear {
                isFolderNameFocused.toggle()
            }
            .navigationTitle("New Folder")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: dismiss.callAsFunction)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveAndClose) {
                        Text("Done")
                            .bold()
                    }
                    .disabled(folderName.isEmpty)
                }
            }
        }
    }
}

struct AddList_Previews: PreviewProvider {
    static var previews: some View {
        AddFolder()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
    }
}
