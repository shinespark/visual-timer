import Foundation

enum TimerPhase: Equatable {
    case idle
    case running
    case paused
    case alarm(AlarmKind)
    case finished
}

enum AlarmKind: Equatable {
    case half
    case end
    case repeatTransition
}

enum RepeatPhase {
    case work
    case rest
}
