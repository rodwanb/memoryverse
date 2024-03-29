//
//  MemorizeVerse.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct MemorizeVerse: View {
    
    @Environment(\.dismiss) private var dismiss
    var verse: Verse
    @State private var words: [Word] = []
    @State private var progress: Float = 0.0
    
    private func stepBackward() {
        guard progress > 0.0 else {
            return
        }
        progress = max(0.0, progress - 0.1)
        prepareWordsForReview()
    }
    
    private func stepForward() {
        if progress == 1.0 {
            dismiss()
        }
        progress = min(1.0, progress + 0.1)
        prepareWordsForReview()
    }
    
    private func restart() {
        words.removeAll()
        let newWords = verse.text
            .components(separatedBy: " ")
            .map { Word(text: $0) }
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
                                
                HStack(spacing: 0) {
                    ProgressBar(value: $progress)
                        .frame(height: 26)
                        .padding(.trailing)
                    
                    Button(action: stepBackward) {
                        Image(systemName: "arrow.backward.square.fill")
                            .font(.title)
                            .bold()
                    }
                    .tint(.primary)
                    
                    Button(action: stepForward) {
                        Image(systemName: "arrow.forward.square.fill")
                            .font(.title)
                            .bold()
                    }
                    .tint(.primary)
                }
                .padding(.bottom, 8)
                
                FlowLayout {
                    ForEach($words) { word in
                        WordCell(word: word, toggleHidden: toggleHidden)
                    }
                }
                .padding(.bottom, 40)
                                    
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
        .navigationTitle(verse.reference)
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
                    .foregroundColor(Color(uiColor: UIColor.systemGray))
                
                Rectangle()
                    .frame(
                        width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width),
                        height: geometry.size.height
                    )
                    .foregroundColor(Color(uiColor: UIColor.systemGreen))
                    .animation(.default, value: value)
            }
            .cornerRadius(5.0)
        }
    }
}

// Reference: https://swiftwithmajid.com/2022/11/16/building-custom-layout-in-swiftui-basics/
struct FlowLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var totalHeight: CGFloat = 0
        var totalWidth: CGFloat = 0
        
        var lineWidth: CGFloat = 0
        var lineHeight: CGFloat = 0
        
        for size in sizes {
            if lineWidth + size.width > proposal.width ?? 0 {
                totalHeight += lineHeight
                lineWidth = size.width
                lineHeight = size.height
            } else {
                lineWidth += size.width
                lineHeight = max(lineHeight, size.height)
            }
            
            totalWidth = max(totalWidth, lineWidth)
        }
        
        totalHeight += lineHeight
        
        return .init(width: totalWidth, height: totalHeight)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let sizes = subviews.map { $0.sizeThatFits(.unspecified) }
        
        var lineX = bounds.minX
        var lineY = bounds.minY
        var lineHeight: CGFloat = 0
        
        for index in subviews.indices {
            if lineX + sizes[index].width > (proposal.width ?? 0) {
                lineY += lineHeight
                lineHeight = 0
                lineX = bounds.minX
            }
            
            subviews[index].place(
                at: .init(
                    x: lineX + sizes[index].width / 2,
                    y: lineY + sizes[index].height / 2
                ),
                anchor: .center,
                proposal: ProposedViewSize(sizes[index])
            )
            
            lineHeight = max(lineHeight, sizes[index].height)
            lineX += sizes[index].width
        }
    }
}

struct FlashCard_Previews: PreviewProvider {
        
    static var previews: some View {
        NavigationStack {
            MemorizeVerse(verse: Verse.example)
        }
        .environmentObject(BibleStore())
    }
}
