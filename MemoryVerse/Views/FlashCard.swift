//
//  FlashCard.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct FlashCard: View {
    
    var reference: String
    var verse: String
    
    @State private var words: [Word]
    
    init(reference: String, verse: String) {
        self.reference = reference
        self.verse = verse
        words = verse
            .components(separatedBy: " ")
            .map { Word(text: $0) }
    }
    
    var body: some View {
        FlowLayout {
            ForEach(words) { word in
                Text(word.text)
                    .padding(.trailing)
            }
        }
        .padding()
        .padding(.bottom)
        .border(Color.black)
        .padding()
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCard(reference: "Mark 8: 36-37", verse: "36 For what will it profit a man if he gains the whole world, and loses his own soul? 37 Or what will a man give in exchange for his soul?")
    }
}
