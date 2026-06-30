#!/usr/bin/env swift
import AppKit
import Foundation

let segmentColors: [(CGFloat, CGFloat, CGFloat)] = [
    (0.96, 0.08, 0.06),
    (0.95, 0.10, 0.07),
    (0.94, 0.13, 0.08),
    (0.93, 0.16, 0.09),
    (0.92, 0.20, 0.10),
    (0.94, 0.60, 0.04),
    (0.92, 0.65, 0.05),
    (0.90, 0.70, 0.06),
    (0.85, 0.75, 0.08),
    (0.80, 0.80, 0.10),
    (0.30, 0.86, 0.15),
    (0.28, 0.82, 0.24),
    (0.26, 0.78, 0.33),
    (0.23, 0.74, 0.42),
    (0.21, 0.70, 0.51),
    (0.19, 0.66, 0.60),
    (0.17, 0.62, 0.68),
    (0.15, 0.58, 0.77),
    (0.12, 0.54, 0.86),
    (0.10, 0.50, 0.95),
]

func generateIcon(size: Int) -> Data? {
    let s = CGFloat(size)
    guard let rep = NSBitmapImageRep(
        bitmapDataPlanes: nil,
        pixelsWide: size,
        pixelsHigh: size,
        bitsPerSample: 8,
        samplesPerPixel: 4,
        hasAlpha: true,
        isPlanar: false,
        colorSpaceName: .calibratedRGB,
        bytesPerRow: 0,
        bitsPerPixel: 0
    ) else { return nil }

    NSGraphicsContext.saveGraphicsState()
    guard let ctx = NSGraphicsContext(bitmapImageRep: rep) else { return nil }
    NSGraphicsContext.current = ctx

    // Background
    NSColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0).setFill()
    NSRect(x: 0, y: 0, width: s, height: s).fill()

    // Segment bar
    let totalSegments = 20
    let barWidth = s * 0.82
    let barHeight = s * 0.18
    let barX = (s - barWidth) / 2
    let barY = (s - barHeight) / 2
    let spacing = s * 0.008
    let segWidth = (barWidth - spacing * CGFloat(totalSegments - 1)) / CGFloat(totalSegments)
    let cornerRadius = segWidth * 0.30

    for i in 0..<totalSegments {
        let (r, g, b) = segmentColors[i]
        NSColor(red: r, green: g, blue: b, alpha: 1.0).setFill()
        let x = barX + CGFloat(i) * (segWidth + spacing)
        let rect = NSRect(x: x, y: barY, width: segWidth, height: barHeight)
        NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius).fill()
    }

    NSGraphicsContext.restoreGraphicsState()
    return rep.representation(using: .png, properties: [:])
}

let outputDir = CommandLine.arguments.count > 1
    ? CommandLine.arguments[1]
    : FileManager.default.currentDirectoryPath

let sizes: [(String, Int)] = [
    ("icon_16x16.png",     16),
    ("icon_16x16@2x.png",  32),
    ("icon_32x32.png",     32),
    ("icon_32x32@2x.png",  64),
    ("icon_128x128.png",   128),
    ("icon_128x128@2x.png",256),
    ("icon_256x256.png",   256),
    ("icon_256x256@2x.png",512),
    ("icon_512x512.png",   512),
    ("icon_512x512@2x.png",1024),
]

for (filename, size) in sizes {
    if let data = generateIcon(size: size) {
        let url = URL(fileURLWithPath: outputDir).appendingPathComponent(filename)
        do {
            try data.write(to: url)
            print("Generated: \(filename) (\(size)x\(size))")
        } catch {
            print("Error writing \(filename): \(error)")
        }
    }
}
