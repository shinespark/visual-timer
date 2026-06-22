import Foundation
import Combine

@MainActor
final class TimerModel: ObservableObject {

    // MARK: - Published State
    @Published var phase: TimerPhase = .idle
    @Published var remaining: TimeInterval = 0
    @Published var totalDuration: TimeInterval = 0
    @Published var segmentCount: Int = 0
    @Published var modeConfig: TimerModeConfig
    @Published var repeatPhase: RepeatPhase = .work
    @Published var repeatsDone: Int = 0
    @Published var isBlinking: Bool = false

    // MARK: - Dependencies
    let alarmPlayer: AlarmPlayer
    let notificationManager: NotificationManager

    // MARK: - Private
    private var startDate: Date?
    private var pauseRemaining: TimeInterval = 0
    private var halfAlarmFired = false
    private var timerCancellable: AnyCancellable?
    private var blinkCancellable: AnyCancellable?

    init(settings: AppSettings = .shared,
         alarmPlayer: AlarmPlayer = .shared,
         notificationManager: NotificationManager = .shared) {
        self.alarmPlayer = alarmPlayer
        self.notificationManager = notificationManager
        self.modeConfig = settings.loadModeConfig()
        resetToCurrentMode()
    }

    // MARK: - Public Interface

    func start() {
        guard phase == .idle || phase == .paused else { return }
        if case .paused = phase {
            resume()
            return
        }
        startDate = Date()
        halfAlarmFired = false
        phase = .running
        startTick()
    }

    func pause() {
        guard phase == .running else { return }
        pauseRemaining = remaining
        stopTick()
        phase = .paused
    }

    func resume() {
        guard phase == .paused else { return }
        startDate = Date().addingTimeInterval(-(totalDuration - pauseRemaining))
        phase = .running
        startTick()
    }

    func reset() {
        stopTick()
        stopBlink()
        startDate = nil
        halfAlarmFired = false
        repeatsDone = 0
        repeatPhase = .work
        phase = .idle
        resetToCurrentMode()
        notificationManager.cancelAll()
    }

    func applyMode(_ config: TimerModeConfig) {
        modeConfig = config
        AppSettings.shared.save(modeConfig: config)
        reset()
    }

    func togglePauseResume() {
        switch phase {
        case .running: pause()
        case .paused: resume()
        case .idle: start()
        case .alarm: dismissAlarm()
        case .finished: reset()
        }
    }

    // MARK: - Private Logic

    private func resetToCurrentMode() {
        switch modeConfig {
        case .mode1(let s):
            totalDuration = s.duration
            remaining = s.direction == .countDown ? s.duration : 0
            segmentCount = s.direction == .countDown ? 20 : 0
        case .mode2(let s):
            let dur = repeatPhase == .work ? s.workDuration : s.restDuration
            totalDuration = dur
            remaining = dur
            segmentCount = 20
        }
    }

    private func startTick() {
        timerCancellable = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func stopTick() {
        timerCancellable?.cancel()
        timerCancellable = nil
    }

    private func tick() {
        guard let startDate, phase == .running else { return }

        let elapsed = Date().timeIntervalSince(startDate)

        switch modeConfig {
        case .mode1(let s):
            if s.direction == .countDown {
                remaining = max(0, totalDuration - elapsed)
                segmentCount = computeSegmentCount(ratio: remaining / totalDuration)
                checkHalfAlarm(remaining: remaining, total: totalDuration)
                if remaining <= 0 { triggerEnd() }
            } else {
                remaining = min(elapsed, totalDuration)
                segmentCount = computeSegmentCount(ratio: remaining / totalDuration)
                checkHalfAlarm(remaining: totalDuration - remaining, total: totalDuration)
                if remaining >= totalDuration { triggerEnd() }
            }

        case .mode2(let s):
            remaining = max(0, totalDuration - elapsed)
            segmentCount = computeSegmentCount(ratio: remaining / totalDuration)
            checkHalfAlarm(remaining: remaining, total: totalDuration)
            if remaining <= 0 { triggerRepeatTransition(settings: s) }
        }
    }

    private func computeSegmentCount(ratio: Double) -> Int {
        Int((ratio * 20).rounded(.up)).clamped(to: 0...20)
    }

    private func checkHalfAlarm(remaining: TimeInterval, total: TimeInterval) {
        guard !halfAlarmFired, remaining <= total / 2 else { return }
        halfAlarmFired = true
        alarmPlayer.playHalf()
    }

    private func triggerEnd() {
        stopTick()
        remaining = 0
        segmentCount = 0
        alarmPlayer.playEnd()
        notificationManager.sendEndNotification()
        startBlink()
        phase = .alarm(.end)
    }

    private func triggerRepeatTransition(settings: Mode2Settings) {
        stopTick()
        remaining = 0
        segmentCount = 0
        alarmPlayer.playEnd()
        startBlink()
        phase = .alarm(.repeatTransition)

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.advanceRepeatPhase(settings: settings)
        }
    }

    private func advanceRepeatPhase(settings: Mode2Settings) {
        guard case .alarm(.repeatTransition) = phase else { return }
        stopBlink()

        if repeatPhase == .work {
            repeatsDone += 1
            if settings.repeatCount > 0 && repeatsDone >= settings.repeatCount {
                phase = .finished
                return
            }
            repeatPhase = .rest
            totalDuration = settings.restDuration
        } else {
            repeatPhase = .work
            totalDuration = settings.workDuration
        }

        remaining = totalDuration
        segmentCount = 20
        halfAlarmFired = false
        startDate = Date()
        phase = .running
        startTick()
    }

    private func dismissAlarm() {
        stopBlink()
        if case .alarm(.end) = phase {
            phase = .finished
        }
    }

    private func startBlink() {
        isBlinking = true
        blinkCancellable = Timer.publish(every: 0.4, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.isBlinking.toggle()
            }
    }

    private func stopBlink() {
        blinkCancellable?.cancel()
        blinkCancellable = nil
        isBlinking = false
    }
}

private extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
