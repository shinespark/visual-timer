import SwiftUI

struct ControlButtonsView: View {
    @ObservedObject var model: TimerModel
    @Binding var showSettings: Bool
    @State private var volume: Double = AlarmPlayer.shared.volumeLevel
    @State private var showVolume: Bool = false

    var body: some View {
        HStack(spacing: 10) {
            // Start/Pause/Resume
            Button(action: { model.togglePauseResume() }) {
                Image(systemName: startButtonIcon)
                    .font(.system(size: 26))
                    .frame(width: 48, height: 48)
            }
            .keyboardShortcut(.return, modifiers: [])
            .help(startButtonLabel)

            // Reset
            Button(action: { model.reset() }) {
                Image(systemName: "stop.fill")
                    .font(.system(size: 26))
                    .frame(width: 48, height: 48)
            }
            .keyboardShortcut("r", modifiers: [])
            .help("リセット")

            Spacer()

            // Settings
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape")
                    .font(.system(size: 26))
                    .frame(width: 48, height: 48)
            }
            .help("設定")
            .disabled(model.phase == .running)

            // Volume
            Button(action: { showVolume.toggle() }) {
                Image(systemName: volume == 0 ? "speaker.slash.fill" : "speaker.wave.3.fill")
                    .font(.system(size: 26))
                    .frame(width: 48, height: 48)
            }
            .help("音量")
            .popover(isPresented: $showVolume, arrowEdge: .bottom) {
                HStack(spacing: 8) {
                    Image(systemName: "speaker.fill")
                        .foregroundColor(.secondary)
                    Slider(value: $volume, in: 0...1)
                        .frame(width: 120)
                    Image(systemName: "speaker.wave.3.fill")
                        .foregroundColor(.secondary)
                }
                .padding(12)
                .onChange(of: volume) { newValue in
                    model.alarmPlayer.volumeLevel = newValue
                }
            }
        }
        .buttonStyle(.plain)
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .frame(height: 64)
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

}
