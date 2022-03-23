//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-02-10.
//

import SwiftUI

struct ThemeData {
    var name: String
    var cards: Int
    var color: Color
    var emojis: [String]
}

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
    private static let themes = [
        ThemeData(name: "Vehicles", cards: 10, color: .red, emojis: [ "🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚛", "🚜", "🛵", "🚚", "🛸", "🚅", "🚀", "🚤", "🚠", "🛩" ] ),
        ThemeData(name: "Animals", cards: 8, color: .green, emojis: [ "🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐵", "🦄" ] ),
        ThemeData(name: "Fruits", cards: 6, color: .blue, emojis: [ "🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🫐", "🥝", "🍒", "🍑" ] ),
        ThemeData(name: "Hands", cards: 4, color: .cyan, emojis: [ "🤛", "🤜", "✌️", "🤘", "👌", "👇", "🖐", "👋", "🤙", "🖕", "🙌", "👊" ] ),
        ThemeData(name: "Flags", cards: 2, color: .purple, emojis: [ "🇦🇴", "🇦🇮", "🇦🇶", "🇦🇬", "🇦🇷", "🇦🇲", "🇦🇼", "🇦🇺", "🇦🇹", "🇧🇯", "🇧🇬", "🇧🇫" ] ),
        ThemeData(name: "Office", cards: 100, color: .yellow, emojis: [ "📨", "📊", "📈", "📎", "📐", "✂️", "🖋", "🖊", "📌", "📔", "📚", "🗄" ] )
    ]
    
    @Published private(set) var model = createMemoryGame(withThemeName: themes.randomElement()?.name ?? "Vehicles")
   
    static func createMemoryGame(withThemeName themeName: String) -> MemoryGame<String> {
        var theme = self.themes.first { $0.name == themeName }! // Crash if theme doesn't exist, shouldn't happens, so probably fine...
        theme.emojis.shuffle()
        
        let numberOfPairs = theme.cards > theme.emojis.count ? theme.emojis.count : theme.cards
        
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs, color: theme.color, title: theme.name) { pairIndex in
            return theme.emojis[pairIndex]
        }
    }
    
    var cards: Array<Card> {
        return model.cards
    }
    
    var color: Color {
        return model.color
    }
    
    var currentScore: Int {
        return model.currentScore
    }
    
    var title: String {
        return model.title
    }
    
    // MARK: - Intent(s)
    
    func choose(_ card: Card) {
        model.choose(card)
    }

    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame(withThemeName: EmojiMemoryGame.themes.randomElement()?.name ?? "Vehicles")
    }
    
    func startNewGame() {
        guard let randomTheme = EmojiMemoryGame.themes.randomElement() else { return }
        model = EmojiMemoryGame.createMemoryGame(withThemeName: randomTheme.name)
    }

}
