//
//  Lists.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/25.
//

import SwiftUI

struct Home: View {
    
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
                    HStack {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Image(systemName: "tray.fill")
                                    .font(.system(.body, design: .rounded, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(.blue)
                                    )
                                
                                Text("All")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                                    .padding(.leading, 2)
                            }
                            
                            Spacer()
                            
                            Text("0")
                                .font(.system(.title, design: .rounded, weight: .bold))
                        }
                        .padding()
                        .background()
                        .cornerRadius(4)
                        
                        Spacer()
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(.body, design: .rounded, weight: .bold))
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(
                                        Circle()
                                            .fill(.red)
                                    )
                                
                                Text("Completed")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                            }
                            
                            Spacer()
                            
                            Text("0")
                                .font(.system(.title, design: .rounded, weight: .bold))
                        }
                        .padding()
                        .background()
                        .cornerRadius(4)
                    }
                }
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
                
                if !lists.isEmpty {
                    Section(header: Text("My Lists").font(.system(.title, design: .rounded, weight: .bold))) {
                        ForEach(lists) { list in
                            NavigationLink(value: list) {
                                HStack {
                                    Image(systemName: list.iconSystemName ?? "")
                                        .font(.system(.body, design: .rounded, weight: .bold))
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(
                                            Circle()
                                                .fill(list.color)
                                        )
                                    
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
