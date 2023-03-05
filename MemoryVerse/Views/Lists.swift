//
//  Lists.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/25.
//

import SwiftUI

struct Lists: View {
    @State private var searchQuery: String = ""
    
    @State var items: [String] = (1...10).map { "Item \($0)" }
    
    var body: some View {
        NavigationStack {
            List {                
                Section(header: Text("My Lists").font(.system(.title, design: .rounded, weight: .bold))) {
                    ForEach(items, id: \.self) { item in
                        HStack {
                            Image(systemName: "list.bullet")
                                .font(.system(.body, design: .rounded, weight: .bold))
                                .foregroundColor(.white)
                                .padding(10)
                                .background(
                                    Circle()
                                        .fill(Color.green)
                                )
                            
                            Text(item)
                            
                            Spacer()
                            
                            Text("0")
                        }
                        .padding(.vertical, 1)
                    }
                    .onDelete { offset in
                        items.remove(atOffsets: offset)
                    }
                }
                .headerProminence(.increased)
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

                        
                        Spacer()
                        
                        Button("Add List") {
                            
                        }
                    }
                }
            }
        }
    }
}

struct Lists_Previews: PreviewProvider {
    static var previews: some View {
        Lists()
    }
}
