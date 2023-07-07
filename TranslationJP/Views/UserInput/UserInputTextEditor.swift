import SwiftUI

struct UserInputTextEditor: View {
    
    @Binding var userInput: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .foregroundColor(Color.secondaryBackground)
            .overlay(
                TextEditor(text: $userInput)
                    .scrollContentBackground(.hidden)
                    .background(Color.primaryBackground)
                    .padding(8)
            )
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .introspectTextView { textView in
                textView.backgroundColor = .clear
                textView.textColor = .white
            }
    }
}
