//
//  ProgressBar.swift
//  MemoryVerse
//
//  Created by Rodwan Barbier on 2023/02/12.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear, value: value)
            }
            .cornerRadius(5.0)
        }
    }
}

struct ProgressBar_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBar(value: .constant(0.5))
    }
}
