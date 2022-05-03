//
//  PaletteEditor.swift
//  EmojiArt
//
//  Created by Jonny Johansson on 2022-05-03.
//

import SwiftUI

struct PaletteEditor: View {
    @Binding var palette: Palette
    
    var body: some View {
        Form {
            nameSection
            emojisSection
            removeEmojiSection
        }
        
        .navigationTitle("Edit \(palette.name)")
        .frame(minWidth: 300, minHeight: 350)
    }
    
    var nameSection: some View {
        Section(header: Text("Name"))
        {
            TextField("Name", text: $palette.name)
        }

    }
    
    @State private var emojisToAdd = ""
    
    var emojisSection: some View {
        Section(header: Text("Add Emojis"))
        {
            TextField("", text: $emojisToAdd)
                //.lineLimit(1)
                //.keyboardType(.alphabet)
                //.textContentType(.emailAddress)
                .onChange(of: emojisToAdd, perform: { emojis in
                    addEmojis(emojis)
                })
        }

    }
    
    func addEmojis(_ emojis: String) {
        withAnimation {
            palette.emojis = (emojis + palette.emojis)
                .filter { $0.isEmoji }
                .removingDuplicateCharacters
        }
    }
    
    var removeEmojiSection: some View {
        Section(header: Text("Remove emoji")) {
            let emojis = palette.emojis.removingDuplicateCharacters.map { String($0) }
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            withAnimation{
                                palette.emojis.removeAll(where: {
                                    String($0) == emoji
                                })
                            }
                        }
                }
            }
            .font(.system(size: 40))
        }
    }
    
}

struct PaletteEditor_Previews: PreviewProvider {
    static var previews: some View {
        PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 4)))
            .previewLayout(.fixed(width: 320.0, height: 400.0))

        PaletteEditor(palette: .constant(PaletteStore(named: "Preview").palette(at: 2)))
            .previewLayout(.fixed(width: 320.0, height: 400.0))
    }
}
