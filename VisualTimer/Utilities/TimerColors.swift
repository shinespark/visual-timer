import SwiftUI

enum TimerColors {
    // 20 segment colors: red(1-5) → yellow(6-10) → green(11-20)
    // Left = red (time running out), right = green (time remaining)
    static let segments: [Color] = [
        // 1-5: red range
        Color(red: 0.96, green: 0.08, blue: 0.06),
        Color(red: 0.95, green: 0.10, blue: 0.07),
        Color(red: 0.94, green: 0.13, blue: 0.08),
        Color(red: 0.93, green: 0.16, blue: 0.09),
        Color(red: 0.92, green: 0.20, blue: 0.10),
        // 6-10: yellow range
        Color(red: 0.94, green: 0.60, blue: 0.04),
        Color(red: 0.92, green: 0.65, blue: 0.05),
        Color(red: 0.90, green: 0.70, blue: 0.06),
        Color(red: 0.85, green: 0.75, blue: 0.08),
        Color(red: 0.80, green: 0.80, blue: 0.10),
        // 11-20: green → blue gradient
        Color(red: 0.30, green: 0.86, blue: 0.15),
        Color(red: 0.28, green: 0.82, blue: 0.24),
        Color(red: 0.26, green: 0.78, blue: 0.33),
        Color(red: 0.23, green: 0.74, blue: 0.42),
        Color(red: 0.21, green: 0.70, blue: 0.51),
        Color(red: 0.19, green: 0.66, blue: 0.60),
        Color(red: 0.17, green: 0.62, blue: 0.68),
        Color(red: 0.15, green: 0.58, blue: 0.77),
        Color(red: 0.12, green: 0.54, blue: 0.86),
        Color(red: 0.10, green: 0.50, blue: 0.95),
    ]

    static let dimOpacity: Double = 0.15
    static let background = Color(red: 0.11, green: 0.11, blue: 0.12)
    static let displayBackground = Color(red: 0.08, green: 0.08, blue: 0.09)
}
