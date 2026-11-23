//
//  MenuView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct MenuView: View {
    private let columns = [GridItem(.adaptive(minimum: 220, maximum: 320), spacing: 14)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Randomiser")
                            .font(.largeTitle.weight(.bold))
                        Text("Useful everyday tools, all in one place.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    LazyVGrid(columns: columns, spacing: 14) {
                        NavigationLink {
                            DiceRollerView()
                        } label: {
                            ToolCard(title: "Dice Roller",
                                     subtitle: "Roll a six-sided die",
                                     symbol: "dice.fill",
                                     tint: .blue)
                        }

                        NavigationLink {
                            CoinFlipView()
                        } label: {
                            ToolCard(title: "Coin Flip",
                                     subtitle: "Heads or tails",
                                     symbol: "circle.lefthalf.filled",
                                     tint: .green)
                        }

                        NavigationLink {
                            RandomNumberView()
                        } label: {
                            ToolCard(title: "Random Number",
                                     subtitle: "Pick a number in any range",
                                     symbol: "number",
                                     tint: .purple)
                        }

                        NavigationLink {
                            CurrencyConverterView()
                        } label: {
                            ToolCard(title: "Currency Converter",
                                     subtitle: "Custom exchange rate",
                                     symbol: "arrow.left.arrow.right",
                                     tint: .red)
                        }

                        NavigationLink {
                            PasswordGeneratorView()
                        } label: {
                            ToolCard(title: "Password Generator",
                                     subtitle: "Memorable passwords",
                                     symbol: "key.fill",
                                     tint: .orange)
                        }
                    }
                    .buttonStyle(.plain)
                    .focusEffectDisabled()
                }
                .frame(maxWidth: 960, alignment: .leading)
                .padding(32)
                .frame(maxWidth: .infinity)
            }
            .background(Color(nsColor: .windowBackgroundColor))
        }
        .frame(minWidth: 520, minHeight: 460)
    }
}

/// A clickable tile on the home screen.
struct ToolCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let tint: Color

    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 14) {
            IconBadge(symbol: symbol, tint: tint, size: 40)

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
        .padding(16)
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
