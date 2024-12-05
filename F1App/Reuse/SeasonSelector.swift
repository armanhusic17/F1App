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
        case selectSeasonText = "Select a Season"
        case chevronImg = "chevron.down"
    }

    var body: some View {
        VStack{
            menuTitle
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
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    Text("\(currentSeason)")
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                    Image(systemName: Constant.chevronImg.rawValue)
                }
                .padding([ .bottom], 16)
                .frame(maxWidth: 200, alignment: .center)
                .background(.clear)
                .foregroundStyle(Color.white)
            }
        })
    }
    
    @ViewBuilder var menuTitle: some View {
        VStack(alignment: .leading) {
            Text("\(Constant.selectSeasonText.rawValue)")
                .font(.caption)
                .padding(.horizontal, 24)
                .foregroundStyle(Color.white.opacity(0.5))
                .frame(maxWidth: .greatestFiniteMagnitude, alignment: .leading)
                .padding(.bottom, 8)
        }
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
                                    
                                }
                            }) {
                                Text("\(year)")
                                    .bold()
                                    .font(.title)
                                    .foregroundStyle(.white.opacity(0.75))
                                    .padding([.top, .bottom], 12)
                                    .frame(maxWidth: .infinity, alignment: .center)

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
    SeasonSelector(currentSeason: .constant("2024")) { season in
        print(season)
    }
}
