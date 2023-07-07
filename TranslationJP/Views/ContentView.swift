import SwiftUI
import Introspect

class HostingController<Content>: UIHostingController<Content> where Content: View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

struct ContentView: View {
    @State private var userInput: String = ""
    @State private var translations: [Translation] = []
    @State private var isLoading: Bool = false
    @State private var selectedMode: TranslationMode = .formalJapanese
    @State private var enlargedTranslation: Translation?
    @State private var showLoading: Bool = false
    
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Image("Banner")
                        .resizable(resizingMode: .stretch)
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 130.0, height: 25.0)
                        .padding(.vertical)
                        .padding(8)
                        .padding(.bottom, 4)
                    ButtonModePicker(selectedMode: $selectedMode)
                    UserInputTextEditor(userInput: $userInput)
                    
                    HStack(spacing: 8) {
                        Spacer()
                        ActionButton(title: "Clear History", action: {
                            generateHapticFeedback()
                            clearHistory()
                        })
                        Spacer()
                        ActionButton(title: "Translate", action: {
                            generateHapticFeedback()
                            submitAction()
                        }, isLoading: isLoading)
                        
                        Spacer()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    
                    TranslationList(translations: $translations, enlargedTranslation: $enlargedTranslation)
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.primaryBackground)
                .edgesIgnoringSafeArea(.bottom)
                .onTapGesture {
                    hideKeyboard()
                }
                if showLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.customAccentColor))
                        .scaleEffect(2.0)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.primaryBackground.opacity(0.5))
                        .edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
    
    func submitAction() {
        let inputText = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !inputText.isEmpty else { return }
        
        hideKeyboard()
        isLoading = true
        showLoading = true
        apiService.translate(text: inputText, mode: selectedMode) { translatedText, error in
            DispatchQueue.main.async {
                isLoading = false
                showLoading = false
                
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                guard let translatedText = translatedText else {
                    print("Translated text is nil")
                    return
                }
                
                let newTranslation = Translation(original: inputText, translated: translatedText)
                
                
                translations.append(newTranslation)
                userInput = ""
            }
        }
    }
    
    
    func clearHistory() {
        translations.removeAll()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
