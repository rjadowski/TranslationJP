import SwiftUI

// This view displays a loading indicator.
struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color.customAccentColor))
            .scaleEffect(2.0)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primaryBackground.opacity(0.5))
            .edgesIgnoringSafeArea(.all)
    }
}
