//
//  ContentView.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/25.
//

import SwiftUI

struct ContentView: View {
        
    @State private var selectedFolder: Folder?
    @State private var selectedVerse: Verse?
                    
    var body: some View {
        NavigationSplitView {
            FolderList(selectedFolder: $selectedFolder)
        } content: {
            if let selectedFolder {
                VerseList(folder: selectedFolder, selectedVerse: $selectedVerse)
            } else {
                Text("Select a list")
            }
        } detail: {
            if let selectedVerse {
                MemorizeVerse(verse: selectedVerse)
            } else {
                Text("Select a verse")
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(BibleStore())
    }
}
