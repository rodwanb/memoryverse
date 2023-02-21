//
//  ContentView.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct ContentView: View {
    
        
    var body: some View {
        TabView {
            MemoryVerseList()
                .tabItem {
                    Image(systemName: "goforward.plus")
                    Text("Memorize")
                }
            
            ReviewList()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Review")
                }

            Text("Schedules")
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Schedules")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("Settings")
                }
        }
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
