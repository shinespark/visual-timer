import SwiftUI

struct ContentView: View {
    @StateObject private var model = TimerModel()
    @State private var showSettings = false

    private var isCountUp: Bool {
        if case .mode1(let s) = model.modeConfig, s.direction == .countUp { return true }
        return false
    }

    private var windowTitle: String {
        switch model.modeConfig {
        case .mode1:
            return "VisualTimer - タイマー"
        case .mode2:
            return "VisualTimer - ポモドーロ - \(model.repeatPhase == .work ? "作業" : "休憩")"
        }
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
            .padding(.horizontal, 16)
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
            DispatchQueue.main.async {
                NSApp.windows.first?.title = windowTitle
            }
        }
        .onChange(of: windowTitle) { newTitle in
            NSApp.windows.first?.title = newTitle
        }
    }
}

#Preview {
    ContentView()
}
