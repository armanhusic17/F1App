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
                            AsyncImage(url: URL(string: image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(
                                                LinearGradient(
                                                    colors: [.black, .black, .mint],
                                                    startPoint: .bottomLeading,
                                                    endPoint: .topTrailing
                                                ), 
                                                lineWidth: 4
                                            )
                                    )
                            } placeholder: {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 100, height: 100)
                                    .scaledToFit()
                            }
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
                            colors: [.black, .black, .mint],
                            startPoint: .bottomLeading,
                            endPoint: .topTrailing
                        )
                        .border(
                            LinearGradient(
                                colors: [.mint, .mint, .black],
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            ),
                            width: 4)
                    )
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
        items: ["Driver Name"]
    )
}
