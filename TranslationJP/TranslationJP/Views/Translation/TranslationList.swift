import SwiftUI

struct TranslationList: View {
    @Binding var translations: [Translation]
    @Binding var enlargedTranslation: Translation?
    @State private var copiedTranslationID: UUID? = nil
    
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(translations.reversed()) { translation in
                    HStack {
                        Button(action: {
                            withAnimation {
                                translations.removeAll { $0.id == translation.id }
                            }
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        TranslationView(translation: translation, enlargedTranslation: $enlargedTranslation)
                            .padding(.bottom, 2)
                        
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
                        .buttonStyle(PlainButtonStyle())
                    }
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
