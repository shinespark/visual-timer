import SwiftUI

struct ModeSettingsView: View {
    @ObservedObject var model: TimerModel
    @Binding var isPresented: Bool

    @State private var selectedMode: Int = 0
    @State private var direction: TimerDirection = .countDown
    @State private var mode1Minutes: Int = 5
    @State private var mode1Seconds: Int = 0
    @State private var workMinutes: Int = 25
    @State private var workSeconds: Int = 0
    @State private var restMinutes: Int = 5
    @State private var restSeconds: Int = 0
    @State private var repeatCount: Int = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("タイマー設定")
                .font(.headline)
                .foregroundColor(.white)

            Picker("モード", selection: $selectedMode) {
                Text("タイマー").tag(0)
                Text("ポモドーロ").tag(1)
            }
            .pickerStyle(.segmented)

            if selectedMode == 0 {
                mode1Settings
            } else {
                mode2Settings
            }

            HStack {
                Button("キャンセル") { isPresented = false }
                    .keyboardShortcut(.escape)
                Spacer()
                Button("適用") { apply() }
                    .keyboardShortcut(.return)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding(16)
        .frame(width: 300)
        .background(Color(red: 0.15, green: 0.15, blue: 0.16))
        .onAppear { loadCurrentSettings() }
    }

    private var mode1Settings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Picker("方向", selection: $direction) {
                Text("カウントダウン").tag(TimerDirection.countDown)
                Text("カウントアップ").tag(TimerDirection.countUp)
            }
            .pickerStyle(.radioGroup)
            .foregroundColor(.white)

            Text("時間:").foregroundColor(.white)
            durationPicker(minutes: $mode1Minutes, seconds: $mode1Seconds, maxMinutes: 199)
        }
    }

    private var mode2Settings: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("作業:").foregroundColor(.white)
            durationPicker(minutes: $workMinutes, seconds: $workSeconds, maxMinutes: 199)
            Text("休憩:").foregroundColor(.white)
            durationPicker(minutes: $restMinutes, seconds: $restSeconds, maxMinutes: 199)
            HStack {
                Text("繰り返し:").foregroundColor(.white)
                Stepper("\(repeatCount == 0 ? "無限" : "\(repeatCount)回")",
                        value: $repeatCount, in: 0...99)
                    .foregroundColor(.white)
            }
        }
    }

    private func durationPicker(minutes: Binding<Int>, seconds: Binding<Int>, maxMinutes: Int) -> some View {
        VStack(spacing: 4) {
            HStack(spacing: 8) {
                Text("分").foregroundColor(.secondary).frame(width: 16)
                Slider(
                    value: Binding(get: { Double(minutes.wrappedValue) }, set: { minutes.wrappedValue = Int($0) }),
                    in: 0...Double(maxMinutes),
                    step: 1
                )
                Text("\(minutes.wrappedValue)分").foregroundColor(.white).frame(width: 48, alignment: .trailing)
            }
            HStack(spacing: 8) {
                Text("秒").foregroundColor(.secondary).frame(width: 16)
                Slider(
                    value: Binding(get: { Double(seconds.wrappedValue) }, set: { seconds.wrappedValue = Int($0) }),
                    in: 0...59,
                    step: 1
                )
                Text("\(seconds.wrappedValue)秒").foregroundColor(.white).frame(width: 48, alignment: .trailing)
            }
        }
    }

    private func loadCurrentSettings() {
        switch model.modeConfig {
        case .mode1(let s):
            selectedMode = 0
            direction = s.direction
            mode1Minutes = Int(s.duration) / 60
            mode1Seconds = Int(s.duration) % 60
        case .mode2(let s):
            selectedMode = 1
            workMinutes = Int(s.workDuration) / 60
            workSeconds = Int(s.workDuration) % 60
            restMinutes = Int(s.restDuration) / 60
            restSeconds = Int(s.restDuration) % 60
            repeatCount = s.repeatCount
        }
    }

    private func apply() {
        let config: TimerModeConfig
        if selectedMode == 0 {
            let dur = TimeInterval(mode1Minutes * 60 + mode1Seconds)
            config = .mode1(Mode1Settings(direction: direction, duration: max(1, dur)))
        } else {
            let work = TimeInterval(workMinutes * 60 + workSeconds)
            let rest = TimeInterval(restMinutes * 60 + restSeconds)
            config = .mode2(Mode2Settings(
                workDuration: max(1, work),
                restDuration: max(1, rest),
                repeatCount: repeatCount
            ))
        }
        model.applyMode(config)
        isPresented = false
    }
}
