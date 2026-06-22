import SwiftUI

struct ControlButtonsView: View {
    @ObservedObject var model: TimerModel
    @Binding var showSettings: Bool

    var body: some View {
        HStack(spacing: 10) {
            // Start/Pause/Resume
            Button(action: { model.togglePauseResume() }) {
                Image(systemName: startButtonIcon)
                    .frame(width: 18, height: 18)
            }
            .keyboardShortcut(.return, modifiers: [])
            .help(startButtonLabel)

            // Reset
            Button(action: { model.reset() }) {
                Image(systemName: "stop.fill")
                    .frame(width: 18, height: 18)
            }
            .keyboardShortcut("r", modifiers: [])
            .help("リセット")

            Spacer()

            // Mode label
            Text(model.modeConfig.displayName)
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundColor(modeColor)
                .frame(width: 24)

            if case .mode2 = model.modeConfig {
                Text(model.repeatPhase == .work ? "作業" : "休憩")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            Spacer()

            // Settings
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape")
                    .frame(width: 18, height: 18)
            }
            .help("設定")
            .disabled(model.phase == .running)

            // Volume
            Button(action: { cycleVolume() }) {
                Image(systemName: volumeIcon)
                    .frame(width: 18, height: 18)
            }
            .help("音量: \(volumeLabel)")
        }
        .buttonStyle(.plain)
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .frame(height: 28)
    }

    private var startButtonIcon: String {
        switch model.phase {
        case .idle: return "play.fill"
        case .running: return "pause.fill"
        case .paused: return "play.fill"
        case .alarm: return "checkmark.circle.fill"
        case .finished: return "arrow.counterclockwise"
        }
    }

    private var startButtonLabel: String {
        switch model.phase {
        case .idle: return "スタート (Space)"
        case .running: return "一時停止 (Space)"
        case .paused: return "再開 (Space)"
        case .alarm: return "確認 (Space)"
        case .finished: return "リセット (Space)"
        }
    }

    private var modeColor: Color {
        if case .mode2 = model.modeConfig {
            return model.repeatPhase == .work
                ? Color(red: 0.3, green: 0.8, blue: 0.3)
                : Color(red: 0.3, green: 0.6, blue: 0.9)
        }
        return .secondary
    }

    private var volumeIcon: String {
        switch model.alarmPlayer.volumeLevel {
        case 0: return "speaker.slash.fill"
        case 1: return "speaker.wave.1.fill"
        default: return "speaker.wave.3.fill"
        }
    }

    private var volumeLabel: String {
        switch model.alarmPlayer.volumeLevel {
        case 0: return "消音"
        case 1: return "小"
        default: return "大"
        }
    }

    private func cycleVolume() {
        model.alarmPlayer.volumeLevel = (model.alarmPlayer.volumeLevel + 1) % 3
    }
}
