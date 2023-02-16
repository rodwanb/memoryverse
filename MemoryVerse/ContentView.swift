//
//  ContentView.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var bibleModel = BibleModel()
    
    var body: some View {
        TabView {
            VersePack()
                .tabItem {
                    Image(systemName: "goforward.plus")
                    Text("Memorize")
                }
            
            NavigationStack {
                VStack {
                    List {
                        ForEach(bibleModel.books) { book in
                            VStack(alignment: .leading) {
                                NavigationLink(value: book) {
                                    Text(book.longName)
                                }
                            }
                        }
                    }
                    .navigationDestination(for: Bible.Book.self) { book in
                        ChapterList(book: book)
                    }
                }
                .navigationTitle("Books")
            }
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
            bibleModel.load()
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

struct ChapterList: View {
    
    var book: Bible.Book
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(book.chapters) { chapter in
                    NavigationLink(value: chapter) {
                        Text("\(chapter.number)")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .border(.primary)
                    }
                    .tint(.primary)
                }
            }
        }
        .navigationDestination(for: Bible.Chapter.self) { chapter in
            VerseList(chapter: chapter)
        }
        .navigationTitle(book.longName)
    }
    
}

struct VerseList: View {
    
    var chapter: Bible.Chapter
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns) {
                ForEach(chapter.verses) { verse in
                    NavigationLink(value: verse) {
                        Text("\(verse.number)")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .border(.primary)
                    }
                    .tint(.primary)
                }
            }
        }
        .navigationDestination(for: Bible.Verse.self) { verse in
            VerseDetail(verse: verse)
        }
        .navigationTitle("Chapter \(chapter.number)")
    }
}

struct VerseDetail: View {
    
    var verse: Bible.Verse
    
    var body: some View {
        VStack {
            Text(verse.text)
            Spacer()
        }
        .navigationTitle("Verse \(verse.number)")
    }
    
}
