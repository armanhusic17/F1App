//
//  SeasonSelector.swift
//  F1App
//
//  Created by Arman Husic on 5/1/24.
//

import SwiftUI

struct SeasonSelector: View {
    @State private var showMenu = false
    @Binding internal var currentSeason: String
    var action: (String) -> Void
    
    var years: [String] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return (1950...currentYear).reversed().map(String.init)
    }
    
    private enum Constant: String {
        case selectSeasonText = "Select F1 Season:"
        case chevronImg = "chevron.down"
    }

    var body: some View {
        VStack{
            menuButton
            dropDownMenu
        }
        .cornerRadius(12.0)
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder var menuButton: some View {
        Button(action: {
            withAnimation {
                showMenu.toggle()
            }
        }, label: {
            HStack(alignment: .center) {
                Text("\(Constant.selectSeasonText.rawValue) \(currentSeason)")
                    .font(.title2)
                    .multilineTextAlignment(.leading)
                Spacer()
                Image(systemName: Constant.chevronImg.rawValue)
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.clear)
            .foregroundStyle(Color.white)
        })
    }
    
    @ViewBuilder var dropDownMenu: some View {
        if showMenu {
            VStack {
                ScrollView {
                    VStack {
                        ForEach(years, id: \.self) { year in
                            Button(action: {
                                if currentSeason != year {
                                    self.currentSeason = year
                                    print("User selected season: \(year)")
                                }
                            }) {
                                Text("\(year)")
                                    .bold()
                                    .font(.title)
                                    .foregroundStyle(.white.opacity(0.75))
                                    .padding(12)

                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .background(.black.opacity(0.2))
                        }
                    }
                }
                .cornerRadius(24)
                .frame(maxHeight: 200)
            }
        }
    }
}

#Preview {
    HomeScreen()
}
