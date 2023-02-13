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
            VersePack()
                .tabItem {
                    Image(systemName: "list.bullet.circle.fill")
                    Text("Verse Pack")
                }
            
            Text("Bible")
                .tabItem {
                    Image(systemName: "book.circle.fill")
                    Text("Bible")
                }
            
            Text("History")
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("History")
                }
            
            Text("Settings")
                .tabItem {
                    Image(systemName: "gearshape.circle.fill")
                    Text("Settings")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
