//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-02-10.
//

import SwiftUI

class EmojiMemoryGame {
    static let emojis = ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚛", "🚜", "🛵", "🚚", "🛸", "🚅", "🚀", "🚤", "🚠", "🛩" ]
    
    static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    private(set) var model = createMemoryGame()
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
}
