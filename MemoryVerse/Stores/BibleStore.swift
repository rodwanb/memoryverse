//
//  BibleModel.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/15.
//

import Foundation

@MainActor final class BibleStore: ObservableObject {
    
    @Published private(set) var bible: Bible = .empty
    @Published private(set) var folders: [Folder] = []
    
    func load() async {
        bible = loadBible()
        folders = loadUserData()
    }
    
    func addFolder(name: String) {
        let folder = Folder(name: name)
        folders.append(folder)
        saveUserData()
    }
    
    func deleteFolder(folder: Folder) {
        folders.removeAll { x in
            x.id == folder.id
        }
        saveUserData()
    }
    
    private func loadBible() -> Bible {
        Bundle.main.decode(Bible.self, from: "nkjv.bible.json")
    }
    
    private func loadUserData() -> [Folder] {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("folders2.json")
            
            let encodedData = try Data(contentsOf: fileURL)
            let decodedData = try JSONDecoder().decode([Folder].self, from: encodedData)
            return decodedData
        } catch {
            print("Error loading user data", error)
            return []
        }
    }
    
    private func saveUserData() {
        do {
            let fileURL = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent("folders2.json")
                        
            try JSONEncoder()
                .encode(folders)
                .write(to: fileURL)
            
        } catch {
            print("Error saving user data", error)
        }
    }
}
