import Foundation

final class AppSettings {
    static let shared = AppSettings()

    private let defaults = UserDefaults.standard

    private enum Key {
        static let modeIndex = "modeIndex"
        static let direction = "direction"
        static let mode1Duration = "mode1Duration"
        static let mode2WorkDuration = "mode2WorkDuration"
        static let mode2RestDuration = "mode2RestDuration"
        static let mode2RepeatCount = "mode2RepeatCount"
        static let volumeLevel = "volumeLevel"
        static let alwaysOnTop = "alwaysOnTop"
    }

    var modeIndex: Int {
        get { defaults.object(forKey: Key.modeIndex) as? Int ?? 0 }
        set { defaults.set(newValue, forKey: Key.modeIndex) }
    }

    var direction: TimerDirection {
        get {
            let raw = defaults.string(forKey: Key.direction) ?? TimerDirection.countDown.rawValue
            return TimerDirection(rawValue: raw) ?? .countDown
        }
        set { defaults.set(newValue.rawValue, forKey: Key.direction) }
    }

    var mode1Duration: TimeInterval {
        get { defaults.object(forKey: Key.mode1Duration) as? TimeInterval ?? 5 * 60 }
        set { defaults.set(newValue, forKey: Key.mode1Duration) }
    }

    var mode2WorkDuration: TimeInterval {
        get { defaults.object(forKey: Key.mode2WorkDuration) as? TimeInterval ?? 25 * 60 }
        set { defaults.set(newValue, forKey: Key.mode2WorkDuration) }
    }

    var mode2RestDuration: TimeInterval {
        get { defaults.object(forKey: Key.mode2RestDuration) as? TimeInterval ?? 5 * 60 }
        set { defaults.set(newValue, forKey: Key.mode2RestDuration) }
    }

    var mode2RepeatCount: Int {
        get { defaults.object(forKey: Key.mode2RepeatCount) as? Int ?? 0 }
        set { defaults.set(newValue, forKey: Key.mode2RepeatCount) }
    }

    var volumeLevel: Int {
        get { defaults.object(forKey: Key.volumeLevel) as? Int ?? 2 }
        set { defaults.set(newValue, forKey: Key.volumeLevel) }
    }

    var alwaysOnTop: Bool {
        get { defaults.bool(forKey: Key.alwaysOnTop) }
        set { defaults.set(newValue, forKey: Key.alwaysOnTop) }
    }

    func loadModeConfig() -> TimerModeConfig {
        if modeIndex == 1 {
            return .mode2(Mode2Settings(
                workDuration: mode2WorkDuration,
                restDuration: mode2RestDuration,
                repeatCount: mode2RepeatCount
            ))
        } else {
            return .mode1(Mode1Settings(
                direction: direction,
                duration: mode1Duration
            ))
        }
    }

    func save(modeConfig: TimerModeConfig) {
        switch modeConfig {
        case .mode1(let s):
            modeIndex = 0
            direction = s.direction
            mode1Duration = s.duration
        case .mode2(let s):
            modeIndex = 1
            mode2WorkDuration = s.workDuration
            mode2RestDuration = s.restDuration
            mode2RepeatCount = s.repeatCount
        }
    }
}
