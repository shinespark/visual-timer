import AppKit

final class AlarmPlayer {
    static let shared = AlarmPlayer()

    var volumeLevel: Double = AppSettings.shared.volumeLevel {
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
        for i in 0..<times {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.3) {
                NSSound.beep()
            }
        }
    }
}
