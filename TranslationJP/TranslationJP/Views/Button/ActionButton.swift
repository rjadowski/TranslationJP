import SwiftUI

struct ActionButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    
    var body: some View {
        Button(title, action: action)
            .buttonStyle(PrimaryButtonStyle())
            .disabled(isLoading)
    }
}
