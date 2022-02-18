//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-02-10.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚛", "🚜", "🛵", "🚚", "🛸", "🚅", "🚀", "🚤", "🚠", "🛩" ]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in
            emojis[pairIndex]
        }
    }

    @Published private(set) var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
}
