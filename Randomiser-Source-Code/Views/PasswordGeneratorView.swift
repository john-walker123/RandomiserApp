//
//  PasswordGeneratorView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI; import AppKit

struct PasswordGeneratorView: View{

    @State private var password = ""
    @State private var hasCopied = false

    var adjectives = [
        "Adorable", "Affectionate", "Agreeable", "Amiable", "Angelic",
        "Bright", "Brilliant", "Charming", "Cheerful", "Compassionate",
        "Delightful", "Dazzling", "Ebullient", "Enchanting", "Friendly",
        "Gentle", "Graceful", "Harmonious", "Inspiring", "Joyful",
        "Kindhearted", "Lovely", "Radiant", "Thoughtful", "Vibrant"
    ]

    var colours = [
        "Red", "Blue", "Green", "Yellow", "Orange",
        "Purple", "Pink", "Black", "White", "Gray",
        "Brown", "Silver", "Gold"
    ]

    var nouns = [
        "Anchor", "Balloon", "Blossom", "Breeze", "Butterfly", "Candle", "Cheetah", "Compass",
        "Diamond", "Dolphin", "Eagle", "Elephant", "Feather", "Forest", "Garden", "Horizon",
        "Kitten", "Meadow", "Ocean", "Otter", "Pebble", "Rainbow", "River", "Sapphire"
    ]

    var punctuations = [
        ",", "!", "?", ";", ":", "-", "—",
        "(", ")", "[", "]", "{", "}",
        "/", "\\", "|", "@", "#", "$", "%",
        "^", "&", "*", "+", "=", "<", ">", "~"
    ]

    func makePassword() {
        password =
        adjectives.randomElement()!
        + colours.randomElement()!
        + nouns.randomElement()!
        + punctuations.randomElement()!
        + String(Int.random(in: 1...1000))
    }

    func copyPassword() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(password, forType: .string)
        withAnimation { hasCopied = true }
    }

    var body: some View {
        ToolScreen(title: "Password Generator",
                   subtitle: "Create a memorable password from friendly words.",
                   symbol: "key.fill",
                   tint: .orange) {
            Card(padding: 26) {
                VStack(spacing: 10) {
                    Text("Your password")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                    Text(password.isEmpty ? "Press Generate to begin" : password)
                        .font(password.isEmpty
                              ? .title3
                              : .system(.title2, design: .monospaced, weight: .semibold))
                        .foregroundStyle(password.isEmpty ? AnyShapeStyle(.tertiary) : AnyShapeStyle(.primary))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.6)
                        .textSelection(.enabled)
                        .padding(.vertical, 14)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(.primary.opacity(0.05))
                        )
                        .contentTransition(.opacity)

                    Button(action: copyPassword) {
                        Label(hasCopied ? "Copied!" : "Copy",
                              systemImage: hasCopied ? "checkmark" : "doc.on.doc")
                            .foregroundStyle(hasCopied ? Color.green : Color.primary)
                    }
                    .buttonStyle(.secondaryAction)
                    .focusEffectDisabled()
                    .disabled(password.isEmpty)
                    .opacity(password.isEmpty ? 0.4 : 1)
                }
            }

            Button("Generate Password", systemImage: "wand.and.stars") {
                withAnimation(.easeInOut(duration: 0.2)) {
                    makePassword()
                    hasCopied = false
                }
            }
            .buttonStyle(.primary(.orange))
            .focusEffectDisabled()
            .keyboardShortcut(.defaultAction)
        }
    }
}

#Preview{
    PasswordGeneratorView()
}
