import SwiftUI

// This view presents the original and translated texts.
struct TranslationView: View {
    let translation: Translation
    @Binding var enlargedTranslation: Translation?
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(translation.original)
                .foregroundColor(Color.customAccentColor)
                .padding(.horizontal, 8)
            
            Text(translation.translated)
                .onTapGesture {
                    generateHapticFeedback()
                    enlargedTranslation = translation
                }
                .padding(.horizontal, 8)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.opacity)
    }
}
