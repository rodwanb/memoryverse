//
//  VerseCard.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/21.
//

import SwiftUI

struct VerseCard: View {
    @State var backDegree = 0.0
    @State var frontDegree = -90.0
    @State var isFlipped = false
    
    let width : CGFloat = 300
    let height : CGFloat = 180
    let durationAndDelay : CGFloat = 0.3
    
    func flipCard () {
        isFlipped = !isFlipped
        if isFlipped {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                frontDegree = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)){
                backDegree = 0
            }
        }
    }
    
    var body: some View {
        ZStack {
            VerseCardBack(
                width: width,
                height: height,
                degree: $backDegree
            )
            VerseCardFront(
                width: width,
                height: height,
                degree: $frontDegree
            )
        }
        .onTapGesture {
            flipCard ()
        }
        .padding()
    }
}

struct VerseCardFront: View {
    let width : CGFloat
    let height : CGFloat
    @Binding var degree : Double
    
    var body: some View {
        Text("The rich rule over the poor, and the borrower is slave to the lender.")
            .padding()
            .frame(width: width)
            .frame(minHeight: height)
            .background(content: {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color(uiColor: UIColor.systemBackground))
                    .frame(width: width)
                    .shadow(color: .primary.opacity(0.5), radius: 2, x: 0, y: 0)
            })
            .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct VerseCardBack: View {
    let width : CGFloat
    let height : CGFloat
    @Binding var degree : Double
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color(uiColor: UIColor.systemBackground))
                .frame(width: width, height: height)
                .shadow(color: .primary.opacity(0.5), radius: 2, x: 0, y: 0)

            Text("Proverbs 22:7")
                .padding()
                .frame(width: width, height: height)
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}

struct VerseCard_Previews: PreviewProvider {
    static var previews: some View {
        VerseCard()
    }
}
