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
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                    Text("Daily")
                }
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(uiColor: UIColor.systemOrange))
                    Text("Weekly")
                }
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(uiColor: UIColor.systemGreen))
                    Text("Monthly")
                }
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Color(uiColor: UIColor.systemGreen))
                    Text("Yearly")
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
