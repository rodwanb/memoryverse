//
//  ReviewList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/21.
//

import SwiftUI

struct ReviewList: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(destination: VerseCardList().navigationTitle("Daily Review")) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Daily")
                    }
                }
                
                NavigationLink(destination: VerseCardList().navigationTitle("Weekly Review")) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(uiColor: UIColor.systemOrange))
                        Text("Weekly")
                    }
                }
                
                NavigationLink(destination: VerseCardList().navigationTitle("Monthly Review")) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(uiColor: UIColor.systemGreen))
                        Text("Monthly")
                    }
                }
                
                NavigationLink(destination: VerseCardList().navigationTitle("Yearly Review")) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(uiColor: UIColor.systemGreen))
                        Text("Yearly")
                    }
                }
            }
            .navigationTitle("Review")
        }
    }
}

struct ReviewList_Previews: PreviewProvider {
    static var previews: some View {
        ReviewList()
    }
}
