//
//  MemoryVerseApp.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

@main
struct MemoryVerseApp: App {
    
    @StateObject private var store = BibleStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await store.load()
                }
                .environmentObject(store)
        }
    }
}
