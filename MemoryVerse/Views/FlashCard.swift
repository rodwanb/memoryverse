//
//  FlashCard.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct FlashCard: View {
    
    let verse: Verse
    
    @State private var words: [Word]
    @State private var progress: Float = 0.0
    
    init(verse: Verse) {
        self.verse = verse
        
        let verseWords = verse.text
            .components(separatedBy: " ")
            .map { Word(text: $0) }
        
        self._words = State(initialValue: verseWords)
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
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    ProgressBar(value: $progress)
                        .frame(height: 40)
                    
                    Button(action: stepBackward) {
                        Image(systemName: "arrow.backward.circle")
                            .font(.title)
                            .tint(.black)
                    }
                    .disabled(progress == 0.0)
                    
                    Button(action: stepForward) {
                        Image(systemName: "arrow.forward.circle")
                            .font(.title)
                            .tint(.black)
                    }
                    .disabled(progress == 1.0)
                    
                    Button(action: restart) {
                        Image(systemName: "arrow.counterclockwise.circle")
                            .font(.title)
                            .tint(.black)
                    }
                }
                .padding(.bottom)
                
                
                Text(verse.reference)
                    .font(.title3)
                    .bold()
                
                FlowLayout {
                    ForEach($words) { word in
                        WordCell(word: word)
                    }
                }
                .padding(.bottom, 40)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Flash card")
    }
}

struct WordCell: View {
    
    @Binding var word: Word
    
    var body: some View {
        Group {
            let text = Text(word.text)
            
            if word.review {
                text
                    .foregroundColor(word.hidden ? .clear : .black)
                    .padding(.horizontal, 6)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.black, lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            word.hidden.toggle()
                        }
                    }
            } else {
                text
            }
        }
        .font(.body)
        .padding(.trailing, 4)
        .padding(.vertical, 3)
    }
}

struct ProgressBar: View {
    
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(
                        width: geometry.size.width,
                        height: geometry.size.height
                    )
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemFill))
                
                Rectangle()
                    .frame(
                        width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width),
                        height: geometry.size.height
                    )
                    .foregroundColor(Color(UIColor.systemGray2))
            }
            .cornerRadius(5.0)
        }
    }
}


struct FlashCard_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            FlashCard(verse: Verse.all[0])
        }
    }
}
