//
//  ContentView.swift
//  Memorize
//
//  Created by Jonny Johansson on 2022-01-27.
//

import SwiftUI

enum Theme: String {
    case vehicles = "Vehicles2"
    case animals = "animals2"
    case fruits = "fruits2"
    
    var description: String {
        switch self {
            case .vehicles: return "Vehicles"
            case .animals: return "Animals"
            case .fruits: return "Fruits"
        }
    }
}

struct ContentView: View {
    var themes: [Theme: [String]] = [
        Theme.vehicles: ["🚗", "🚕", "🚙", "🚌", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚛", "🚜", "🛵", "🚚", "🛸", "🚅", "🚀", "🚤", "🚠", "🛩" ],
        Theme.animals:  ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐵", "🦄" ],
        Theme.fruits:   ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🫐", "🥝", "🍒", "🍑" ],
    ]
         
    @State var emojis: [String]
    
    init() {
        emojis = themes[.vehicles]!.shuffled()
    }
    
    var body: some View {
        VStack(alignment: .center) {
            let title = "Memorize!"
            Text(title).font(.largeTitle)
            //.foregroundColor(Color(UIColor.systemBackground)).colorInvert()
           
            ScrollView {
                let minSize = CGFloat((1/Double(emojis.count)) * 1000)
                let maxSize = CGFloat(minSize * 2)
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: minSize, maximum: maxSize))]) {
                    ForEach(emojis[0..<emojis.count], id: \.self) { emoji in
                        CardView(content: emoji)
                            .aspectRatio(2/3, contentMode: .fit)
                    }
                }
            }
            .foregroundColor(.red)
            
            Spacer()
            
            HStack {
                buttonWithIcon("car", forTheme: .vehicles)
                Spacer()
                buttonWithIcon("hare", forTheme: .animals)
                Spacer()
                buttonWithIcon("leaf", forTheme: .fruits)
            }
            .padding(.horizontal)
            .font(.largeTitle)
        }
        .padding(.all)
    }
    
    
}

extension ContentView {
    func buttonWithIcon(_ icon: String, forTheme theme: Theme) -> some View {
        return Button(action: {
            emojis = assignEmojis(forTheme: theme)
        }, label: {
            VStack {
                Image(systemName: icon)
                Text(theme.rawValue).font(.caption)
            }
        })
    }

    func assignEmojis(forTheme theme: Theme = .vehicles) -> [String] {
        guard let emojis = themes[theme] else { return [] }
        
        //emojis.shuffl
        let shuffeledEmojis = emojis.shuffled()
        let maxCount = emojis.count
        let randomCount = Int.random(in: 4...maxCount)
        let randomEmojis = Array(shuffeledEmojis[0..<randomCount])
        
        return randomEmojis
        
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
        
        ContentView()
            .preferredColorScheme(.light)
        
        
    }
}
