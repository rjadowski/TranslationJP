import SwiftUI

struct TranslationView: View {
    let translation: Translation
    @Binding var enlargedTranslation: Translation?
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(translation.original)
                .foregroundColor(Color.customAccentColor)
                .lineLimit(nil)
                .truncationMode(.tail)
                .padding(.horizontal, 8)
            Text(translation.translated)
                .font(.callout)
                .foregroundColor(Color.white)
                .cornerRadius(8)
                .lineLimit(nil)
                .truncationMode(.tail)
                .onTapGesture {
                    generateHapticFeedback()
                    enlargedTranslation = translation
                }
                .background(
                    NavigationLink("", isActive: Binding(
                        get: { enlargedTranslation != nil },
                        set: { isActive in
                            if !isActive {
                                enlargedTranslation = nil
                            }
                        }
                    ), destination: {
                        EnlargedTranslationView(translation: enlargedTranslation?.translated ?? "")
                    })
                )
                .buttonStyle(PlainButtonStyle())
                .padding(.horizontal, 8)
        }
        .padding()
        .background(Color.secondaryBackground)
        .cornerRadius(8)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .transition(.opacity)
    }
}
