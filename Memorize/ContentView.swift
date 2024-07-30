//
//  ContentView.swift
//  Memorize
//
//  Created by Sem Cruiming on 29/07/2024.
//

import SwiftUI

struct ContentView: View {
    let themes: [String: [String]] = [
        "Halloween 👻": ["👻", "🎃", "🕷️", "😈", "💀", "🧙", "👹", "😱", "☠️"],
        "Winter ❄️": ["❄️", "⛄️", "🎅", "🌨️", "🧣", "🎄", "🔔", "🎁", "🎆"],
        "Food 🍉": ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍒", "🍑"]
    ]
    
    @State private var selectedTheme: String = "Halloween"
    @State private var pairCount: Int = 4
    
    var body: some View {
        VStack {
            Text("Memorize")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Picker("Select Theme", selection: $selectedTheme) {
                ForEach(themes.keys.sorted(), id: \.self) { theme in
                    Text(theme).tag(theme)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .onReceive([self.selectedTheme].publisher.first(), perform: { _ in
                adjustPairCount()
            })
            
            ScrollView {
                cards
            }
            
            Spacer()
            
            cardCountAdjusters
        }
        .padding()
        .onAppear {
            adjustPairCount()
        }
    }
    
    var cards: some View {
        let currentTheme = themes[selectedTheme] ?? []
        let pairs = Array(currentTheme.prefix(pairCount))
        let cards = (pairs + pairs).shuffled() // Ensure each card has a pair and shuffle the cards
        
        return LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cards.count, id: \.self) { index in
                CardView(content: cards[index])
                    .aspectRatio(2/3, contentMode: .fit)
            }
        }
        .foregroundStyle(.orange)
    }
    
    var cardCountAdjusters: some View {
        HStack {
            cardRemover
            Spacer()
            cardAdder
        }
        .imageScale(.large)
        .font(.largeTitle)
    }
    
    func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
        Button(action: {
            let newPairCount = pairCount + offset
            if newPairCount >= 4 && newPairCount <= (themes[selectedTheme]?.count ?? 0) / 2 {
                pairCount = newPairCount
            }
        }, label: {
            Image(systemName: symbol)
        })
    }
    
    var cardRemover: some View {
        cardCountAdjuster(by: -1, symbol: "minus.circle")
    }
    
    var cardAdder: some View {
        cardCountAdjuster(by: +1, symbol: "plus.circle")
    }
    
    func adjustPairCount() {
        switch selectedTheme {
        case "Halloween":
            pairCount = min(4, (themes[selectedTheme]?.count ?? 0) / 2)
        case "Winter":
            pairCount = min(5, (themes[selectedTheme]?.count ?? 0) / 2)
        case "Food":
            pairCount = min(6, (themes[selectedTheme]?.count ?? 0) / 2)
        default:
            pairCount = 4
        }
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp: Bool = false
    
    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(content).font(.largeTitle)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}

#Preview {
    ContentView()
}
