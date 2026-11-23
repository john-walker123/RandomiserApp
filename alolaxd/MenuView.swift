//
//  MenuView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 28) {
                    VStack(spacing: 4) {
                        Text("Randomiser")
                            .font(.largeTitle.weight(.bold))
                        Text("Useful everyday tools, all in one place.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.center)

                    MenuSection(title: "Chance") {
                        ToolLink(title: "Dice Roller", subtitle: "Roll a six-sided die",
                                 symbol: "dice.fill", tint: .blue) { DiceRollerView() }
                        ToolLink(title: "Coin Flip", subtitle: "Heads or tails",
                                 symbol: "circle.lefthalf.filled", tint: .green) { CoinFlipView() }
                        ToolLink(title: "Spin the Wheel", subtitle: "Let the wheel choose for you",
                                 symbol: "chart.pie.fill", tint: .pink) { WheelSpinnerView() }
                        ToolLink(title: "Card Draw", subtitle: "Draw from a shuffled deck",
                                 symbol: "suit.spade.fill", tint: .indigo) { CardDrawView() }
                        ToolLink(title: "Yes or No", subtitle: "Ask a question, get an answer",
                                 symbol: "questionmark.bubble.fill", tint: .mint) { DecisionMakerView() }
                    }

                    MenuSection(title: "Generators") {
                        ToolLink(title: "Random Number", subtitle: "Pick a number in any range",
                                 symbol: "number", tint: .purple) { RandomNumberView() }
                        ToolLink(title: "Password Generator", subtitle: "Memorable passwords",
                                 symbol: "key.fill", tint: .orange) { PasswordGeneratorView() }
                        ToolLink(title: "Team Generator", subtitle: "Split names into random teams",
                                 symbol: "person.3.fill", tint: .teal) { TeamGeneratorView() }
                        ToolLink(title: "Random Colour", subtitle: "Discover a new colour",
                                 symbol: "paintpalette.fill", tint: .brown) { ColourGeneratorView() }
                    }

                    MenuSection(title: "Utilities") {
                        ToolLink(title: "Currency Converter", subtitle: "Live exchange rates",
                                 symbol: "arrow.left.arrow.right", tint: .red) { CurrencyConverterView() }
                    }
                }
                .frame(maxWidth: 440)
                .padding(32)
                .frame(maxWidth: .infinity)
            }
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .frame(minWidth: 480, minHeight: 520)
    }
}

/// A titled group of tools in the vertical list.
private struct MenuSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.leading, 4)
            VStack(spacing: 10) {
                content
            }
        }
    }
}

/// A home screen row that opens a tool.
private struct ToolLink<Destination: View>: View {
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color
    @ViewBuilder var destination: () -> Destination

    var body: some View {
        NavigationLink {
            destination()
        } label: {
            ToolCard(title: title, subtitle: subtitle, symbol: symbol, tint: tint)
        }
        .buttonStyle(.plain)
        .focusEffectDisabled()
    }
}

/// A clickable row on the home screen.
struct ToolCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 14) {
            IconBadge(symbol: symbol, tint: tint, size: 38)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(isHovered
                      ? Color(nsColor: .unemphasizedSelectedContentBackgroundColor)
                      : Color(nsColor: .controlBackgroundColor))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(Color(nsColor: .separatorColor))
        )
        .contentShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .onHover { isHovered = $0 }
    }
}

#Preview {
    MenuView()
}
