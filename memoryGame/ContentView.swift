//  ContentView.swift
//  memoryGame
//
//  Created by Joel Ezan on 10/6/24.
//
import SwiftUI

struct ContentView: View {
    
    @State private var sizeIndex = 0
    let sizes = [3, 6, 10]
    
    @State private var cards: [Card] = []
    @State private var selectedCards: [Int] = []
    @State private var matchedCards: Set<Int> = []
    @State private var isFaceUpStates: [Bool] = []
    
    let columns = [GridItem(.adaptive(minimum: 120))] // Adjust minimum width as needed

    var body: some View {
        VStack {
            HStack {
                Picker(selection: $sizeIndex, label: Text("Choose Size").foregroundColor(.white)) {
                    ForEach(0..<sizes.count, id: \.self) { index in
                        Text("\(sizes[index]) pairs").tag(index)
                    }
                }
                .onChange(of: sizeIndex) {
                    startNewGame()
                }
                .pickerStyle(MenuPickerStyle())
                .padding()
                .background(RoundedRectangle(cornerRadius: 25)
                    .fill(Color.orange))
                .frame(width: 150)
                
                Spacer()
                
                Button(action: {
                    startNewGame()
                }) {
                    Text("Reset Game")
                        .foregroundColor(.white)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 25)
                            .fill(Color.green))
                        .frame(width: 150)
                }
            }
            .padding()

            Spacer()

            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(0..<cards.count, id: \.self) { index in
                        if matchedCards.contains(index) {
                            // Create an empty view for matched cards
                            Color.clear
                                .frame(width: 110, height: 150) // Match the size of the cards
                        } else {
                            CardView(isFaceUp: $isFaceUpStates[index], card: cards[index])
                                .onTapGesture {
                                    selectCard(at: index)
                                }
                                .padding()
                        }
                    }
                }
            }
        }
        .onAppear {
            startNewGame()
        }
    }
    
    func startNewGame() {
        let numberOfPairs = sizes[sizeIndex]
        let chosenCards = Card.mockedCards.shuffled().prefix(numberOfPairs)
        cards = (Array(chosenCards) + Array(chosenCards)).shuffled()
        isFaceUpStates = Array(repeating: false, count: cards.count)
        selectedCards = []
        matchedCards = []
    }
    
    func selectCard(at index: Int) {
        if matchedCards.contains(index) { return }
        if selectedCards.count == 2 { return }
        
        if !isFaceUpStates[index] {
            isFaceUpStates[index].toggle()
            selectedCards.append(index)
        }
        
        if selectedCards.count == 2 {
            let firstCardIndex = selectedCards[0]
            let secondCardIndex = selectedCards[1]

            if cards[firstCardIndex] == cards[secondCardIndex] {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    matchedCards.insert(firstCardIndex)
                    matchedCards.insert(secondCardIndex)
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isFaceUpStates[firstCardIndex] = false
                    isFaceUpStates[secondCardIndex] = false
                }
            }
            selectedCards = []
        }
    }
}

#Preview {
    ContentView()
}
