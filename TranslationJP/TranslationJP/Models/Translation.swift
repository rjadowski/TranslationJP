import SwiftUI

struct Translation: Identifiable {
    let id = UUID()
    let original: String
    let translated: String
    let mode: TranslationMode
}

