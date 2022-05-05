//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Jonny Johansson on 2022-03-24.
//

import SwiftUI
import Combine

class EmojiArtDocument: ObservableObject {
    @Published private(set) var emojiArt: EmojiArtModel {
        didSet {
            scheduleAutoSave()
            if emojiArt.background != oldValue.background {
                fetchBackgroundImageDataIfNecessary()
            }
        }
    }
    
    private var autoSaveTimer: Timer?
    
    private func scheduleAutoSave() {
        autoSaveTimer?.invalidate()
        autoSaveTimer = Timer.scheduledTimer(withTimeInterval: AutoSave.interval, repeats: false) { _ in
            self.autoSave()
        }
    }
    
    private struct AutoSave {
        static let filename = "Autosaved.emojiart"
        static var url: URL? {
            let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            return documentDir?.appendingPathComponent(filename)
        }
        static let interval: Double = 5
    }
    
    private func autoSave() {
        if let url = AutoSave.url {
            save(to: url)
        }
    }
    
    private func save(to url: URL) {
        let thisFunction = "\(String(describing: self)).\(#function)"
        do {
            let data: Data = try emojiArt.json()
            print("\(thisFunction) JSON = \(String(data: data, encoding: .utf8) ?? "nil")!")
            try data.write(to: url)
            print("\(thisFunction) Saved!")
        } catch let encodingError where encodingError is EncodingError {
            print("\(thisFunction) encoding error = \(encodingError.localizedDescription)")
        } catch {
            print("\(thisFunction) error = \(error)")
        }
    }
    
    init() {
        if let url = AutoSave.url, let autoSavedEmojiArt = try? EmojiArtModel(url: url) {
            emojiArt = autoSavedEmojiArt
            fetchBackgroundImageDataIfNecessary()
        } else {
            emojiArt = EmojiArtModel()
            emojiArt.addEmoji("🪃", at: (-200, -100), size: 100)
            emojiArt.addEmoji("🐶", at: (50, 100), size: 200)
        }
    }
    
    var emojis: [EmojiArtModel.Emoji] {
        emojiArt.emojis
    }

    var background: EmojiArtModel.Background {
        emojiArt.background
    }
    
    @Published var backgroundImage: UIImage?
    @Published var backgroundImageFetchStatus: BackgroundImageFetchStatus?
    
    enum BackgroundImageFetchStatus : Equatable {
        case idle
        case fetching
        case failed(URL)
    }

    // MARK: - Private funcs
    
    private var backGroundImageFetchCancellable: AnyCancellable?
    
    private func fetchBackgroundImageDataIfNecessary() {
        backgroundImage = nil
        switch(emojiArt.background) {
        case .url(let url):
            backgroundImageFetchStatus = .fetching
            backGroundImageFetchCancellable?.cancel()

            let session = URLSession.shared
            let publisher = session.dataTaskPublisher(for: url)
                .map { (data, urlResponse) in UIImage(data: data) }
                .replaceError(with: nil)
                .receive(on: DispatchQueue.main)
            
            backGroundImageFetchCancellable = publisher
                .assign(to: \EmojiArtDocument.backgroundImage, on: self)
//                .sink{ [weak self] image in
//                    self?.backgroundImage = image
//                    self?.backgroundImageFetchStatus = image != nil ? .idle : .failed(url)
//                }
            
            
            
//            DispatchQueue.global(qos: .userInitiated).async {
//                if let imageData = try? Data(contentsOf: url) {
//                    DispatchQueue.main.async { [weak self] in
//                        if self?.emojiArt.background == EmojiArtModel.Background.url(url) {
//                            self?.backgroundImageFetchStatus = .idle
//                            self?.backgroundImage = UIImage(data: imageData)
//                        }
//
//                        if self?.backgroundImage == nil {
//                            self?.backgroundImageFetchStatus = .failed(url)
//                        }
//                    }
//                }
//            }
        case .imageData(let data):
            backgroundImage = UIImage(data: data)
        case .blank:
            break
        }
    }
    
    // MARK: - Intents
    
    func setBackground(_ background: EmojiArtModel.Background) {
        emojiArt.background = background
    }
    
    func addEmoji(_ emoji: String, at location: (x: Int, y: Int), size: CGFloat) {
        emojiArt.addEmoji(emoji, at: location, size: Int(size))
    }
    
    func moveEmoji(_ emoji: EmojiArtModel.Emoji, by offset: CGSize) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].x += Int(offset.width)
            emojiArt.emojis[index].y += Int(offset.height)
        }
    }
    
    func scaleEmoji(_ emoji: EmojiArtModel.Emoji, by scale: CGFloat) {
        if let index = emojiArt.emojis.index(matching: emoji) {
            emojiArt.emojis[index].size = Int((CGFloat(emojiArt.emojis[index].size) * scale).rounded(.toNearestOrAwayFromZero))
        }
    }
}
