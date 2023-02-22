//
//  VerseCardList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/22.
//

import SwiftUI

struct VerseCardList: View {
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(0..<5) { item in
                    VerseCard()
                }
            }
        }
    }
}

struct VerseCardList_Previews: PreviewProvider {
    static var previews: some View {
        VerseCardList()
    }
}
