//
//  ContentView.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-01-27.
//

import SwiftUI

struct ContentView: View {
    var emojis = [ "💩", "🚗", "☠️", "🚯", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" ]
    
    @State var emojiCount = 20
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 75, maximum: 100))]) {
                    ForEach(emojis[0..<emojiCount], id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            
            Spacer()
            
            HStack {
                minusButton
                Spacer()
                plusButton
                
            }
            .padding(.horizontal)
            .font(.largeTitle)
            .foregroundColor(.orange)
            
        }
        .padding(.all)
    }
    
    
    
    
    var minusButton: some View {
        Button(action: {
            if (emojiCount > 1) {
                emojiCount -= 1
            }
        }, label: {
            Image(systemName: "minus.circle")
        })
    }
    
    var plusButton: some View {
        Button(action: {
            if (emojiCount < emojis.count) {
                emojiCount += 1
            }
        }, label: {
            Image(systemName: "plus.circle")
        })
    }
}

struct CardView: View {
    var content = "❓"
    @State var isFaceUp = true
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 20)
            
            if isFaceUp {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3)
                Text(content).font(.largeTitle)
            } else {
                shape.fill().foregroundColor(.green)
            }
        }
        .onTapGesture{
            isFaceUp = !isFaceUp
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
.previewInterfaceOrientation(.portraitUpsideDown)
        
        ContentView()
            .preferredColorScheme(.light)
        
        
    }
}
