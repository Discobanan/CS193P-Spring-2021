//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Jonny Johansson on 2022-05-03.
//

import SwiftUI

struct PaletteChooser: View {
    var emojiFontSize: CGFloat
    var emojiFont: Font { .system(size: emojiFontSize) }
    
    @EnvironmentObject var store: PaletteStore

    @SceneStorage("choosenPaletteIndex") private var choosenPaletteIndex = 0
    
    var body: some View {
        HStack{
            paletteControlButton
            body(for: store.palette(at: choosenPaletteIndex))
        }
        .clipped()
    }
    
    @ViewBuilder
    var contextMenu: some View {
        AnimatedActionButton(title: "Edit", systemImage: "pencil", action: {
            //editing = true
            paletteToEdit = store.palette(at: choosenPaletteIndex)
        })
        AnimatedActionButton(title: "New", systemImage: "plus", action: {
            store.insertPalette(named: "New", emojis: "", at: choosenPaletteIndex)
            //editing = true
            paletteToEdit = store.palette(at: choosenPaletteIndex)
        })
        AnimatedActionButton(title: "Delete", systemImage: "minus.circle", action: {
            choosenPaletteIndex = store.removePalette(at: choosenPaletteIndex)
        })
        AnimatedActionButton(title: "Manager", systemImage: "slider.vertical.3", action: {
            managing = true
        })
        gotoMenu
    }
    
    var gotoMenu: some View {
        Menu {
            ForEach (store.palettes) { palette in
                AnimatedActionButton(title: palette.name) {
                    if let index = store.palettes.index(matching: palette) {
                        choosenPaletteIndex = index
                    }
                }
            }
        } label: {
            Label("Go to", systemImage: "text.insert")
        }
    }
    
    var paletteControlButton: some View {
        Button {
            withAnimation {
                choosenPaletteIndex = (choosenPaletteIndex + 1) % store.palettes.count
            }
        } label: {
            Image(systemName: "paintpalette")
        }
        .font(emojiFont)
        .contextMenu {
            contextMenu
        }
    }
    
    //@State private var editing = false
    @State private var paletteToEdit: Palette?
    @State private var managing = false

    func body(for palette: Palette) -> some View {
        HStack{
            Text(palette.name)
            ScrollingEmoijisView(emojis: palette.emojis)
                .font(emojiFont)
        }
        .id(palette.id)
        .transition(rollTransition)
        .popover(item: $paletteToEdit) { palette in
            PaletteEditor(palette: $store.palettes[palette])
                .wrappedInNavigationViewToMakeDismissable {
                    paletteToEdit = nil
                }
        }
        .sheet(isPresented: $managing) {
            PaletteManager()
        }
    }
    
    var rollTransition: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .offset(x: 0, y: emojiFontSize),
            removal: .offset(x: 0, y: -emojiFontSize)
        )
    }

}

struct ScrollingEmoijisView: View {
    let emojis: String

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis.removingDuplicateCharacters.map { String($0) }, id: \.self) { emoji in
                    Text(emoji).onDrag {
                        NSItemProvider(object: emoji as NSString)
                    }
                }
            }
        }
    }

}
