
import SwiftUI

struct BannerView: View {
    var body: some View {
        Image("Banner")
            .resizable(resizingMode: .stretch)
            .aspectRatio(contentMode: .fill)
            .frame(width: 130.0, height: 25.0)
            .padding(.vertical)
            .padding(8)
            .padding(.bottom, 4)
    }
}
