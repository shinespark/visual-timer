import SwiftUI

struct SegmentBarView: View {
    let segmentCount: Int      // 0-20 lit segments
    let isCountUp: Bool
    let isBlinking: Bool
    let phase: TimerPhase

    private let totalSegments = 20
    private let spacing: CGFloat = 3

    var body: some View {
        GeometryReader { geo in
            let segWidth = (geo.size.width - spacing * CGFloat(totalSegments - 1)) / CGFloat(totalSegments)
            HStack(spacing: spacing) {
                ForEach(0..<totalSegments, id: \.self) { index in
                    segment(index: index, width: segWidth, height: geo.size.height)
                }
            }
        }
    }

    @ViewBuilder
    private func segment(index: Int, width: CGFloat, height: CGFloat) -> some View {
        let lit = isLit(index: index)
        let color = TimerColors.segments[index]
        let blinkOpacity: Double = {
            if case .alarm = phase { return isBlinking ? 1.0 : 0.1 }
            return 1.0
        }()

        RoundedRectangle(cornerRadius: 3)
            .fill(color.opacity(lit ? blinkOpacity : TimerColors.dimOpacity))
            .frame(width: width, height: height)
    }

    private func isLit(index: Int) -> Bool {
        if isCountUp {
            // fill from left as time progresses
            return index < segmentCount
        } else {
            // consume from right as time runs out; segments remain on left
            return index < segmentCount
        }
    }
}
