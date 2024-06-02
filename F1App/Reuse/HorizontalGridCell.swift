//
//  HorizontalGridCell.swift
//  F1App
//
//  Created by Arman Husic on 5/25/24.
//

import SwiftUI

struct HorizontalGridCell: View {
    let items: [String]
    
    init(items: [String]) {
        self.items = items
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items, id: \.self) { item in
                    VStack {
                        Image(item)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250, height: 100)
                            .padding()
                        Text(item.capitalized)
                            .foregroundStyle(.white)
                            .font(.title)
                            .padding()
                    }
                    .background(Color.red)
                    .cornerRadius(12)
                    .padding(.horizontal, 2)
                }
            }
        }
    }
}

#Preview {
    HorizontalGridCell(items: ["1", "2", "3"])
}
