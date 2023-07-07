import SwiftUI
import Introspect

// Custom hosting controller to modify status bar style
class HostingController<Content>: UIHostingController<Content> where Content: View {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        // Setting light content for status bar
        return .lightContent
    }
}

struct ContentView: View {
    // State variables for user input, translations, loading indicators and selected translation mode
    @State private var userInput: String = ""
    @State private var translations: [Translation] = []
    @State private var isLoading: Bool = false
    @State private var selectedMode: TranslationMode = .formalJapanese
    @State private var enlargedTranslation: Translation?
    @State private var showLoading: Bool = false
    
    // API service instance
    private let apiService: APIService
    
    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // View components
                    BannerView()
                    TranslationControlsView(
                        selectedMode: $selectedMode,
                        userInput: $userInput,
                        isLoading: isLoading,
                        clearHistoryAction: clearHistory,
                        submitAction: submitAction
                    )
                    TranslationList(translations: $translations, enlargedTranslation: $enlargedTranslation)
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .background(Color.primaryBackground)
                .edgesIgnoringSafeArea(.bottom)
                .onTapGesture {
                    hideKeyboard()
                }
                // Loading view that appears when making an API request
                if showLoading {
                    LoadingView()
                }
            }
        }
    }
    
    // Submit action to translate the user's input
    func submitAction() {
        let inputText = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !inputText.isEmpty else { return }

        hideKeyboard()
        isLoading = true
        showLoading = true
        apiService.translate(text: inputText, mode: selectedMode) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                self.showLoading = false

                switch result {
                case .success(let translatedText):
                    let newTranslation = Translation(original: inputText, translated: translatedText)
                    self.translations.append(newTranslation)
                    self.userInput = ""
                    
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    
    
    // Function to clear the translation history
    func clearHistory() {
        translations.removeAll()
    }
}


// Previews of the ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
