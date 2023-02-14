//
//  FlashCard.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct FlashCard: View {
    
    @ObservedObject public var verse: Verse
    
    @State private var words: [Word] = []
    @State private var progress: Float = 0.0
    @State private var isEditVersePresented: Bool = false
    
    private func stepBackward() {
        progress = max(0.0, progress - 0.1)
        prepareWordsForReview()
    }
    
    private func stepForward() {
        progress = min(1.0, progress + 0.1)
        prepareWordsForReview()
    }
    
    private func restart() {
        words.removeAll()
        let newWords = verse.text?
            .components(separatedBy: " ")
            .map { Word(text: $0) } ?? []
        words.append(contentsOf: newWords)
        progress = 0.0
        prepareWordsForReview()
    }
    
    private func prepareWordsForReview() {
        let numberOfWordsToRandomize = Int(Float(words.count) * progress)
        let wordsToReview = words.shuffled().prefix(numberOfWordsToRandomize)
        for index in words.indices {
            words[index].review = wordsToReview.contains(where: { $0 == words[index] })
            words[index].hidden = true
        }
    }
    
    private func edit() {
        isEditVersePresented = true
    }
    
    private func toggleHidden(word: Word) {
        for index in words.indices {
            if words[index].id == word.id {
                words[index].hidden.toggle()
            } else {
                words[index].hidden = true
            }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                                
                ProgressBar(value: $progress)
                    .frame(height: 8)
                    .padding(.bottom, 8)
                
                FlowLayout {
                    ForEach($words) { word in
                        WordCell(word: word, toggleHidden: toggleHidden)
                    }
                }
                .padding(.bottom, 40)
                
                HStack {

                    Spacer()
                    
                    Button(action: restart) {
                        Image(systemName: "arrow.counterclockwise.circle")
                            .font(.largeTitle)
                            .tint(.primary)
                    }
                    .padding(.horizontal)
                    
                    Button(action: stepBackward) {
                        Image(systemName: "arrow.backward.circle")
                            .font(.largeTitle)
                            .tint(.primary)
                    }
                    .disabled(progress == 0.0)
                    
                    Button(action: stepForward) {
                        Image(systemName: "arrow.forward.circle")
                            .font(.largeTitle)
                            .tint(.primary)
                    }
                    .disabled(progress == 1.0)
                    
                }
                .padding(.bottom)
                
                Spacer()
            }
            .padding()
        }
        .onChange(of: verse.text, perform: { newValue in
            restart()
        })
        .task {
            restart()
        }
        .navigationTitle(verse.reference ?? "")
        .sheet(isPresented: $isEditVersePresented, content: {
            EditVerse(verse: verse)
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit", action: edit)
            }
        }
    }
}

struct WordCell: View {
    
    @Binding var word: Word
    var toggleHidden: (Word) -> Void
    
    var body: some View {
        Group {
            let text = Text(word.text)
                .font(.title3)
            
            if word.review {
                text
                    .foregroundColor(word.hidden ? .clear : .primary)
                    .padding(.horizontal, 6)
                    .overlay(
                        Capsule(style: .continuous)
                            .stroke(.secondary, lineWidth: 2)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            toggleHidden(word)
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
                    .foregroundColor(.secondary)
                
                Rectangle()
                    .frame(
                        width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width),
                        height: geometry.size.height
                    )
                    .foregroundColor(.primary)
            }
            .cornerRadius(5.0)
        }
    }
}


struct FlashCard_Previews: PreviewProvider {
    
    static var verse: Verse = {
        let context = CoreDataModel.shared.viewContext
        let verse = Verse(context: context)
        verse.reference = "Proverbs 22:7"
        verse.text = "The rich rule over the poor, and the borrower is slave to the lender."
        return verse
    }()
    
    static var previews: some View {
        NavigationStack {
            FlashCard(verse: verse)
        }
        .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)

    }
}
