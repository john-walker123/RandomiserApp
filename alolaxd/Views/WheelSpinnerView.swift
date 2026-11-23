//
//  WheelSpinnerView.swift
//  Randomiser
//
//  Spin a wheel of your own options and let it pick one.
//

import SwiftUI

struct WheelSpinnerView: View {
    @State private var options = ["Pizza", "Burgers", "Sushi", "Tacos", "Pasta", "Salad"]
    @State private var newOption = ""
    @State private var rotation = 0.0
    @State private var isSpinning = false
    @State private var winner: String?

    private var canSpin: Bool { options.count >= 2 && !isSpinning }

    func spin() {
        guard canSpin else { return }
        isSpinning = true
        winner = nil

        let target = rotation + 360 * 5 + Double.random(in: 0..<360)

        withAnimation(.timingCurve(0.12, 0.8, 0.2, 1, duration: 4)) {
            rotation = target
        } completion: {
            winner = options[WheelView.index(atPointerFor: rotation, count: options.count)]
            isSpinning = false
        }
    }

    func addOption() {
        let trimmed = newOption.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, options.count < 16 else { return }
        options.append(trimmed)
        newOption = ""
        winner = nil
    }

    func removeWinner() {
        guard let winner, let index = options.firstIndex(of: winner) else { return }
        options.remove(at: index)
        self.winner = nil
    }

    var body: some View {
        ToolScreen(title: "Spin the Wheel",
                   subtitle: "Add your options, then let the wheel decide.",
                   symbol: "chart.pie.fill",
                   tint: .pink) {
            Card(padding: 24) {
                VStack(spacing: 18) {
                    ZStack(alignment: .top) {
                        WheelView(options: options)
                            .rotationEffect(.degrees(rotation))
                            .frame(width: 280, height: 280)
                            .padding(.top, 10)

                        WheelPointer()
                            .fill(Color.primary)
                            .frame(width: 22, height: 24)
                    }

                    Group {
                        if let winner {
                            Text(winner)
                                .font(.title2.weight(.semibold))
                        } else {
                            Text(isSpinning ? "Spinning…" : options.count < 2 ? "Add at least two options" : "Ready to spin")
                                .font(.title2.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }
                    }
                    .lineLimit(1)

                    if winner != nil {
                        Button("Remove from wheel", systemImage: "minus.circle", action: removeWinner)
                            .buttonStyle(.secondaryAction)
                            .focusEffectDisabled()
                    }
                }
            }

            Button("Spin", systemImage: "arrow.clockwise", action: spin)
                .buttonStyle(.primary(.pink))
                .focusEffectDisabled()
                .keyboardShortcut(.defaultAction)
                .disabled(!canSpin)

            VStack(alignment: .leading, spacing: 10) {
                Text("Options (\(options.count))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    LabeledInput(label: "") {
                        TextField("Add an option", text: $newOption)
                            .onSubmit(addOption)
                    }
                    Button("Add", action: addOption)
                        .buttonStyle(.secondaryAction)
                        .focusEffectDisabled()
                        .disabled(newOption.trimmingCharacters(in: .whitespaces).isEmpty || options.count >= 16)
                }

                VStack(spacing: 0) {
                    ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(WheelView.colour(for: index))
                                .frame(width: 10, height: 10)
                            Text(option)
                            Spacer()
                            Button {
                                options.remove(at: index)
                                winner = nil
                            } label: {
                                Image(systemName: "xmark")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(width: 22, height: 22)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .disabled(isSpinning)
                            .help("Remove \(option)")
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)

                        if index < options.count - 1 {
                            Divider().padding(.leading, 32)
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(nsColor: .controlBackgroundColor))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(Color(nsColor: .separatorColor))
                )
            }
        }
    }
}

/// The coloured wheel itself, with each option's label along its slice.
struct WheelView: View {
    let options: [String]

    private static let palette: [Color] = [.blue, .orange, .green, .pink, .purple, .teal, .red, .indigo, .mint, .brown]

    static func colour(for index: Int) -> Color {
        palette[index % palette.count]
    }

    /// Which slice sits under the pointer (at the top) after rotating the wheel clockwise by `rotation` degrees.
    static func index(atPointerFor rotation: Double, count: Int) -> Int {
        guard count > 0 else { return 0 }
        let slice = 360 / Double(count)
        let angle = (-rotation).truncatingRemainder(dividingBy: 360)
        let normalised = angle < 0 ? angle + 360 : angle
        return min(Int(normalised / slice), count - 1)
    }

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let radius = side / 2
            let count = max(options.count, 1)
            let slice = 360 / Double(count)

            ZStack {
                if options.isEmpty {
                    Circle().fill(Color.secondary.opacity(0.15))
                }

                ForEach(Array(options.enumerated()), id: \.offset) { index, option in
                    WheelSlice(startAngle: .degrees(Double(index) * slice - 90),
                               endAngle: .degrees(Double(index + 1) * slice - 90))
                        .fill(Self.colour(for: index))

                    // Labels on the left half are flipped so they never read upside down.
                    let middle = (Double(index) + 0.5) * slice - 90
                    let isLeftHalf = middle > 90 && middle < 270

                    Text(option)
                        .font(.system(size: count > 10 ? 11 : 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .frame(width: radius * 0.68, alignment: isLeftHalf ? .leading : .trailing)
                        .offset(x: isLeftHalf ? -radius * 0.52 : radius * 0.52)
                        .rotationEffect(.degrees(isLeftHalf ? middle + 180 : middle))
                }

                ForEach(0..<options.count, id: \.self) { index in
                    Rectangle()
                        .fill(Color.white.opacity(0.6))
                        .frame(width: radius, height: 1.5)
                        .offset(x: radius / 2)
                        .rotationEffect(.degrees(Double(index) * slice - 90))
                }
                .opacity(options.count > 1 ? 1 : 0)

                Circle()
                    .strokeBorder(Color(nsColor: .separatorColor), lineWidth: 1)

                Circle()
                    .fill(Color(nsColor: .controlBackgroundColor))
                    .overlay(Circle().strokeBorder(Color(nsColor: .separatorColor)))
                    .frame(width: side * 0.14, height: side * 0.14)
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

private struct WheelSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: min(rect.width, rect.height) / 2,
                    startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}

/// The downward-pointing marker above the wheel.
private struct WheelPointer: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    WheelSpinnerView()
}
