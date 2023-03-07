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
    @State private var selectedIcon: String = "list.bullet"
    
    private var colors: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .brown]
    private var icons: [String] = [
        "list.bullet",
        "bookmark.fill",
        "mappin",
        "gift.fill",
        "birthday.cake.fill",
        "graduationcap.fill",
        "backpack.fill",
        "pencil.and.ruler.fill",
        "doc.fill"
    ]
        
    private func saveAndClose() {
        
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .center) {
                        Circle()
                            .fill(selectedColor)
                            .frame(width: 64)
                            .shadow(color: selectedColor.opacity(0.5), radius: 8)
                            .overlay(
                                Image(systemName: selectedIcon)
                                    .font(.system(.title, design: .rounded, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        TextField("List Name", text: $listName)
                            .showClearButton($listName)
                            .font(.system(.title2, design: .rounded, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(selectedColor)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(uiColor: UIColor.lightGray).opacity(0.3))
                            )
                            .padding()
                    }
                    .padding(.top)
                }
                                
                Section {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 40), spacing: 12)],
                        alignment: .center, spacing: 12) {
                        ForEach(colors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .fill(color)
                                
                                if color == selectedColor {
                                    Circle()
                                        .inset(by: -7)
                                        .strokeBorder(Color.gray.opacity(0.5), lineWidth: 4)
                                }
                            }
                            .onTapGesture {
                                selectedColor = color
                            }
                        }
                    }
                    .padding(.vertical, 6)
                }
                
                Section {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 40), spacing: 12)],
                        alignment: .center, spacing: 12) {
                        ForEach(icons, id: \.self) { icon in
                            ZStack {
                                Circle()
                                    .fill(Color(uiColor: UIColor.lightGray).opacity(0.3))
                                
                                Image(systemName: icon)
                                
                                if icon == selectedIcon {
                                    Circle()
                                        .inset(by: -7)
                                        .strokeBorder(Color.gray.opacity(0.5), lineWidth: 4)
                                }
                            }
                            .onTapGesture {
                                selectedIcon = icon
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
