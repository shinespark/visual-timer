import SwiftUI
import AppKit

@main
struct VisualBarTimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) {}
            CommandMenu("ウィンドウ") {
                Button("常に最前面") {
                    AppDelegate.shared?.toggleAlwaysOnTop()
                }
                .keyboardShortcut("f", modifiers: [.command, .shift])
            }
        }
    }
}
