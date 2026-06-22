import Foundation

enum TimeFormatter {
    static func format(_ seconds: Int) -> String {
        let clamped = max(0, min(seconds, 11999))  // 199:59 max
        let minutes = clamped / 60
        let secs = clamped % 60
        return String(format: "%3d:%02d", minutes, secs)
    }

    static func format(_ interval: TimeInterval) -> String {
        format(Int(interval))
    }
}
