//
//  DiceRollerView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct DiceRollerView: View {
    @State private var value = 1
    @State private var hasRolled = false
    @State private var isRolling = false
    @State private var tilt = 0.0
    @State private var history: [Int] = []

    func roll() {
        guard !isRolling else { return }
        isRolling = true

        Task { @MainActor in
            // Tumble through a few random faces before landing on the result.
            for _ in 0..<8 {
                withAnimation(.easeInOut(duration: 0.07)) {
                    value = Int.random(in: 1...6)
                    tilt = Double.random(in: -18...18)
                }
                try? await Task.sleep(nanoseconds: 70_000_000)
            }

            let result = Int.random(in: 1...6)
            withAnimation(.spring(response: 0.35, dampingFraction: 0.55)) {
                value = result
                tilt = 0
                hasRolled = true
                history.insert(result, at: 0)
                if history.count > 10 { history.removeLast() }
            }
            isRolling = false
        }
    }

    var body: some View {
        ToolScreen(title: "Dice Roller",
                   subtitle: "Roll a six-sided die.",
                   symbol: "dice.fill",
                   tint: .blue) {
            Card(padding: 32) {
                VStack(spacing: 24) {
                    DieFace(value: value)
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(tilt))
                        .scaleEffect(isRolling ? 0.92 : 1)

                    Text(hasRolled ? "You rolled a \(value)" : "Ready to roll")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(hasRolled ? .primary : .secondary)
                        .opacity(isRolling ? 0.3 : 1)
                }
            }

            Button("Roll Dice", systemImage: "dice", action: roll)
                .buttonStyle(.primary(.blue))
                .focusEffectDisabled()
                .keyboardShortcut(.defaultAction)
                .disabled(isRolling)

            if !history.isEmpty {
                VStack(spacing: 10) {
                    Text("Recent rolls")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    HStack(spacing: 8) {
                        ForEach(Array(history.enumerated()), id: \.offset) { _, roll in
                            DieFace(value: roll, pipColor: .white, faceColor: .blue)
                                .frame(width: 28, height: 28)
                        }
                    }
                }
                .transition(.opacity)
            }
        }
    }
}

/// Draws a die face with pips laid out like a real die.
struct DieFace: View {
    let value: Int
    var pipColor: Color = .black
    var faceColor: Color = .white

    /// Which cells of a 3×3 grid (0–8, row by row) hold a pip for each value.
    private static let layouts: [Int: Set<Int>] = [
        1: [4],
        2: [0, 8],
        3: [0, 4, 8],
        4: [0, 2, 6, 8],
        5: [0, 2, 4, 6, 8],
        6: [0, 2, 3, 5, 6, 8],
    ]

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)
            let pip = side * 0.18
            let inset = side * 0.14

            ZStack {
                RoundedRectangle(cornerRadius: side * 0.2, style: .continuous)
                    .fill(faceColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: side * 0.2, style: .continuous)
                            .strokeBorder(.black.opacity(0.18), lineWidth: max(1, side * 0.012))
                    )

                VStack(spacing: 0) {
                    ForEach(0..<3) { row in
                        HStack(spacing: 0) {
                            ForEach(0..<3) { column in
                                Circle()
                                    .fill(pipColor)
                                    .frame(width: pip, height: pip)
                                    .opacity(Self.layouts[value, default: []].contains(row * 3 + column) ? 1 : 0)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                        }
                    }
                }
                .padding(inset)
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement()
        .accessibilityLabel("Die showing \(value)")
    }
}

#Preview {
    DiceRollerView()
}
