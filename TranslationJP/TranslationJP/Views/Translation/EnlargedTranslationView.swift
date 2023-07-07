import SwiftUI

// View to display enlarged translation text in a modal
struct EnlargedTranslationView: View {
    let translation: String
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.primaryBackground.edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
                ScrollView {
                    VStack(spacing: 16) {
                        Spacer()
                        Text(translation)
                            .font(.system(size: 36))
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
        }
        .foregroundColor(.white)
    }
}
