//
//  SeasonSelector.swift
//  F1App
//
//  Created by Arman Husic on 5/1/24.
//

import SwiftUI

struct SeasonSelector: View {
    @State internal var currentSeason = String(Calendar.current.component(.year, from: Date()))
    internal var action: (String) -> Void

    var years: [String] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (1950...currentYear).reversed().map(String.init)
    }

    var body: some View {
        VStack{
            menu
        }
        .cornerRadius(12.0)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    internal var menu: some View {
        Menu {
            ForEach(years, id: \.self) { year in
                Button(year) {
                    self.currentSeason = year
                    self.action(year)
                    print("User selected season: \(year)")
                }
            }
        } label: {
            HStack {
                Text("Select F1 Season: \(currentSeason)")
                    .font(.body)
                    .bold()
                Spacer()
                Image(systemName: "chevron.down")
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .background(.clear)
            .foregroundStyle(Color.white)
        }
    }
}
