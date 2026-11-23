//
//  CardDrawView.swift
//  Randomiser
//
//  Draw playing cards from a shuffled 52-card deck.
//

import SwiftUI

struct PlayingCard: Identifiable, Hashable {
    enum Suit: String, CaseIterable {
        case spades = "♠", hearts = "♥", diamonds = "♦", clubs = "♣"

        var isRed: Bool { self == .hearts || self == .diamonds }
        var name: String {
            switch self {
            case .spades: "Spades"
            case .hearts: "Hearts"
            case .diamonds: "Diamonds"
            case .clubs: "Clubs"
            }
        }
    }

    static let ranks = ["A", "2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K"]
    private static let rankNames = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven",
                                    "Eight", "Nine", "Ten", "Jack", "Queen", "King"]

    let rank: String
    let suit: Suit
    var id: String { rank + suit.rawValue }

    var name: String {
        let rankName = Self.rankNames[Self.ranks.firstIndex(of: rank) ?? 0]
        return "\(rankName) of \(suit.name)"
    }

    static func fullDeck() -> [PlayingCard] {
        Suit.allCases.flatMap { suit in ranks.map { PlayingCard(rank: $0, suit: suit) } }
    }
}

struct CardDrawView: View {
    @State private var deck = PlayingCard.fullDeck().shuffled()
    @State private var current: PlayingCard?
    @State private var drawn: [PlayingCard] = []

    func draw() {
        guard !deck.isEmpty else { return }
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            let card = deck.removeLast()
            current = card
            drawn.insert(card, at: 0)
        }
    }

    func shuffle() {
        withAnimation {
            deck = PlayingCard.fullDeck().shuffled()
            current = nil
            drawn = []
        }
    }

    var body: some View {
        ToolScreen(title: "Card Draw",
                   subtitle: "Draw cards from a shuffled 52-card deck.",
                   symbol: "suit.spade.fill",
                   tint: .indigo) {
            Card(padding: 28) {
                VStack(spacing: 18) {
                    ZStack {
                        if let current {
                            PlayingCardView(card: current)
                                .id(current.id)
                                .transition(.asymmetric(insertion: .move(edge: .top).combined(with: .opacity),
                                                        removal: .opacity))
                        } else {
                            CardBack()
                        }
                    }
                    .frame(width: 150, height: 210)

                    Text(current?.name ?? (deck.isEmpty ? "The deck is empty" : "Ready to draw"))
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(current == nil ? .secondary : .primary)

                    Text("\(deck.count) of 52 cards left")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }

            HStack(spacing: 12) {
                Button("Draw Card", systemImage: "hand.draw", action: draw)
                    .buttonStyle(.primary(.indigo))
                    .focusEffectDisabled()
                    .keyboardShortcut(.defaultAction)
                    .disabled(deck.isEmpty)

                Button("Shuffle", systemImage: "shuffle", action: shuffle)
                    .buttonStyle(.secondaryAction)
                    .focusEffectDisabled()
            }

            if drawn.count > 1 {
                VStack(spacing: 10) {
                    Text("Drawn so far")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 44), spacing: 8)], spacing: 8) {
                        ForEach(drawn.dropFirst()) { card in
                            Text(card.rank + card.suit.rawValue)
                                .font(.body.weight(.semibold).monospacedDigit())
                                .foregroundStyle(card.suit.isRed ? Color.red : Color.primary)
                                .frame(width: 44, height: 30)
                                .background(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .fill(Color(nsColor: .controlBackgroundColor))
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                                        .strokeBorder(Color(nsColor: .separatorColor))
                                )
                        }
                    }
                }
            }
        }
    }
}

private struct PlayingCardView: View {
    let card: PlayingCard

    var body: some View {
        let colour: Color = card.suit.isRed ? Color(red: 0.8, green: 0.1, blue: 0.15) : .black

        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .strokeBorder(.black.opacity(0.2))

            Text(card.suit.rawValue)
                .font(.system(size: 72))

            VStack {
                HStack {
                    corner
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    corner.rotationEffect(.degrees(180))
                }
            }
            .padding(10)
        }
        .foregroundStyle(colour)
        .accessibilityElement()
        .accessibilityLabel(card.name)
    }

    private var corner: some View {
        VStack(spacing: -2) {
            Text(card.rank).font(.title3.weight(.bold))
            Text(card.suit.rawValue).font(.body)
        }
    }
}

private struct CardBack: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color.indigo)
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .strokeBorder(.white.opacity(0.5), lineWidth: 2)
                    .padding(10)
            )
            .overlay(
                Image(systemName: "suit.spade.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(.white.opacity(0.7))
            )
    }
}

#Preview {
    CardDrawView()
}
