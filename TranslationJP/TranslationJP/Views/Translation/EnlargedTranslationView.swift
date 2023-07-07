import SwiftUI
import AVFoundation

// View to display enlarged translation text, and hear audio of the translation
struct EnlargedTranslationView: View {
    let translation: String
    let mode: TranslationMode
    let synthesizer = AVSpeechSynthesizer()
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
                        
                        // Button to play audio
                        Button(action: {
                            speakText(translation)
                        }) {
                            Image(systemName: "speaker.3")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
                }
            }
        }
        .foregroundColor(.white)
    }
    
    func speakText(_ text: String) {
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = voiceForMode()
            synthesizer.speak(utterance)
        }
        
        func voiceForMode() -> AVSpeechSynthesisVoice? {
            switch mode {
            case .formalJapanese, .casualJapanese:
                return AVSpeechSynthesisVoice(language: "ja-JP")
            case .english:
                return AVSpeechSynthesisVoice(language: "en-US")
            }
        }
    }
