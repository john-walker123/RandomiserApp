//
//  DecisionMakerView.swift
//  Randomiser
//
//  Ask a question and get a random answer.
//

import SwiftUI

struct DecisionMakerView: View {
    enum Mode: String, CaseIterable, Identifiable {
        case yesNo = "Yes / No"
        case yesNoMaybe = "Yes / No / Maybe"
        case fortune = "Fortune"
        var id: Self { self }

        var answers: [String] {
            switch self {
            case .yesNo:
                ["Yes", "No"]
            case .yesNoMaybe:
                ["Yes", "No", "Maybe"]
            case .fortune:
                ["It is certain", "Without a doubt", "Yes, definitely", "Most likely",
                 "Outlook good", "Signs point to yes", "Ask again later", "Better not tell you now",
                 "Cannot predict now", "Concentrate and ask again", "Don't count on it",
                 "My reply is no", "Very doubtful", "Outlook not so good"]
            }
        }
    }

    @State private var mode: Mode = .yesNo
    @State private var question = ""
    @State private var answer: String?
    @State private var askedQuestion = ""
    @State private var isThinking = false

    func ask() {
        guard !isThinking else { return }
        isThinking = true
        askedQuestion = question.trimmingCharacters(in: .whitespacesAndNewlines)

        Task { @MainActor in
            withAnimation { answer = nil }
            try? await Task.sleep(nanoseconds: 600_000_000)
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                answer = mode.answers.randomElement()
            }
            isThinking = false
        }
    }

    private var answerColour: Color {
        switch answer {
        case "Yes": .green
        case "No": .red
        case "Maybe": .orange
        default: .primary
        }
    }

    var body: some View {
        ToolScreen(title: "Yes or No",
                   subtitle: "Can't decide? Ask a question and get an answer.",
                   symbol: "questionmark.bubble.fill",
                   tint: .mint) {
            Picker("Answer type", selection: $mode) {
                ForEach(Mode.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.segmented)
            .labelsHidden()

            LabeledInput(label: "Your question (optional)") {
                TextField("Should I order pizza tonight?", text: $question)
                    .onSubmit(ask)
            }

            Card(padding: 28) {
                VStack(spacing: 10) {
                    if !askedQuestion.isEmpty, answer != nil || isThinking {
                        Text("“\(askedQuestion)”")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    if isThinking {
                        ProgressView()
                            .controlSize(.small)
                            .frame(height: 50)
                    } else if let answer {
                        Text(answer)
                            .font(.system(size: mode == .fortune ? 30 : 44, weight: .bold))
                            .foregroundStyle(answerColour)
                            .multilineTextAlignment(.center)
                            .transition(.scale(scale: 0.8).combined(with: .opacity))
                    } else {
                        Text("Your answer will appear here")
                            .font(.title3)
                            .foregroundStyle(.tertiary)
                            .frame(height: 50)
                    }
                }
                .frame(minHeight: 90)
            }

            Button("Ask", systemImage: "sparkles", action: ask)
                .buttonStyle(.primary(.mint))
                .focusEffectDisabled()
                .disabled(isThinking)
        }
    }
}

#Preview {
    DecisionMakerView()
}
