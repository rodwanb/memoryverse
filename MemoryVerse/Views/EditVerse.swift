//
//  EditVerse.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/14.
//

import SwiftUI

struct EditVerse: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var reference: String = ""
    @State private var text: String = ""
    @State private var errors: AddEditVerseErrors = AddEditVerseErrors()
    
    @ObservedObject var verse: Verse
        
    var isFormValid: Bool {
        errors = AddEditVerseErrors()
        
        if reference.isEmpty {
            errors.reference = "Reference is required"
        }
        
        if text.isEmpty {
            errors.verse = "Verse is required"
        }
        
        return errors.isValid
    }
    
    private func save() {
        verse.reference = reference
        verse.text = text
                
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
                TextField("Reference", text: $reference)
                    .padding(.leading, 3)
                if !errors.reference.isEmpty {
                    Text(errors.reference)
                        .font(.caption)
                }
                
                TextArea("Verse", text: $text)
                if !errors.verse.isEmpty {
                    Text(errors.verse)
                        .font(.caption)
                }
                
                HStack {
                    Spacer()
                    Button("Save") {
                        if isFormValid {
                            save()
                        }
                    }
                    Spacer()
                }
            }
            .onAppear {
                reference = verse.reference ?? ""
                text = verse.text ?? ""
            }
            .navigationTitle("Memory Verse")
        }
    }
}

//
//struct EditVerse_Previews: PreviewProvider {
//    static var previews: some View {
//        EditVerse()
//    }
//}
