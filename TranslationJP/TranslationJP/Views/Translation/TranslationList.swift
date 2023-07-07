import SwiftUI

// View to display a list of translations
struct TranslationList: View {
    @Binding var translations: [Translation]
    @Binding var enlargedTranslation: Translation?
    @State private var copiedTranslationID: UUID? = nil
    
    // Delete function to remove a translation from the list
    func delete(at translation: Translation) {
        withAnimation {
            translations.removeAll { $0.id == translation.id }
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(translations.reversed()) { translation in
                    HStack {
                        // Button to delete a translation
                        Button(action: {
                            delete(at: translation)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        
                        // The actual translation view
                        TranslationView(translation: translation, enlargedTranslation: $enlargedTranslation)
                            .padding(.bottom, 2)
                        
                        // Button to copy a translation
                        Button(action: {
                            UIPasteboard.general.string = translation.translated
                            copiedTranslationID = translation.id
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    copiedTranslationID = nil
                                }
                            }
                        }) {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                        }
                    }
                    // Confirmation text if a translation is copied
                    if copiedTranslationID == translation.id {
                        Text("Copied!")
                            .font(.footnote)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
        }
    }
}
