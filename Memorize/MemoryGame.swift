//
//  MemoryGame.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-02-10.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var color: Color
    private(set) var title: String
    private(set) var currentScore: Int // Task 15
    private var indexOfTheOneAndOnlyFaceUpCard: Int?
    
    init(numberOfPairsOfCards: Int, color: Color, title: String, createCardContent: (Int) -> CardContent) {
        self.color = color
        self.cards = Array<Card>()
        self.title = title
        self.currentScore = 0
               
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            
            self.cards.append(Card(content: content, id: pairIndex*2))
            self.cards.append(Card(content: content, id: pairIndex*2+1))
        }
        self.cards.shuffle() // Task 13
    }
    
    mutating func choose(_ card: Card) {
        guard let choosenIndex = cards.firstIndex(where: { $0.id == card.id }), !cards[choosenIndex].isFaceUp, !cards[choosenIndex].isMatched else {
            return
        }
    
        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            if cards[choosenIndex].content == cards[potentialMatchIndex].content {
                cards[choosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
                currentScore += 2
            } else {
                currentScore -= 1
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
        var isFaceUp = false // Task 12
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}
