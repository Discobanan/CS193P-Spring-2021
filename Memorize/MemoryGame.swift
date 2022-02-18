//
//  MemoryGame.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-02-10.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = Array<Card>()
        
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            
            cards.append(Card(content: content, id: pairIndex*2))
            cards.append(Card(content: content, id: pairIndex*2+1))
        }
    }
    
    mutating func choose(_ card: Card) {
        guard let choosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[choosenIndex].isFaceUp, !cards[choosenIndex].isMatched else {
            return
        }
    
        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            if cards[choosenIndex].content == cards[potentialMatchIndex].content {
                cards[choosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
            }
            indexOfTheOneAndOnlyFaceUpCard = nil
        } else {
            for index in cards.indices {
                cards[index].isFaceUp = false
            }
            indexOfTheOneAndOnlyFaceUpCard = choosenIndex
        }
        
        cards[choosenIndex].isFaceUp.toggle()
    
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}
