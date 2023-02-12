//
//  ContentView.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        FlashCard(reference: "Mark 8: 36-37", verse: "36 For what will it profit a man if he gains the whole world, and loses his own soul? 37 Or what will a man give in exchange for his soul?")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
