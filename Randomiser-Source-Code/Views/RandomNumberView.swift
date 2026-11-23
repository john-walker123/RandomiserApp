//
//  RandomNumberView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct RandomNumberView: View {

    @State private var minNumber: String = "1"
    @State private var maxNumber: String = "100"
    @State private var randomNumber: Int?
    @State private var errorMessage: String?

    func generate() {
        let trimmedMin = minNumber.trimmingCharacters(in: .whitespaces)
        let trimmedMax = maxNumber.trimmingCharacters(in: .whitespaces)

        guard let min = Int(trimmedMin), let max = Int(trimmedMax) else {
            withAnimation { errorMessage = "Please enter whole numbers in both boxes." }
            return
        }
        guard min <= max else {
            withAnimation { errorMessage = "The minimum can't be bigger than the maximum." }
            return
        }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
            errorMessage = nil
            randomNumber = Int.random(in: min...max)
        }
    }

    var body: some View {
        ToolScreen(title: "Random Number",
                   subtitle: "Pick a random whole number between two values.",
                   symbol: "number",
                   tint: .purple) {
            Card(padding: 28) {
                VStack(spacing: 6) {
                    Text(randomNumber.map { "\($0)" } ?? "?")
                        .font(.system(size: 64, weight: .semibold).monospacedDigit())
                        .foregroundStyle(randomNumber == nil ? .tertiary : .primary)
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .textSelection(.enabled)
                    Text(randomNumber == nil ? "Your number will appear here" : "Your random number")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(alignment: .top, spacing: 16) {
                LabeledInput(label: "Minimum") {
                    TextField("e.g. 1", text: $minNumber)
                        .onSubmit(generate)
                }
                LabeledInput(label: "Maximum") {
                    TextField("e.g. 100", text: $maxNumber)
                        .onSubmit(generate)
                }
            }

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }

            Button("Generate", systemImage: "sparkles", action: generate)
                .buttonStyle(.primary(.purple))
                .focusEffectDisabled()
        }
    }
}

#Preview {
    RandomNumberView()
}
