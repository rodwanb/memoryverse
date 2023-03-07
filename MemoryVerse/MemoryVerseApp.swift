//
//  MemoryVerseApp.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

@main
struct MemoryVerseApp: App {
    var body: some Scene {
        WindowGroup {
//            ContentView()
//            MemoryVerseList()
            Lists()
                .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
        }
    }
}
