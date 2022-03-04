//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-01-27.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game: EmojiMemoryGame

    var body: some View {
        ScrollView {
            ZStack {
                Text(game.title)
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                HStack {
                    Spacer()
                    Text("Score: \(game.currentScore)")
                }
            }
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 75))]) {
                ForEach(game.cards) { card in
                    
                    CardView(card: card, color: game.color)
                        .aspectRatio(2/3, contentMode: .fit)
                        .onTapGesture{
                            game.choose(card)
                        }
                }
            }
            
            Button("New game", action: game.startNewGame)
        }
        //.foregroundColor(viewModel.color)
        .padding(.all)
    }
}

struct CardView: View {
    let card: EmojiMemoryGame.Card
    let color: Color
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                
                if card.isFaceUp {
                    shape.fill().foregroundColor(.white)
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth).foregroundColor(color)
                    Text(card.content).font(font(in: geometry.size))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape.fill().foregroundColor(color)
                }
            }
        })
    }
    
    private func font(in size: CGSize) -> Font {
        Font.system(size: min(size.width, size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let cornerRadius: CGFloat = 20
        static let lineWidth: CGFloat = 3
        static let fontScale: CGFloat = 0.75
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
        
        EmojiMemoryGameView(game: game)
            .preferredColorScheme(.light)
    }
}
