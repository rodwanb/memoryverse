//
//  ContentView.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Int = 0
    @State private var memorizeId: String = UUID().uuidString
        
    var body: some View {
        TabView(selection: $selection) {
            MemoryVerseList()
//                .id(memorizeId)
                .tabItem {
                    Image(systemName: "goforward.plus")
                    Text("Memorize")
                }
                .tag(1)
            
            Text("Review")
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Review")
                }
                .tag(2)

            Text("Schedules")
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Schedules")
                }
                .tag(3)
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
                .tag(4)
        }
        .onChange(of: selection, perform: { newValue in
            if newValue == selection {
                // double tap
                if newValue == 1 {
                    withAnimation {
                        memorizeId = UUID().uuidString
                    }
                    
                }
            }
        })
        .onAppear {
            fixTabBarAppearance()
        }
    }
    
    private func fixTabBarAppearance() {
        // correct the transparency bug for Tab bars
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
    }
}
