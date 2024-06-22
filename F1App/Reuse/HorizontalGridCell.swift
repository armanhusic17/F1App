//
//  HorizontalGridCell.swift
//  F1App
//
//  Created by Arman Husic on 5/25/24.
//

import SwiftUI

struct HorizontalGridCell: View {
    let wdcPosition: String
    let wdcPoints: String
    let constructorName: String
    let image: String
    let items: [String]
    
    init(
        wdcPosition: String,
        wdcPoints: String,
        constructorName: String,
        image: String,
        items: [String]
    ) {
        self.wdcPosition = wdcPosition
        self.wdcPoints = wdcPoints
        self.constructorName = constructorName
        self.image = image
        self.items = items
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: [GridItem(.flexible())]) {
                ForEach(items, id: \.self) { item in
                    VStack {
                        HStack {
                            Image(systemName: "person.and.background.dotted")
                                .font(.largeTitle)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.red)
                            Text(item.capitalized)
                                .bold()
                                .fixedSize(horizontal: true, vertical: false)
                                .font(.largeTitle)
                            Spacer()
                        }
                        .padding(25)

                        VStack(alignment: .center, spacing: 16) {
                            HStack {
                                Image(systemName: "trophy")
                                Text(wdcPosition)
                            }
                            HStack {
                                Image(systemName: "car")
                                Text(wdcPoints)
                            }
                            HStack {
                                Image(systemName: "steeringwheel")
                                Text(constructorName)
                            }
                        }
                        .font(.title)
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(
                        LinearGradient(
                            colors: [.black, .clear, .red],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                    )
                    .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    HorizontalGridCell(
        wdcPosition: "WDC Position",
        wdcPoints: "WDC Points",
        constructorName: "Team Name",
        image: "Image",
        items: ["Given Name + Family Name"]
    )
}
