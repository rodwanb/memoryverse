//
//  Lists.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/25.
//

import SwiftUI

struct Home: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: ListEntity.all) private var lists
    
    @State private var searchQuery: String = ""
    @State private var showNewList: Bool = false
        
    private func delete(list: ListEntity) {
        viewContext.delete(list)
        do {
            try viewContext.save()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(spacing: 16) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.blue)
                                    .frame(width: 38)
                                    .overlay(
                                        Image(systemName: "tray.fill")
                                            .foregroundColor(.white)
                                    )
                                
                                Text("All")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                            }
                            
                            Spacer()
                            
                            Text("0")
                                .font(.system(.title, design: .rounded, weight: .bold))
                        }
                        .padding()
                        .background(
                            colorScheme == .dark ? Color(uiColor: UIColor.tertiarySystemFill) : Color.white
                        )
                        .cornerRadius(8)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.red)
                                    .frame(width: 38)
                                    .overlay(
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                    )
                                                                
                                Text("Completed")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                            }
                            
                            Spacer()
                            
                            Text("0")
                                .font(.system(.title, design: .rounded, weight: .bold))
                        }
                        .padding()
                        .background(
                            colorScheme == .dark ? Color(uiColor: UIColor.tertiarySystemFill) : Color.white
                        )
                        .cornerRadius(8)
                    }
                    .padding(.top)
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                if !lists.isEmpty {
                    Section(header: Text("My Lists").font(.system(.title, design: .rounded, weight: .bold))) {
                        ForEach(lists) { list in
                            NavigationLink(value: list) {
                                HStack {
                                    Circle()
                                        .fill(list.color)
                                        .frame(width: 38)
                                        .overlay(
                                            Image(systemName: list.iconSystemName ?? "list.bullet")
                                                .foregroundColor(.white)
                                        )
                                        .padding(.trailing, 4)
                                                                        
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
                                .map { lists[$0] }
                                .forEach(delete)
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            .navigationDestination(for: ListEntity.self) { list in
                VerseList(list: list)
            }
            .searchable(text: $searchQuery)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            print("New Verse")
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("New Verse")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                            }
                        }
                        .disabled(lists.isEmpty)
                        
                        Spacer()
                        
                        Button("Add List") {
                            showNewList.toggle()
                        }
                    }
                }
            }
            .sheet(isPresented: $showNewList) {
                AddList()
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
    }
}
