//
//  NewList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/05.
//

import SwiftUI

struct NewList: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var listName: String = ""
    @State private var selectedColor: Color = .blue
    
    private var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .brown]
    
    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    private func saveAndClose() {
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .center) {
                        Image(systemName: "list.bullet")
                            .font(.system(.largeTitle, design: .rounded, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(
                                Circle()
                                    .fill(selectedColor)
                            )
                            .shadow(color: selectedColor.opacity(0.5), radius: 8)
                        
                        TextField("List Name", text: $listName)
                            .showClearButton($listName)
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(selectedColor)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(uiColor: UIColor.lightGray).opacity(0.4))
                            )
                            .padding()
                    }
                    .padding(.top)
                }
                                
                Section {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                        ForEach(colors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .fill(color)
                                
                                if color == selectedColor {
                                    Circle()
                                        .strokeBorder(Color.gray, lineWidth: 3)
                                }
                            }
                            .onTapGesture {
                                selectedColor = color
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("New List")
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
                    .disabled(listName.isEmpty)
                }
            }
        }
    }
}

struct NewList_Previews: PreviewProvider {
    static var previews: some View {
        NewList()
    }
}

struct TextFieldClearButton: ViewModifier {
    @Binding var fieldText: String

    func body(content: Content) -> some View {
        content
            .overlay {
                if !fieldText.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            fieldText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

extension View {
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(fieldText: text))
    }
}
