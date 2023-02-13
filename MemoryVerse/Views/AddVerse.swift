//
//  AddVerse.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/13.
//

import SwiftUI

struct AddVerse: View {
    
    @State private var reference: String = ""
    @State private var verse: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Reference", text: $reference)
                    .padding(.leading, 3)
                TextArea("Verse", text: $verse)
            }
            .navigationTitle("Add Verse")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        // TODO:
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        // TODO:
                    }
                }
            }
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
