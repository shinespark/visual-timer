import SwiftUI

struct ContentView: View {
    @StateObject private var model = TimerModel()
    @State private var showSettings = false

    private var isCountUp: Bool {
        if case .mode1(let s) = model.modeConfig, s.direction == .countUp { return true }
        return false
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 6) {
                SegmentBarView(
                    segmentCount: model.segmentCount,
                    isCountUp: isCountUp,
                    isBlinking: model.isBlinking,
                    phase: model.phase
                )

                DigitalDisplayView(
                    remaining: model.remaining,
                    phase: model.phase,
                    isBlinking: model.isBlinking
                )
                .frame(width: 150)
            }
            .frame(height: 60)
            .padding(.horizontal, 6)
            .padding(.top, 8)

            ControlButtonsView(model: model, showSettings: $showSettings)
        }
        .frame(width: 480, height: 148)
        .background(TimerColors.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .popover(isPresented: $showSettings) {
            ModeSettingsView(model: model, isPresented: $showSettings)
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
