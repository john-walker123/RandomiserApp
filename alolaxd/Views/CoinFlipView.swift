//
//  CoinFlipView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct CoinFlipView: View {
    @State private var isHeads = true
    @State private var hasFlipped = false
    @State private var isFlipping = false
    @State private var rotation = 0.0
    @State private var headsCount = 0
    @State private var tailsCount = 0

    func flip() {
        guard !isFlipping else { return }
        isFlipping = true
        let result = Bool.random()

        withAnimation(.easeInOut(duration: 1.0)) {
            rotation += 1800
        }

        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 700_000_000)
            isHeads = result
            try? await Task.sleep(nanoseconds: 300_000_000)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                hasFlipped = true
                if result { headsCount += 1 } else { tailsCount += 1 }
            }
            isFlipping = false
        }
    }

    var body: some View {
        ToolScreen(title: "Coin Flip",
                   subtitle: "Heads or tails? Let fate decide.",
                   symbol: "circle.lefthalf.filled",
                   tint: .green) {
            Card(padding: 32) {
                VStack(spacing: 24) {
                    Coin(isHeads: isHeads)
                        .frame(width: 170, height: 170)
                        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))

                    Text(hasFlipped ? (isHeads ? "Heads!" : "Tails!") : "Ready to flip")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(hasFlipped ? .primary : .secondary)
                        .opacity(isFlipping ? 0.3 : 1)
                }
            }

            Button("Flip Coin", systemImage: "arrow.triangle.2.circlepath", action: flip)
                .buttonStyle(.primary(.green))
                .focusEffectDisabled()
                .keyboardShortcut(.defaultAction)
                .disabled(isFlipping)

            HStack(spacing: 14) {
                TallyView(label: "Heads", count: headsCount)
                TallyView(label: "Tails", count: tailsCount)
            }
        }
    }
}

/// A gold coin showing either heads or tails.
private struct Coin: View {
    let isHeads: Bool

    private let gold = Color(red: 0.98, green: 0.80, blue: 0.25)
    private let darkGold = Color(red: 0.78, green: 0.55, blue: 0.05)

    var body: some View {
        GeometryReader { geo in
            let side = min(geo.size.width, geo.size.height)

            ZStack {
                Circle()
                    .fill(gold)
                Circle()
                    .strokeBorder(darkGold, lineWidth: side * 0.05)
                Circle()
                    .strokeBorder(darkGold.opacity(0.6), lineWidth: side * 0.015)
                    .padding(side * 0.12)
                Image(systemName: isHeads ? "crown.fill" : "star.fill")
                    .font(.system(size: side * 0.32, weight: .bold))
                    .foregroundStyle(darkGold)
            }
            .frame(width: side, height: side)
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityElement()
        .accessibilityLabel(isHeads ? "Heads" : "Tails")
    }
}

private struct TallyView: View {
    let label: String
    let count: Int

    var body: some View {
        Card(padding: 14) {
            VStack(spacing: 2) {
                Text("\(count)")
                    .font(.title.weight(.semibold).monospacedDigit())
                    .contentTransition(.numericText())
                Text(label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    CoinFlipView()
}
