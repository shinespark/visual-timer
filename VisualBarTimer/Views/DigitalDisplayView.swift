import SwiftUI

struct DigitalDisplayView: View {
    let remaining: TimeInterval
    let phase: TimerPhase
    let isBlinking: Bool

    private var displayText: String {
        TimeFormatter.format(remaining)
    }

    private var textOpacity: Double {
        if case .alarm = phase { return isBlinking ? 1.0 : 0.2 }
        if phase == .finished { return 0.4 }
        return 1.0
    }

    var body: some View {
        Text(displayText)
            .font(.system(size: 22, weight: .medium, design: .monospaced))
            .foregroundColor(foregroundColor)
            .opacity(textOpacity)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 2)
            .background(TimerColors.displayBackground)
    }

    private var foregroundColor: Color {
        switch phase {
        case .alarm(.end), .finished:
            return Color(red: 0.95, green: 0.3, blue: 0.2)
        case .alarm(.repeatTransition):
            return Color(red: 0.95, green: 0.8, blue: 0.1)
        default:
            return .white
        }
    }
}
