import Foundation

enum TimerDirection: String, CaseIterable {
    case countDown = "countdown"
    case countUp = "countup"
}

struct Mode1Settings {
    var direction: TimerDirection = .countDown
    var duration: TimeInterval = 5 * 60  // default 5 min
}

struct Mode2Settings {
    var workDuration: TimeInterval = 25 * 60  // default 25 min
    var restDuration: TimeInterval = 5 * 60   // default 5 min
    var repeatCount: Int = 0                  // 0 = infinite
}

enum TimerModeConfig {
    case mode1(Mode1Settings)
    case mode2(Mode2Settings)

    var displayName: String {
        switch self {
        case .mode1: return "M1"
        case .mode2: return "M2"
        }
    }
}
