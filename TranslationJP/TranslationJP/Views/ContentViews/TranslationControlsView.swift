import SwiftUI

// This view presents the translation controls including mode picker, input field, and action buttons.
struct TranslationControlsView: View {
    @Binding var selectedMode: TranslationMode
    @Binding var userInput: String
    var isLoading: Bool
    var clearHistoryAction: () -> Void
    var submitAction: () -> Void

    var body: some View {
        VStack {
            ButtonModePicker(selectedMode: $selectedMode)
            UserInputTextEditor(userInput: $userInput)
            HStack(spacing: 8) {
                Spacer()
                ActionButton(title: "Clear History", action: clearHistoryAction)
                Spacer()
                ActionButton(title: "Translate", action: submitAction, isLoading: isLoading)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}
