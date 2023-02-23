//
//  ReviewDecks.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/23.
//

import SwiftUI

struct ReviewDecks: View {
    @FetchRequest(fetchRequest: Verse.all) private var verses

    var body: some View {
        ScrollView {
            VStack {
                ReviewDeck(
                    title: "Daily review",
                    verses: Array(verses))
                
                ReviewDeck(
                    title: "Weekly review",
                    verses: Array(verses))
            }
        }
    }
}

struct ReviewDeck: View {
    
    let title: String
    let verses: [Verse]
    
    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.medium)
                    .padding(.horizontal)
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
            
            let cardWidth = UIScreen.main.bounds.width * 0.7
            HStack(alignment: .center, spacing: 30) {
                ForEach(verses) { verse in
                    CardView(verse: verse)
                        .frame(width: cardWidth, height: 130, alignment: .leading)
                }
            }
            .padding()
            .modifier(ScrollingHStackModifier(items: 5, itemWidth: cardWidth, itemSpacing: 30))
            .background(Color(uiColor: UIColor.systemOrange))

        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct CardView: View {
    let verse: Verse
    
    @State private var isShowingAnswer = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(.white)
                .shadow(radius: 4)
            
            VStack {
                Text(verse.reference ?? "")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                if isShowingAnswer {
                    Text(verse.text ?? "")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .onTapGesture {
            withAnimation {
                isShowingAnswer.toggle()
            }
        }
//        .frame(width: 350, height: 180)
    }
}

struct ReviewDecks_Previews: PreviewProvider {
    static var previews: some View {
        ReviewDecks()
            .environment(\.managedObjectContext, CoreDataModel.shared.viewContext)
    }
}

struct ScrollingHStackModifier: ViewModifier {
    
    @State private var scrollOffset: CGFloat
    @State private var dragOffset: CGFloat
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        
        // Calculate Total Content Width
        let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
        let screenWidth = UIScreen.main.bounds.width
        
        // Set Initial Offset to first Item
        let initialOffset = (contentWidth/2.0) - (screenWidth/2.0) + ((screenWidth - itemWidth) / 2.0)
        
        self._scrollOffset = State(initialValue: initialOffset)
        self._dragOffset = State(initialValue: 0)
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(DragGesture()
                .onChanged({ event in
                    dragOffset = event.translation.width
                })
                .onEnded({ event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.width
                    dragOffset = 0
                    
                    // Now calculate which item to snap to
                    let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
                    let screenWidth = UIScreen.main.bounds.width
                    
                    // Center position of current offset
                    let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
                    
                    // Calculate which item we are closest to using the defined size
                    var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)
                    
                    // Should we stay at current index or are we closer to the next item...
                    if index.remainder(dividingBy: 1) > 0.5 {
                        index += 1
                    } else {
                        index = CGFloat(Int(index))
                    }
                    
                    // Protect from scrolling out of bounds
                    index = min(index, CGFloat(items) - 1)
                    index = max(index, 0)
                    
                    // Set final offset (snapping to item)
                    let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing
                    
                    // Animate snapping
                    withAnimation {
                        scrollOffset = newOffset
                    }
                    
                })
            )
    }
}
