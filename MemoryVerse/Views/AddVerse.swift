//
//  AddVerse.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/13.
//

import SwiftUI

struct AddVerseErrors {
    var reference: String = ""
    var verse: String = ""
    
    var isValid: Bool {
        return reference.isEmpty && verse.isEmpty
    }
}

struct AddVerse: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var reference: String = ""
    @State private var verse: String = ""
    @State private var errors: AddVerseErrors = AddVerseErrors()
        
    var isFormValid: Bool {
        errors = AddVerseErrors()
        
        if reference.isEmpty {
            errors.reference = "Reference is required"
        }
        
        if verse.isEmpty {
            errors.verse = "Verse is required"
        }
        
        return errors.isValid
    }
    
    private func save() {
        let verse = Verse(context: viewContext)
        verse.reference = reference
        verse.text = self.verse
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print(error)
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
                
                TextArea("Verse", text: $verse)
                if !errors.verse.isEmpty {
                    Text(errors.verse)
                        .font(.caption)
                }
                
                HStack {
                    Spacer()
                    Button("Add Verse") {
                        if isFormValid {
                            save()
                        }
                    }
                    Spacer()
                }
            }
            .navigationTitle("Memory Verse")
        }
    }
}

struct TextArea: View {
    
    private let placeholder: String
    @Binding var text: String
    
    init(_ placeholder: String, text: Binding<String>) {
        self.placeholder = placeholder
        self._text = text
    }
    
    var body: some View {
        TextEditor(text: $text)
            .background(
                HStack(alignment: .top) {
                    text.allSatisfy { $0.isWhitespace } ? Text(placeholder) : Text("")
                    Spacer()
                }
                .foregroundColor(Color.primary.opacity(0.25))
                .padding(EdgeInsets(top: 0, leading: 3, bottom: 10, trailing: 0))
            )
    }
}

struct AddVerse_Previews: PreviewProvider {
    static var previews: some View {
        AddVerse()
    }
}
