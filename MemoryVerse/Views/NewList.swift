//
//  NewList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/05.
//

import SwiftUI

struct NewList: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) private var viewContext
        
    @State private var listName: String = ""
    @State private var selectedColor: Color = .blue
    @State private var selectedIcon: String = "list.bullet"
    @State private var areYouSure: Bool = false
    
    private var colors: [Color] = [
        .red,
        .orange,
        .yellow,
        .green,
        .teal,
        .blue,
        .indigo,
        .pink,
        .purple,
        .brown,
        .gray,
        .mint
    ]
    
    private var icons: [String] = [
        "list.bullet",
        "bookmark.fill",
        "mappin",
        "gift.fill",
        "birthday.cake.fill",
        "graduationcap.fill",
        "backpack.fill",
        "pencil.and.ruler.fill",
        "doc.fill",
        "book.fill",
        "tray.full.fill",
        "creditcard.fill",
        "banknote",
        "dumbbell.fill",
        "figure.run",
        "fork.knife",
        "wineglass.fill",
        "pills.fill",
        "stethoscope",
        "chair.fill",
        "house.fill",
        "building.2.fill",
        "building.columns",
        "tent.fill",
        "tv",
        "music.note",
        "desktopcomputer",
        "gamecontroller.fill",
        "headphones",
        "leaf.fill",
        "carrot.fill",
        "figure.arms.open",
        "figure.2.arms.open",
        "figure.2.and.child.holdinghands",
        "pawprint.fill",
        "teddybear.fill",
        "fish.fill",
        "basket.fill",
        "stroller.fill",
        "bag.fill",
        "shippingbox.fill",
        "soccerball",
        "baseball.fill",
        "basketball.fill",
        "football.fill",
        "tennis.racket",
        "train.side.front.car",
        "airplane",
        "sailboat.fill",
        "car.fill",
        "beach.umbrella.fill",
        "sun.max.fill",
        "moon.fill",
        "drop.fill",
        "snowflake",
        "flame.fill",
        "suitcase.fill",
        "wrench.and.screwdriver.fill",
        "scissors",
        "compass.drawing",
        "curlybraces",
        "lightbulb.fill",
        "bubble.left.fill",
        "staroflife.fill",
        "square.fill",
        "circle.fill",
        "triangle.fill",
        "diamond.fill",
        "heart.fill",
        "star.fill"
    ]
        
    private func saveAndClose() {
        let entity = ListEntity(context: viewContext)
        entity.name = listName
        entity.hexColor = selectedColor.toHex()!
        entity.iconSystemName = selectedIcon
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
                dismiss()
            } catch {
                print(error)
            }
        }

    }
    
    private func cancel() {
        if !listName.isEmpty || selectedColor != .blue || selectedIcon != "list.bullet" {
            areYouSure.toggle()
        } else {
            dismiss()
        }
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
                        columns: [GridItem(.adaptive(minimum: 34), spacing: 12)],
                        alignment: .center, spacing: 12) {
                        ForEach(colors, id: \.self) { color in
                            ZStack {
                                Circle()
                                    .fill(color)
                                
                                if color == selectedColor {
                                    Circle()
                                        .inset(by: -7)
                                        .strokeBorder(Color.gray.opacity(0.5), lineWidth: 3)
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
                        columns: [GridItem(.adaptive(minimum: 34), spacing: 12)],
                        alignment: .center, spacing: 12) {
                        ForEach(icons, id: \.self) { icon in
                            ZStack {
                                Circle()
                                    .fill(Color(uiColor: UIColor.lightGray).opacity(0.3))
                                
                                Image(systemName: icon)
                                
                                if icon == selectedIcon {
                                    Circle()
                                        .inset(by: -7)
                                        .strokeBorder(Color.gray.opacity(0.5), lineWidth: 3)
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
                    Button("Cancel", action: cancel)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: saveAndClose) {
                        Text("Done")
                            .bold()
                    }
                    .disabled(listName.isEmpty)
                }
            }
            .confirmationDialog("", isPresented: $areYouSure) {
                Button(role: .destructive) {
                    dismiss()
                } label: {
                    Text("Discard Changes")
                }
                
                Button(role: .cancel) {
                    
                } label: {
                    Text("Cancel")
                }
            } message: {
                EmptyView()
            }

        }
    }
}

struct NewList_Previews: PreviewProvider {
    static var previews: some View {
        NewList()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
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
