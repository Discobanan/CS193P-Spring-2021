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
    private(set) var currentScore: Int
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get {
            cards.indices.filter({
                cards[$0].isFaceUp
            }).oneAndOnly
        }
        set {
            cards.indices.forEach({
                cards[$0].isFaceUp = ($0 == newValue)
            })
        }
    }
    
    init(numberOfPairsOfCards: Int, color: Color, title: String, createCardContent: (Int) -> CardContent) {
        self.color = color
        self.cards = []
        self.title = title
        self.currentScore = 0
               
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            
            self.cards.append(Card(content: content, id: pairIndex*2))
            self.cards.append(Card(content: content, id: pairIndex*2+1))
        }
        self.cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        guard let choosenIndex = cards.firstIndex(where: { $0.id == card.id }),
                !cards[choosenIndex].isFaceUp,
                !cards[choosenIndex].isMatched
        else {
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
            
            cards[choosenIndex].isFaceUp = true
        } else {
            indexOfTheOneAndOnlyFaceUpCard = choosenIndex
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    struct Card: Identifiable {
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContent
        let id: Int
        
        // MARK: - Bonus Time
        
        // this could give matching bonus points
        // if the user matches the card
        // before a certain amount of time passes during which the card is face up
        
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = 10
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        // the last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        // the accumulated time this card has been face up in the past
        // (i.e. not including the current time it's been face up if it is currently so)
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime: Bool {
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
}

extension Array {
    var oneAndOnly: Element? {
        self.count == 1 ? self.first : nil
    }
}
