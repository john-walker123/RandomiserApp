//
//  ColourGeneratorView.swift
//  Randomiser
//
//  Generate random colours and copy their codes.
//

import SwiftUI; import AppKit

struct RandomColour: Identifiable, Equatable {
    let red: Int
    let green: Int
    let blue: Int
    let id = UUID()

    static func random() -> RandomColour {
        RandomColour(red: .random(in: 0...255), green: .random(in: 0...255), blue: .random(in: 0...255))
    }

    var colour: Color {
        Color(red: Double(red) / 255, green: Double(green) / 255, blue: Double(blue) / 255)
    }

    var hex: String { String(format: "#%02X%02X%02X", red, green, blue) }
    var rgb: String { "rgb(\(red), \(green), \(blue))" }

    var hsb: String {
        let ns = NSColor(srgbRed: CGFloat(red) / 255, green: CGFloat(green) / 255,
                         blue: CGFloat(blue) / 255, alpha: 1)
        return "hsb(\(Int((ns.hueComponent * 360).rounded()))°, "
            + "\(Int((ns.saturationComponent * 100).rounded()))%, "
            + "\(Int((ns.brightnessComponent * 100).rounded()))%)"
    }
}

struct ColourGeneratorView: View {
    @State private var current = RandomColour.random()
    @State private var history: [RandomColour] = []
    @State private var copied: String?

    func generate() {
        withAnimation(.easeInOut(duration: 0.25)) {
            history.insert(current, at: 0)
            if history.count > 12 { history.removeLast() }
            current = .random()
            copied = nil
        }
    }

    func copy(_ value: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(value, forType: .string)
        withAnimation { copied = value }
    }

    var body: some View {
        ToolScreen(title: "Random Colour",
                   subtitle: "Find a fresh colour and copy its code.",
                   symbol: "paintpalette.fill",
                   tint: .brown) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(current.colour)
                    .frame(height: 170)

                VStack(spacing: 0) {
                    codeRow(label: "HEX", value: current.hex)
                    Divider()
                    codeRow(label: "RGB", value: current.rgb)
                    Divider()
                    codeRow(label: "HSB", value: current.hsb)
                }
                .background(Color(nsColor: .controlBackgroundColor))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(Color(nsColor: .separatorColor))
            )

            Button("New Colour", systemImage: "dice", action: generate)
                .buttonStyle(.primary(.brown))
                .focusEffectDisabled()
                .keyboardShortcut(.defaultAction)

            if !history.isEmpty {
                VStack(spacing: 10) {
                    Text("Previous colours — click to bring one back")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 30), spacing: 8)], spacing: 8) {
                        ForEach(history) { colour in
                            Button {
                                withAnimation(.easeInOut(duration: 0.25)) {
                                    current = colour
                                    copied = nil
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(colour.colour)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .strokeBorder(Color(nsColor: .separatorColor))
                                    )
                            }
                            .buttonStyle(.plain)
                            .help(colour.hex)
                        }
                    }
                }
            }
        }
    }

    private func codeRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(width: 36, alignment: .leading)
            Text(value)
                .font(.body.monospaced())
                .textSelection(.enabled)
            Spacer()
            Button {
                copy(value)
            } label: {
                Image(systemName: copied == value ? "checkmark" : "doc.on.doc")
                    .foregroundStyle(copied == value ? Color.green : Color.secondary)
                    .frame(width: 24, height: 24)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .help("Copy \(label)")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
    }
}

#Preview {
    ColourGeneratorView()
}
