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
    @State private var progress: Float = 0.0
    
    init(reference: String, verse: String) {
        self.reference = reference
        self.verse = verse
        words = verse
            .components(separatedBy: " ")
            .map { Word(text: $0) }
    }
    
    private func stepBackward() {
        progress = max(0.0, progress - 0.1)
    }
    
    private func stepForward() {
        progress = min(1.0, progress + 0.1)
    }
    
    private func restart() {
        progress = 0.0
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                ProgressBar(value: $progress)
                    .frame(width: 200, height: 40)
                
                Button(action: stepBackward) {
                    Image(systemName: "arrow.backward.circle")
                        .font(.title)
                }
                .disabled(progress == 0.0)
                
                Button(action: stepForward) {
                    Image(systemName: "arrow.forward.circle")
                        .font(.title)
                }
                .disabled(progress == 1.0)
                
                Button(action: restart) {
                    Image(systemName: "arrow.counterclockwise.circle")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            FlowLayout {
                ForEach(words) { word in
                    Text(word.text)
                        .padding(.trailing)
                }
            }
            .padding()
            .padding(.bottom)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.blue, lineWidth: 2)
            )
            .padding()
            
            Spacer()
        }
    }
}

struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        FlashCard(reference: "Mark 8: 36-37", verse: "36 For what will it profit a man if he gains the whole world, and loses his own soul? 37 Or what will a man give in exchange for his soul?")
    }
}
