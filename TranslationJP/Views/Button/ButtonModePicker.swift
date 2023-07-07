import SwiftUI

struct ButtonModePicker: View {
    @Binding var selectedMode: TranslationMode
    
    var body: some View {
        HStack {
            ForEach(TranslationMode.allCases, id: \.self) { mode in
                Button(action: {
                    selectedMode = mode
                }) {
                    Text(mode.rawValue)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .buttonStyle(PrimaryButtonStyle(
                    backgroundColor: selectedMode == mode ? Color.customAccentColor : Color.secondaryBackground,
                    textColor: selectedMode == mode ? Color.white : Color.white,
                    height: 46,
                    cornerRadius: 8,
                    fontSize: 15,
                    disabled: false,
                    textSidePadding: 10,
                    weight: .semibold
                ))
            }
            .padding()
            .frame(maxWidth: .infinity)
        }
    }
}
