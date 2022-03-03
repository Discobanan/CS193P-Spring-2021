//
//  ContentView.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-01-27.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame

    var body: some View {
        ScrollView {
            ZStack {
                Text(viewModel.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)// Task 14
                HStack {
                    Spacer()
                    Text("Score: \(viewModel.currentScore)")// Task 16
                }
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 65, maximum: 75))]) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card, color: viewModel.color)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture{
                            viewModel.choose(card)
                        }
                }
            }
            
            Button("New game", action: viewModel.startNewGame) // Task 10
        }
        //.foregroundColor(viewModel.color)
        .padding(.all)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    let color: Color
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            
            if card.isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3).foregroundColor(color)
                Text(card.content).font(.largeTitle)
            } else if card.isMatched {
                shape.opacity(0)
            } else {
                shape.fill().foregroundColor(color)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        ContentView(viewModel: game)
            .preferredColorScheme(.dark)
        
        ContentView(viewModel: game)
            .preferredColorScheme(.light)
    }
}
