//
//  VerseList.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/03/09.
//

import SwiftUI

struct VerseList: View {
    var body: some View {
        Text("No Verses")
            .foregroundColor(.secondary)
            .navigationTitle("Verse Pack")
            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
                
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Button {
                            print("New Verse")
                        } label: {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("New Verse")
                                    .font(.system(.body, design: .rounded, weight: .medium))
                            }
                        }
                        
                        Spacer()
                    }
                }
            }
    }
}

struct VerseList_Previews: PreviewProvider {
    static var previews: some View {
        VerseList()
    }
}
