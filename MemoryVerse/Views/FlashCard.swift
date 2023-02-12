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
        prepareWordsFOrReview()
    }
    
    private func stepForward() {
        progress = min(1.0, progress + 0.1)
        prepareWordsFOrReview()
    }
    
    private func restart() {
        progress = 0.0
        prepareWordsFOrReview()
    }
    
    private func prepareWordsFOrReview() {
        let numberOfWordsToRandomize = Int(Float(words.count) * progress)
        let wordsToReview = words.shuffled().prefix(numberOfWordsToRandomize)
        for index in words.indices {
            words[index].review = wordsToReview.contains(where: { $0 == words[index] })
            words[index].hidden = true
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                        
            HStack {
                ProgressBar(value: $progress)
                    .frame(height: 40)
                
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
            
            VStack(alignment: .leading, spacing: 10) {
                Text(reference)
                    .font(.title2)
                
                FlowLayout {
                    ForEach($words) { $word in
                        if word.review {
                            Text(word.text)
                                .padding(.trailing)
                                .opacity(word.hidden ? 0 : 1)
                                .onTapGesture {
                                    word.hidden.toggle()
                                }
                        } else {
                            Text(word.text)
                                .padding(.trailing)
                        }
                    }
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
