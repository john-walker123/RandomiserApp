//
//  TeamGeneratorView.swift
//  Randomiser
//
//  Split a list of names into random, evenly sized teams.
//

import SwiftUI; import AppKit

struct TeamGeneratorView: View {
    @State private var namesText = "Alex\nSam\nJordan\nTaylor\nCasey\nRiley\nMorgan\nJamie"
    @State private var teamCount = 2
    @State private var teams: [[String]] = []
    @State private var errorMessage: String?
    @State private var hasCopied = false

    private var names: [String] {
        namesText
            .split(whereSeparator: \.isNewline)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    func makeTeams() {
        let people = names.shuffled()
        guard people.count >= teamCount else {
            withAnimation { errorMessage = "You need at least \(teamCount) names for \(teamCount) teams." }
            return
        }

        var result = Array(repeating: [String](), count: teamCount)
        for (index, person) in people.enumerated() {
            result[index % teamCount].append(person)
        }

        withAnimation(.spring(response: 0.35, dampingFraction: 0.85)) {
            errorMessage = nil
            teams = result
            hasCopied = false
        }
    }

    func copyTeams() {
        let text = teams.enumerated()
            .map { "Team \($0.offset + 1): " + $0.element.joined(separator: ", ") }
            .joined(separator: "\n")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        withAnimation { hasCopied = true }
    }

    var body: some View {
        ToolScreen(title: "Team Generator",
                   subtitle: "Enter one name per line and split them into random teams.",
                   symbol: "person.3.fill",
                   tint: .teal) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("Names")
                    Spacer()
                    Text("\(names.count) people")
                        .monospacedDigit()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)

                TextEditor(text: $namesText)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .frame(height: 160)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color(nsColor: .textBackgroundColor))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .strokeBorder(Color(nsColor: .separatorColor))
                    )
            }

            Stepper(value: $teamCount, in: 2...10) {
                Text("Number of teams: **\(teamCount)**")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let errorMessage {
                Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                    .font(.subheadline)
                    .foregroundStyle(.red)
            }

            Button("Make Teams", systemImage: "shuffle", action: makeTeams)
                .buttonStyle(.primary(.teal))
                .focusEffectDisabled()

            if !teams.isEmpty {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 180), spacing: 12)], spacing: 12) {
                    ForEach(Array(teams.enumerated()), id: \.offset) { index, team in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Team \(index + 1)")
                                .font(.headline)
                            ForEach(team, id: \.self) { person in
                                Text(person)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(14)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(nsColor: .controlBackgroundColor))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color(nsColor: .separatorColor))
                        )
                    }
                }

                Button(action: copyTeams) {
                    Label(hasCopied ? "Copied!" : "Copy teams",
                          systemImage: hasCopied ? "checkmark" : "doc.on.doc")
                        .foregroundStyle(hasCopied ? Color.green : Color.primary)
                }
                .buttonStyle(.secondaryAction)
                .focusEffectDisabled()
            }
        }
    }
}

#Preview {
    TeamGeneratorView()
}
