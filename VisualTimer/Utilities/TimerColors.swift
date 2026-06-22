import SwiftUI

enum TimerColors {
    // 20 segment colors: green(1-10) → yellow(11-15) → red(16-20)
    static let segments: [Color] = [
        // 1-10: green range
        Color(red: 0.10, green: 0.75, blue: 0.15),
        Color(red: 0.12, green: 0.78, blue: 0.15),
        Color(red: 0.14, green: 0.80, blue: 0.15),
        Color(red: 0.16, green: 0.82, blue: 0.15),
        Color(red: 0.18, green: 0.84, blue: 0.15),
        Color(red: 0.20, green: 0.86, blue: 0.15),
        Color(red: 0.22, green: 0.88, blue: 0.15),
        Color(red: 0.25, green: 0.90, blue: 0.15),
        Color(red: 0.28, green: 0.88, blue: 0.15),
        Color(red: 0.30, green: 0.86, blue: 0.15),
        // 11-15: yellow range
        Color(red: 0.80, green: 0.80, blue: 0.10),
        Color(red: 0.85, green: 0.75, blue: 0.08),
        Color(red: 0.90, green: 0.70, blue: 0.06),
        Color(red: 0.92, green: 0.65, blue: 0.05),
        Color(red: 0.94, green: 0.60, blue: 0.04),
        // 16-20: red range
        Color(red: 0.92, green: 0.20, blue: 0.10),
        Color(red: 0.93, green: 0.16, blue: 0.09),
        Color(red: 0.94, green: 0.13, blue: 0.08),
        Color(red: 0.95, green: 0.10, blue: 0.07),
        Color(red: 0.96, green: 0.08, blue: 0.06),
    ]

    static let dimOpacity: Double = 0.15
    static let background = Color(red: 0.11, green: 0.11, blue: 0.12)
    static let displayBackground = Color(red: 0.08, green: 0.08, blue: 0.09)
}
