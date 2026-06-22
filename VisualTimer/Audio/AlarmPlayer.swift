import AppKit

final class AlarmPlayer {
    static let shared = AlarmPlayer()

    var volumeLevel: Int = AppSettings.shared.volumeLevel {
        didSet { AppSettings.shared.volumeLevel = volumeLevel }
    }

    func playHalf() {
        guard volumeLevel > 0 else { return }
        playBeep(times: 1)
    }

    func playEnd() {
        guard volumeLevel > 0 else { return }
        playBeep(times: 3)
    }

    private func playBeep(times: Int) {
        let volume: Float = volumeLevel == 1 ? 0.3 : 1.0
        for i in 0..<times {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                NSSound.beep()
                _ = volume  // volume control via system prefs; NSSound.beep() uses system alert volume
            }
        }
    }
}
