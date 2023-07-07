import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        VStack {
            Image("Banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 400.0, height: 100.0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primaryBackground)
        .edgesIgnoringSafeArea(.all)
        .foregroundColor(.white)
    }
}
