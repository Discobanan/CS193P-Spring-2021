//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Jonny Johansson on 2022-03-24.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    let document = EmojiArtDocument()
    
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: document)
        }
    }
}
