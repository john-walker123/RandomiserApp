//
//  CurrencyConverterView.swift
//  Randomiser
//
//  Created by Pradyumna Bharadwaj on 09/11/2026.
//

import SwiftUI

struct CurrencyConverterView: View {
    @State private var firstCurrency: Double = 0.0
    @State private var conversionRate: Double = 0.0

    private var secondCurrency: Double {
        firstCurrency * conversionRate
    }

    var body: some View {
        ToolScreen(title: "Currency Converter",
                   subtitle: "Convert an amount using any exchange rate.",
                   symbol: "arrow.left.arrow.right",
                   tint: .red) {
            VStack(spacing: 16) {
                LabeledInput(label: "Amount (currency 1)") {
                    TextField("0", value: $firstCurrency, format: .number)
                }
                LabeledInput(label: "Exchange rate (1 unit of currency 1 = ? currency 2)") {
                    TextField("0", value: $conversionRate, format: .number)
                }
            }

            Image(systemName: "arrow.down")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.secondary)

            Card(padding: 26) {
                VStack(spacing: 6) {
                    Text(secondCurrency, format: .number.precision(.fractionLength(0...3)))
                        .font(.system(size: 48, weight: .semibold).monospacedDigit())
                        .contentTransition(.numericText())
                        .lineLimit(1)
                        .minimumScaleFactor(0.4)
                        .textSelection(.enabled)
                    Text("Amount in currency 2")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .animation(.snappy, value: secondCurrency)
        }
    }
}

#Preview {
    CurrencyConverterView()
}
