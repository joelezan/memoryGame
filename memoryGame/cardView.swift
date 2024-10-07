//  cardView.swift
//  memoryGame
//
//  Created by Joel Ezan on 10/6/24.
//
import SwiftUI

struct CardView: View {
    @Binding var isFaceUp: Bool
    let card: Card
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(isFaceUp ? Color.white.gradient : Color.blue.gradient)
                .frame(width: 110, height: 150)
                .overlay(
                    isFaceUp ? Image(systemName: card.text)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.red)
                    : nil
                )
        }
        .padding(0)
    }
}

struct Card: Equatable {
    let text: String
    
    static let mockedCards = [
        Card(text: "fleuron.fill"),
        Card(text: "fan.fill"),
        Card(text: "seal"),
        Card(text: "scale.3d"),
        Card(text: "leaf.fill"),
        Card(text: "star.fill"),
        Card(text: "heart.fill"),
        Card(text: "sun.max.fill"),
        Card(text: "cloud.fill"),
        Card(text: "moon.fill")
    ]
}

#Preview {
    CardView(isFaceUp: .constant(false), card: Card.mockedCards[0])
}
