//
//  QueryResultsGrid.swift
//  F1App
//
//  Created by Arman Husic on 5/2/24.
//

import SwiftUI

struct QueryResultsGrid<T, Content: View>: View where T: Identifiable {
    internal var items: [T]
    internal var rows: [GridItem]
    internal var content: (T) -> Content
    internal var selectionAction: (T) -> Void
    
    internal var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 20) {
                ForEach(items) { item in
                    Button(action: {selectionAction(item)}) {
                        content(item)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}
