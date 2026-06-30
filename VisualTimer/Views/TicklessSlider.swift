import SwiftUI
import AppKit

struct TicklessSlider: NSViewRepresentable {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double

    func makeNSView(context: Context) -> NSSlider {
        let slider = NSSlider()
        slider.minValue = range.lowerBound
        slider.maxValue = range.upperBound
        slider.numberOfTickMarks = 0
        slider.isContinuous = true
        slider.doubleValue = value
        slider.target = context.coordinator
        slider.action = #selector(Coordinator.valueChanged(_:))
        return slider
    }

    func updateNSView(_ nsView: NSSlider, context: Context) {
        nsView.doubleValue = value
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value, step: step)
    }

    class Coordinator: NSObject {
        var value: Binding<Double>
        let step: Double

        init(value: Binding<Double>, step: Double) {
            self.value = value
            self.step = step
        }

        @objc func valueChanged(_ sender: NSSlider) {
            let rounded = (sender.doubleValue / step).rounded() * step
            value.wrappedValue = rounded
        }
    }
}
