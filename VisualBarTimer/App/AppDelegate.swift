import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    static weak var shared: AppDelegate?

    private var isAlwaysOnTop = AppSettings.shared.alwaysOnTop

    override init() {
        super.init()
        AppDelegate.shared = self
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let window = NSApp.windows.first else { return }
        configureWindow(window)
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }

    func applicationWillTerminate(_ notification: Notification) {
        AppSettings.shared.alwaysOnTop = isAlwaysOnTop
    }

    func toggleAlwaysOnTop() {
        isAlwaysOnTop.toggle()
        AppSettings.shared.alwaysOnTop = isAlwaysOnTop
        guard let window = NSApp.windows.first else { return }
        window.level = isAlwaysOnTop ? .floating : .normal
    }

    private func configureWindow(_ window: NSWindow) {
        window.styleMask = [.borderless, .resizable]
        window.isMovableByWindowBackground = true
        window.backgroundColor = NSColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0)
        window.isOpaque = true
        window.hasShadow = true

        if isAlwaysOnTop {
            window.level = .floating
        }
    }
}
