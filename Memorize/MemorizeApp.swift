//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-01-27.
//

import SwiftUI

@main
struct MemorizeApp: App {
    let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game: game)
        }
    }
}
