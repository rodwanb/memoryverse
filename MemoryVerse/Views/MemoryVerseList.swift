//
//  VersePack.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/13.
//

import SwiftUI

struct MemoryVerseList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: Verse.all) private var verses
    
    @State private var isAddVersePresented: Bool = false
    @State private var searchText = ""
    
    static let dateCreatedFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
    
    private func deleteVerse(verse: Verse) {
        viewContext.delete(verse)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    private func add() {
        isAddVersePresented.toggle()
    }
        
    var body: some View {
        NavigationStack {
            List {
                if verses.isEmpty {
                    Text("No memory verses exist.")
                } else {
                    ForEach(verses) { verse in
                        NavigationLink(value: verse) {
                            HStack {
                                let referenceParts = verse.reference?
                                    .components(separatedBy: " ")
                                    .map { $0.prefix(1) }
                                    .prefix(2)
                                    .reduce("", { result, current in
                                        return result + current
                                    })
                                    
                                Text(referenceParts ?? "")
                                    .font(.body)
                                    .padding()
                                    .background(Color(uiColor: UIColor.systemFill))
                                    .clipShape(Circle())
                                    .frame(width: 70)
                                
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text(verse.reference ?? "")
                                            .font(.headline)
                                        
                                        Spacer()
                                        
                                        if let dateCreated = verse.dateCreated {
                                            Text("\(dateCreated, formatter: Self.dateCreatedFormat)")
                                                .lineLimit(1)
                                                .font(.body)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    Text(verse.text ?? "")
                                        .lineLimit(2)
                                        .foregroundColor(.secondary)
                                        .font(.body)
                                }
                            }
                        }
                    }
                    .onDelete { indexSet in
                        indexSet
                            .map { verses[$0] }
                            .forEach(deleteVerse)
                    }
//                    .onMove { source, destination in
//                        // TODO:
//                    }
                }
            }
            .listStyle(.plain)
            .navigationDestination(for: Verse.self) { verse in
                FlashCard(verse: verse)
            }
            .navigationTitle("Memory Verses")
            .searchable(text: $searchText, prompt: "Search your memory verses")
            .searchSuggestions {
                // TODO: show recent searches or list tags
//                Text("In the beginning").searchCompletion("In the beginning")
//                Text("Genesis").searchCompletion("Genesis")
            }
            .onChange(of: searchText) { newValue in
                verses.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "text CONTAINS[cd] %@ || reference CONTAINS[cd] %@", newValue, newValue)
            }

            .sheet(isPresented: $isAddVersePresented, content: {
                BibleBooksList()
                    .onCustomDismiss {
                        isAddVersePresented.toggle()
                    }
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: add) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

extension String {
    func removing(prefixes: [String]) -> String {
        var resultString = self
        _ = prefixes.map {
            if resultString.hasPrefix($0) {
                resultString = resultString.dropFirst($0.count).description
            }
        }
        return resultString
    }
}

struct CustomDismissAction {
    typealias Action = () -> ()
    let action: Action
    func callAsFunction() {
        action()
    }
}

struct CustomDismissActionKey: EnvironmentKey {
    static var defaultValue: CustomDismissAction? = nil
}

extension EnvironmentValues {
    var customDismiss: CustomDismissAction? {
        get { self[CustomDismissActionKey.self] }
        set { self[CustomDismissActionKey.self] = newValue }
    }
}

extension View {
    func onCustomDismiss(_ action: @escaping CustomDismissAction.Action) -> some View {
        self.environment(\.customDismiss, CustomDismissAction(action: action))
    }
}

struct VersePack_Previews: PreviewProvider {
    static var previews: some View {
        MemoryVerseList()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
    }
}
