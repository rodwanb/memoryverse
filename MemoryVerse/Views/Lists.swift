//
//  Lists.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/25.
//

import SwiftUI

struct Lists: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(fetchRequest: ListEntity.all) private var lists
    
    @State private var searchQuery: String = ""
    @State private var showNewList: Bool = false
    
//    @State var items: [String] = (1...10).map { "Item \($0)" }
    
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
                if !lists.isEmpty {
                    Section(header: Text("My Lists").font(.system(.title, design: .rounded, weight: .bold))) {
                        ForEach(lists) { list in
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
                                
                                Text("0")
                            }
                            .padding(.vertical, 1)
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
                NewList()
            }
        }
    }
}

struct Lists_Previews: PreviewProvider {
    static var previews: some View {
        Lists()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
    }
}
