import SwiftUI

@main
struct TranslationJPApp: App {
    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.primaryBackground
                    .edgesIgnoringSafeArea(.all)

                if appState.isLaunchScreenShowing {
                    LaunchScreenView()
                        .opacity(appState.launchScreenOpacity)
                        .onAppear(perform: switchToContentView)
                } else {
                    ContentView()
                        .opacity(appState.contentOpacity)
                        .onAppear {
                            if !appState.didAppear {
                                appState.didAppear = true
                            }
                        }
                }
            }
        }
    }

    func switchToContentView() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            appState.launchScreenOpacity = 0.0
            appState.contentOpacity = 1.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appState.isLaunchScreenShowing = false
            }
        }
    }
}

class AppState: ObservableObject {
    @Published var isLaunchScreenShowing = true
    @Published var launchScreenOpacity = 1.0
    @Published var contentOpacity = 0.0
    @Published var didAppear = false
}
